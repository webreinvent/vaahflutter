import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../../../env/env.dart';
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

  static final StreamController<String> _userIdStreamController =
  StreamController<String>.broadcast();
  static final Stream<String> userIdStream = _userIdStreamController.stream;

  // Stable tear-off so [dispose] can remove the exact observer [init] registered.
  static final void Function(OSUserChangedState) _userObserver = _onUserChanged;

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
    _userIdStreamController.close();
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
