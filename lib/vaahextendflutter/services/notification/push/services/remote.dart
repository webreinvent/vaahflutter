import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../../../env/env.dart';
import '../../../deep_link.dart';
import '../../../logging_library/logging_library.dart';
import '../../models/notification.dart';

abstract class RemoteNotifications {
  static final EnvironmentConfig _env = EnvironmentConfig.getConfig;

  // Not final so [dispose] can close + recreate it, keeping the service re-initializable.
  static StreamController<DeepLink> _notificationDeepLinkController =
      StreamController<DeepLink>();

  /// Decoded deep links from notification clicks; the app validates the path and navigates.
  static Stream<DeepLink> get notificationDeepLinkStream =>
      _notificationDeepLinkController.stream;

  static Future<void> init() async {
    if (_env.oneSignalConfig == null) return;

    if (kDebugMode) {
      await OneSignal.Debug.setLogLevel(OSLogLevel.info);
    } else {
      await OneSignal.Debug.setLogLevel(OSLogLevel.none);
    }

    OneSignal.initialize(_env.oneSignalConfig!.appId);

    OneSignal.Notifications.addForegroundWillDisplayListener(_handleWillDisplayNotification);
    OneSignal.Notifications.addClickListener(_handleNotificationClick);
  }

  static void dispose() {
    OneSignal.Notifications.removeForegroundWillDisplayListener(_handleWillDisplayNotification);
    OneSignal.Notifications.removeClickListener(_handleNotificationClick);
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
    Log.exception(
      'remote-push-unavailable-client-side-onesignal-v5',
      hint: {
        'reason': 'send-via-backend-rest-api',
        'heading': notification.heading,
        'channel': channel,
      },
    );
  }

  static void _handleWillDisplayNotification(OSNotificationWillDisplayEvent event) {}

  static void _handleNotificationClick(OSNotificationClickEvent event) {
    // Log only display fields; additionalData carries the payload (incl. auth) and must not be logged.
    Log.success('Notification Opened', data: {
      "actionId": event.result.actionId,
      "title": event.notification.title,
      "body": event.notification.body,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    });

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
      } catch (_) {
        // Do not log the raw throwable: a jsonDecode FormatException embeds the full
        // payload string (incl. auth), which must never reach logs.
        Log.warning('Notification payload is not valid JSON; ignoring deep link');
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
