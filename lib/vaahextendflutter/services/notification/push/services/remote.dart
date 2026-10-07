import 'dart:async';
import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../../../env/env.dart';
import '../../../dynamic_links.dart';
import '../../../logging_library/logging_library.dart';
import '../../models/notification.dart';

const String _userIdKey = 'remote_notification_user_id';
const Map<String, String> channels = {
  // Create a channel on One Signal and add id here
  'Primary': 'channel_id'
};

abstract class RemoteNotifications {
  static final EnvironmentConfig _env = EnvironmentConfig.getConfig;
  static final GetStorage _storage = GetStorage();

  // Not final so [dispose] can close + recreate it, keeping the service
  // re-initializable (tests, hot restart) — same pattern as [DynamicLinks].
  // A subsequent init() would otherwise add to a closed controller (StateError).
  static StreamController<String> _userIdStreamController =
      StreamController<String>.broadcast();

  /// Emits the OneSignal user-level ID (`onesignalId`) when it changes.
  ///
  /// This is a broadcast stream and does not buffer: an ID set before a
  /// listener attaches is not replayed to it. Read [userId] for the current
  /// value, then listen here for subsequent changes.
  static Stream<String> get userIdStream => _userIdStreamController.stream;

  // Stable observer reference (a single tear-off of [_onUserChanged]) so
  // [dispose] can remove the exact callback [init] registered — OneSignal
  // matches observers by identity, and a leaked observer would fire into the
  // closed [userIdStream] controller after teardown (StateError).
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

    // Set Log Level in v5
    OneSignal.Debug.setLogLevel(OSLogLevel.warn);

    // Initialize App in v5
    OneSignal.initialize(_env.oneSignalConfig!.appId);

    // Listen to the OneSignal user so `userId` holds the user-level ID
    // (state.current.onesignalId), not the device push-subscription token.
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

  /// Note: Client-side notification creation is deprecated in OneSignal v5.
  /// Notifications should be sent via backend API.
  static Future<void> push({
    required PushNotification notification,
    String? channel,
  }) async {
    // Client-side postNotification was removed in OneSignal v5. Pushes must be
    // dispatched server-side via the OneSignal REST API from your backend.
    Log.warning(
      'Remote push unavailable client-side (OneSignal v5); send via backend REST API',
      data: {'heading': notification.heading, 'channel': channel},
    );
  }

  static void _handleNotificationClick(OSNotificationClickEvent event) {
    // Log only the safe display fields. `additionalData` carries the deep-link
    // payload (incl. `auth`), which must never be written to logs — the same
    // no-auth-in-logs policy the DynamicLinks service enforces.
    Log.success('Notification Opened', data: {
      "actionId": event.result.actionId,
      "title": event.notification.title,
      "body": event.notification.body,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    });

    // Decode the payload and emit it; the app validates `path` against its
    // route allowlist and navigates. This service never navigates — the same
    // contract as [DynamicLinks] — so an untrusted `path` can't reach GetX.
    final DeepLink? link = _decodePayload(event.notification.additionalData);
    if (link != null) {
      _notificationDeepLinkController.add(link);
    }
  }

  /// Decodes OneSignal's `additionalData['payload']` (a JSON object with
  /// `path`/`data`/`auth`) into a [DeepLink], or null if there is no payload
  /// or it is malformed. An OneSignal click has no originating URL, so
  /// [DeepLink.uri] is null.
  static DeepLink? _decodePayload(Map<String, dynamic>? additionalData) {
    final dynamic raw = additionalData?['payload'];
    if (raw == null) return null;

    // OneSignal delivers additionalData values as strings, so the payload is a
    // JSON string; tolerate an already-decoded map too.
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
