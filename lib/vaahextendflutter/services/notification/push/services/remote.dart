import 'dart:async';
import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../../../env/env.dart';
import '../../../deep_link.dart';
import '../../../logging_library/logging_library.dart';
import '../../models/notification.dart';

const String _userIdKey = 'remote_notification_user_id';

abstract class RemoteNotifications {
  static final EnvironmentConfig _env = EnvironmentConfig.getConfig;
  static final GetStorage _storage = GetStorage();

  // Not final so [dispose] can close + recreate it, keeping the service re-initializable.
  static StreamController<String> _userIdStreamController =
      StreamController<String>.broadcast();

  /// Emits the OneSignal user-level ID (`onesignalId`) when it changes.
  ///
  /// This is a broadcast stream and does not buffer: an ID set before a
  /// listener attaches is not replayed to it. Read [userId] for the current
  /// value, then listen here for subsequent changes.
  static Stream<String> get userIdStream => _userIdStreamController.stream;

  // Stable tear-off so [dispose] can remove the exact observer [init] registered.
  static final void Function(OSUserChangedState) _userObserver = _onUserChanged;

  // Not final so [dispose] can close + recreate it (see [_userIdStreamController]).
  static StreamController<DeepLink> _notificationDeepLinkController =
      StreamController<DeepLink>();

  /// Decoded deep-link payloads from OneSignal notification clicks.
  ///
  /// This service only decodes + emits — it never navigates. The app listens
  /// and validates [DeepLink.path] against its route allowlist (the same
  /// contract as [DynamicLinks.dynamicLinksStream]).
  static Stream<DeepLink> get notificationDeepLinkStream =>
      _notificationDeepLinkController.stream;

  static String? get userId => _storage.read(_userIdKey);

  static Future<void> init() async {
    if (_env.oneSignalConfig == null) return;
    if (_storage.read(_userIdKey) != null) {
      _userIdStreamController.add(_storage.read(_userIdKey));
    }

    OneSignal.Debug.setLogLevel(OSLogLevel.warn);

    OneSignal.initialize(_env.oneSignalConfig!.appId);

    // Observe the OneSignal user so userId holds the user-level ID, not the push token.
    OneSignal.User.addObserver(_userObserver);

    // Listen to notification click events
    OneSignal.Notifications.addClickListener(_handleNotificationClick);
  }

  static void _onUserChanged(OSUserChangedState state) {
    final String? oneSignalId = state.current.onesignalId;
    if (oneSignalId != null && oneSignalId.isNotEmpty) {
      _storage.write(_userIdKey, oneSignalId);
      _userIdStreamController.add(oneSignalId);
    }
  }

  static void dispose() {
    OneSignal.User.removeObserver(_userObserver);
    OneSignal.Notifications.removeClickListener(_handleNotificationClick);
    _userIdStreamController.close();
    _userIdStreamController = StreamController<String>.broadcast();
    _notificationDeepLinkController.close();
    _notificationDeepLinkController = StreamController<DeepLink>();
  }

  static Future<bool?> askPermission() async {
    if (_env.oneSignalConfig == null) return null;
    return await OneSignal.Notifications.requestPermission(true);
  }

  static Future<void> subscribe({
    required String userid,
    String? email,
    String? phone,
  }) async {
    // Link the device to the app user so user-targeted pushes work.
    await OneSignal.login(userid);
    if (email != null) await OneSignal.User.addEmail(email);
    if (phone != null) await OneSignal.User.addSms(phone);
    OneSignal.User.pushSubscription.optIn();
  }

  static Future<void> unsubscribe() async {
    OneSignal.User.pushSubscription.optOut();
    await OneSignal.logout();
  }

  /// No-op: notifications must be sent via the OneSignal backend REST API.
  static Future<void> push({
    required PushNotification notification,
    String? channel,
  }) async {
    Log.warning(
      'Remote push unavailable client-side (OneSignal v5); send via backend REST API',
      data: {'heading': notification.heading, 'channel': channel},
    );
  }

  static void _handleNotificationClick(OSNotificationClickEvent event) {
    // Log only display fields; additionalData carries the payload (incl. auth) and must not be logged.
    Log.success('Notification Opened', data: {
      "actionId": event.result.actionId,
      "title": event.notification.title,
      "body": event.notification.body,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    });

    // Emit the decoded payload; the app validates path against its route allowlist and navigates.
    final DeepLink? link = _decodePayload(event.notification.additionalData);
    if (link != null) {
      _notificationDeepLinkController.add(link);
    }
  }

  /// Decodes additionalData['payload'] into a [DeepLink], or null if absent or malformed.
  static DeepLink? _decodePayload(Map<String, dynamic>? additionalData) {
    final dynamic raw = additionalData?['payload'];
    if (raw == null) return null;

    // additionalData values arrive as JSON strings (an already-decoded map is tolerated).
    dynamic payload = raw;
    if (raw is String) {
      try {
        payload = jsonDecode(raw);
      } catch (error, stackTrace) {
        Log.exception(
          'Error decoding notification payload',
          throwable: error,
          stackTrace: stackTrace,
        );
        return null;
      }
    }
    if (payload is! Map) return null;

    final dynamic path = payload['path'];
    if (path is! String || path.isEmpty) return null;
    return DeepLink(
      path: path,
      data: payload['data'],
      auth: payload['auth'],
    );
  }
}
