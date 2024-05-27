import 'dart:async';

import '../../../env/env.dart';
import '../../../env/notification.dart';
import '../models/notification.dart';
import 'services/local.dart';
import 'services/remote.dart';

abstract class PushNotifications {
  static final PushNotificationsServiceType _pushNotificationsServiceType =
      EnvironmentConfig.getConfig.pushNotificationsServiceType;

  static Future<void> init() async {
    switch (_pushNotificationsServiceType) {
      case PushNotificationsServiceType.local:
        await LocalNotifications.init();
        return;
      case PushNotificationsServiceType.remote:
        await RemoteNotifications.init();
        return;
      case PushNotificationsServiceType.both:
        await RemoteNotifications.init();
        await LocalNotifications.init();
        return;
      case PushNotificationsServiceType.none:
        return;
    }
  }

  static void dispose() {
    switch (_pushNotificationsServiceType) {
      case PushNotificationsServiceType.local:
        LocalNotifications.dispose();
        return;
      case PushNotificationsServiceType.remote:
        RemoteNotifications.dispose();
        return;
      case PushNotificationsServiceType.both:
        RemoteNotifications.dispose();
        LocalNotifications.dispose();
        return;
      case PushNotificationsServiceType.none:
        return;
    }
  }

  static Future<void> askPermission() async {
    // RemoteNotifications.askPermission only works if OneSignal config is there
    // And if we call RemoteNotifications.askPermission and LocalNotifications.askPermission both then
    // Two prompts will be shown to the user in case when user neither accepts nor rejects notification permission.

    // Local notification permission always works even if project has no setup for onesignal

    switch (_pushNotificationsServiceType) {
      case PushNotificationsServiceType.local:
        await LocalNotifications.askPermission();
        return;
      case PushNotificationsServiceType.remote:
        await RemoteNotifications.askPermission();
        return;
      case PushNotificationsServiceType.both:
        await LocalNotifications.askPermission();
        return;
      case PushNotificationsServiceType.none:
        return;
    }
  }

  static Future<void> subscribe({
    required String userid,
    String? email,
    String? phone,
  }) async {
    switch (_pushNotificationsServiceType) {
      case PushNotificationsServiceType.local:
        await LocalNotifications.subscribe();
        return;
      case PushNotificationsServiceType.remote:
        await RemoteNotifications.subscribe(
          userid: userid,
          email: email,
          phone: phone,
        );
        return;
      case PushNotificationsServiceType.both:
        await RemoteNotifications.subscribe(
          userid: userid,
          email: email,
          phone: phone,
        );
        await LocalNotifications.subscribe();
        return;
      case PushNotificationsServiceType.none:
        return;
    }
  }

  static Future<void> unsubscribe() async {
    switch (_pushNotificationsServiceType) {
      case PushNotificationsServiceType.local:
        await LocalNotifications.unsubscribe();
        return;
      case PushNotificationsServiceType.remote:
        await RemoteNotifications.unsubscribe();
        return;
      case PushNotificationsServiceType.both:
        await RemoteNotifications.unsubscribe();
        await LocalNotifications.unsubscribe();
        return;
      case PushNotificationsServiceType.none:
        return;
    }
  }

  static Future<void> push({
    required PushNotification notification,
    String? channel,
  }) async {
    assert(notification.content.trim().isNotEmpty);

    switch (_pushNotificationsServiceType) {
      case PushNotificationsServiceType.local:
        await LocalNotifications.push(notification: notification);
        return;
      case PushNotificationsServiceType.remote:
        await RemoteNotifications.push(notification: notification, channel: channel);
        return;
      case PushNotificationsServiceType.both:
        await LocalNotifications.push(notification: notification);
        await RemoteNotifications.push(notification: notification, channel: channel);
        return;
      case PushNotificationsServiceType.none:
        return;
    }
  }
}
