import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../../../env/env.dart';
import '../../../logging_library/logging_library.dart';
import '../../models/notification.dart';

const String _userIdKey = 'remote_notification_user_id';
const Map<String, String> channels = {
  //  Create a channel on One Signal and add id here
  'Primary': 'channel_id'
};

abstract class RemoteNotifications {
  static final OneSignal _oneSignal = OneSignal.shared;
  static final EnvironmentConfig _env = EnvironmentConfig.getConfig;
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
    _oneSignal.setSubscriptionObserver(_handleSubscriptionStateChanges);
    await _oneSignal.setLogLevel(OSLogLevel.warn, OSLogLevel.none);
    await _oneSignal.setAppId(_env.oneSignalConfig!.appId);
    _oneSignal.setNotificationOpenedHandler(_handleNotification);
  }

  static void dispose() {
    _userIdStreamController.close();
  }

  static Future<bool?> askPermission() async {
    if (_env.oneSignalConfig == null) return null;
    return await _oneSignal.promptUserForPushNotificationPermission();
  }

  static Future<void> subscribe() async {
    await _oneSignal.disablePush(false);
  }

  static Future<void> unsubscribe() async {
    await _oneSignal.disablePush(true);
  }

  static Future<void> push({
    required PushNotification notification,
    String? channel,
  }) async {
    assert(notification.playerIds.isNotEmpty);
    await _oneSignal.postNotification(
      OSCreateNotification(
        playerIds: notification.playerIds,
        heading: notification.heading,
        content: notification.content,
        additionalData: {
          'payload': {
            'path': notification.payloadPath,
            'data': notification.payloadData,
            'auth': notification.payloadAuth,
          },
        },
        buttons: notification.buttons
            ?.map(
              (element) => OSActionButton(
                id: element.id,
                text: element.text,
                icon: element.icon,
              ),
            )
            .toList(),
        bigPicture: notification.imageUrl,
        iosAttachments: notification.imageUrl == null
            ? null
            : {
                'image': notification.imageUrl!,
              },
        androidChannelId: channels[channel],
        sendAfter: notification.sendAfter,
      ),
    );
  }

  static Future<void> _handleSubscriptionStateChanges(
    OSSubscriptionStateChanges subscriptionState,
  ) async {
    if (subscriptionState.to.userId != null) {
      await _storage.write(_userIdKey, subscriptionState.to.userId);
      _userIdStreamController.add(subscriptionState.to.userId!);
    }
  }

  static void _handleNotification(OSNotificationOpenedResult openedResult) {
    Log.success('Notification Opened', data: {
      "actionId": openedResult.action?.actionId,
      "title": openedResult.notification.title,
      "body": openedResult.notification.body,
      "additionalData": openedResult.notification.additionalData,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    });
    final dynamic payload = openedResult.notification.additionalData?['payload'];
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
