import 'dart:async';

import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../../../env/env.dart';
import '../../../api.dart';
import '../../../logging_library/logging_library.dart';
import '../../models/notification.dart';

const Map<String, String> channels = {
  //  Create a channel on One Signal and add id here
  'Primary': 'General'
};

abstract class RemoteNotifications {
  static final EnvironmentConfig _env = EnvironmentConfig.getConfig;

  static Future<void> init() async {
    if (_env.oneSignalConfig == null) return;
    await OneSignal.Debug.setLogLevel(OSLogLevel.info);
    OneSignal.initialize(_env.oneSignalConfig!.appId);
    OneSignal.Notifications.addForegroundWillDisplayListener(_handleWillDisplayNotification);
    OneSignal.Notifications.addClickListener(_handleNotificationClick);
  }

  static void dispose() {}

  static Future<bool?> askPermission() async {
    if (_env.oneSignalConfig == null) return null;
    return await OneSignal.Notifications.requestPermission(false);
  }

  static Future<void> subscribe({
    required String userid,
    String? email,
    String? phone,
  }) async {
    OneSignal.login(userid);
    if (email != null) OneSignal.User.addEmail(email);
    if (phone != null) OneSignal.User.addSms(phone);
  }

  static Future<void> unsubscribe() async {
    await OneSignal.logout();
  }

  static Future<void> push({
    required PushNotification notification,
    String? channel,
  }) async {
    final appId = _env.oneSignalConfig?.appId;
    final apiKey = _env.oneSignalConfig?.apiKey;
    if (appId == null || apiKey == null) {
      Log.warning("No app id/ api key is found!");
      return;
    }
    await Api.ajax(
      url: "https://onesignal.com/api/v1/notifications",
      method: "post",
      headers: [
        {
          "Content-Type": "application/json",
          "Authorization": "Basic $apiKey",
        },
      ],
      params: {
        "app_id": appId,
        "include_aliases": {
          "external_id": notification.externalIds,
        },
        "target_channel": channel ?? "General",
        "headings": {
          "en": notification.heading,
        },
        "contents": {
          "en": notification.content,
        },
        "data": {
          "payload": {
            "auth": notification.payloadAuth,
            "path": notification.payloadPath,
            "data": notification.payloadData,
          },
        },
        "big_picture": notification.imageUrl,
        "ios_attachments": notification.imageUrl == null
            ? null
            : {
                'image': notification.imageUrl!,
              },
      },
    );
  }

  static void _handleWillDisplayNotification(OSNotificationWillDisplayEvent result) {}

  static void _handleNotificationClick(OSNotificationClickEvent openedResult) {
    Log.success(
      'Notification Opened',
      data: {
        "actionId": openedResult.result.actionId,
        "title": openedResult.notification.title,
        "body": openedResult.notification.body,
        "additionalData": openedResult.notification.additionalData,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      },
    );
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
