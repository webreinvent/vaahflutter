import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import './logging_library/logging_library.dart';
import '../env.dart';

const String _userIdKey = 'notification_user_id';

abstract class AppNotification {
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
    await _oneSignal.promptUserForPushNotificationPermission();
    _oneSignal.setNotificationOpenedHandler(_handleNotification);
  }

  static void dispose() {
    _userIdStreamController.close();
  }

  static Future<void> unsubscribe() async {
    await _oneSignal.disablePush(true);
  }

  static Future<void> post({
    required List<String> playerIds,
    String? heading,
    required String content,
    String? payloadPath,
    dynamic payloadData,
    dynamic payloadAuth,
    List<OSActionButton>? buttons,
    String? imageURL,
  }) async {
    assert(playerIds.isNotEmpty);
    assert(content.trim().isNotEmpty);
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
        buttons: buttons,
        bigPicture: imageURL,
        iosAttachments: imageURL == null
            ? null
            : {
                'image': imageURL,
              },
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
      Get.offAllNamed(
        payload['path'],
        arguments: <String, dynamic>{
          'data': payload['data'],
          'auth': payload['auth'],
        },
      );
    }
  }
}
