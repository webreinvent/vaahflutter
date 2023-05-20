import 'dart:async';

import './services/local.dart';
import './services/remote.dart';
import '../models/notification.dart';

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
    required PushNotification notification,
    String? channel,
  }) async {
    assert(notification.content.trim().isNotEmpty);
    if (NotificationType.local == notification.type) {
      await LocalNotifications.push(notification: notification);
      return;
    }
    await RemoteNotifications.push(notification: notification, channel: channel);
  }
}
