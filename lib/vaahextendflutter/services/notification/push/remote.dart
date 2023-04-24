import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import './models/notification.dart';
import '../../../env.dart';
import '../../logging_library/logging_library.dart';

const String _userIdKey = 'remote_notification_user_id';
const Map<String, String> channels = {
  //  Create a channel on One Signal and add id here
  'Primary': 'channel_id'
};

abstract class RemoteNotifications {
  static final OneSignal _oneSignal = OneSignal.shared;
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
    required List<String> playerIds,
    String? heading,
    required String content,
    String? payloadPath,
    dynamic payloadData,
    dynamic payloadAuth,
    List<NotificationButton>? buttons,
    String? imageURL,
    DateTime? sendAfter,
    String? channel,
  }) async {
    assert(playerIds.isNotEmpty);
    await _oneSignal.postNotification(
      OSCreateNotification(
        playerIds: playerIds,
        heading: heading,
        content: content,
        additionalData: {
          'payload': {
            'path': payloadPath,
            'data': payloadData,
            'auth': payloadAuth,
          },
        },
        buttons: buttons
            ?.map(
              (element) => OSActionButton(
                id: element.id,
                text: element.text,
                icon: element.icon,
              ),
            )
            .toList(),
        bigPicture: imageURL,
        iosAttachments: imageURL == null
            ? null
            : {
                'image': imageURL,
              },
        androidChannelId: channels[channel],
        sendAfter: sendAfter,
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
