import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../../../env.dart';
import '../../../logging_library/logging_library.dart';
import '../../models/notification.dart';

const String _userIdKey = 'remote_notification_user_id';
const Map<String, String> channels = {
  // Create a channel on One Signal and add id here
  'Primary': 'channel_id'
};

abstract class RemoteNotifications {
  static final EnvironmentConfig _env = EnvironmentConfig.getEnvConfig();
  static final GetStorage _storage = GetStorage();

  static final StreamController<String> _userIdStreamController =
  StreamController<String>.broadcast();
  static final Stream<String> userIdStream = _userIdStreamController.stream;

  static String? get userId => _storage.read(_userIdKey);

  static Future<void> init() async {
    if (_env.oneSignalConfig == null) return;
    if (_storage.read(_userIdKey) != null) {
      _userIdStreamController.add(_storage.read(_userIdKey));
    }

    // Set Log Level in v5
    OneSignal.Debug.setLogLevel(OSLogLevel.warn);

    // Initialize App in v5
    await OneSignal.initialize(_env.oneSignalConfig!.appId);

    // Listen to the OneSignal user so `userId` holds the user-level ID
    // (state.current.onesignalId), not the device push-subscription token.
    OneSignal.User.addObserver((state) {
      final String? oneSignalId = state.current.onesignalId;
      if (oneSignalId != null && oneSignalId.isNotEmpty) {
        _storage.write(_userIdKey, oneSignalId);
        _userIdStreamController.add(oneSignalId);
      }
    });

    // Listen to notification click events
    OneSignal.Notifications.addClickListener(_handleNotificationClick);
  }

  static void dispose() {
    _userIdStreamController.close();
  }

  static Future<bool?> askPermission() async {
    if (_env.oneSignalConfig == null) return null;
    return await OneSignal.Notifications.requestPermission(true);
  }

  static Future<void> subscribe() async {
    OneSignal.User.pushSubscription.optIn();
  }

  static Future<void> unsubscribe() async {
    OneSignal.User.pushSubscription.optOut();
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
    Log.success('Notification Opened', data: {
      "actionId": event.result.actionId,
      "title": event.notification.title,
      "body": event.notification.body,
      "additionalData": event.notification.additionalData,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    });

    final dynamic payload = event.notification.additionalData?['payload'];
    if (payload != null && payload['path'] != null) {
      Get.to(
        payload['path'],
        arguments: <String, dynamic>{
          'data': payload['data'],
          'auth': payload['auth'],
        },
      );
    }
  }
}