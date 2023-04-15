import 'dart:async';

import './local.dart';
import './models/notification.dart';
import './remote.dart';

export './models/notification.dart';

abstract class PushNotifications {
  static final Stream<String> remoteUserIdStream = RemoteNotifications.userIdStream;
  static String? get remoteUserId => RemoteNotifications.userId;

  static Future<void> init() async {
    await RemoteNotifications.init();
    await LocalNotifications.init();
  }

  static void dispose() {
    RemoteNotifications.dispose();
    LocalNotifications.dispose();
  }

  static Future<void> askPermission() async {
    // RemoteNotifications.askPermission only works if OneSignal config is there
    // And if we call RemoteNotifications.askPermission and LocalNotifications.askPermission both then
    // Two prompts will be shown to the user in case when user neither accepts nor rejects notification permission.

    // Local notification permission always works even if project has no setup for onesignal
    await LocalNotifications.askPermission();
  }

  static Future<void> subscribe() async {
    await RemoteNotifications.subscribe();
    await LocalNotifications.subscribe();
  }

  static Future<void> unsubscribe() async {
    await RemoteNotifications.unsubscribe();
    await LocalNotifications.unsubscribe();
  }

  static Future<void> push({
    required NotificationType type,
    required List<String> playerIds,
    String? heading,
    required String content,
    String? payloadPath,
    dynamic payloadData,
    dynamic payloadAuth,
    List<NotificationButton>? buttons,
    String? imageURL,
    DateTime? sendAfter,
  }) async {
    assert(content.trim().isNotEmpty);
    if (NotificationType.local == type) {
      await LocalNotifications.push(
        heading: heading,
        content: content,
        payloadPath: payloadPath,
        payloadData: payloadData,
        payloadAuth: payloadAuth,
        buttons: buttons,
        imageURL: imageURL,
        sendAfter: sendAfter,
      );
      return;
    }
    await RemoteNotifications.push(
      playerIds: playerIds,
      heading: heading,
      content: content,
      payloadPath: payloadPath,
      payloadData: payloadData,
      payloadAuth: payloadAuth,
      buttons: buttons,
      imageURL: imageURL,
      sendAfter: sendAfter,
    );
  }
}
