import 'dart:async';

import './local.dart';
import './models/notification.dart';
import './remote.dart';

export './models/notification.dart';

abstract class AppNotification {
  static final Stream<String> remoteUserIdStream = RemoteNotification.userIdStream;
  static String? get remoteUserId => RemoteNotification.userId;

  static Future<void> init() async {
    await RemoteNotification.init();
    await LocalNotification.init();
  }

  static void dispose() {
    RemoteNotification.dispose();
    LocalNotification.dispose();
  }

  static Future<void> unsubscribe() async {
    await RemoteNotification.unsubscribe();
    await LocalNotification.unsubscribe();
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
      await LocalNotification.push(
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
    await RemoteNotification.push(
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
