import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';

import '../../../logging_library/logging_library.dart';
import '../../models/notification.dart';

abstract class LocalNotifications {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    await _flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings(
          'ic_stat_onesignal_default',
        ),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
        _handleNotification(
          payload: notificationResponse.payload,
          actionId: notificationResponse.actionId,
        );
      },
    );
    // _flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  }

  static void dispose() {}

  static Future<bool?> askPermission() async {
    return await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> subscribe() async {}

  static Future<void> unsubscribe() async {}

  static Future<void> push({
    required PushNotification notification,
  }) async {
    final DateTime scheduledDate =
        notification.sendAfter ?? DateTime.now().add(const Duration(seconds: 5));
    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        notification.id,
        notification.heading,
        notification.content,
        TZDateTime.from(scheduledDate, local),
        const NotificationDetails(
          android: AndroidNotificationDetails('vaahflutter_local_notifications', 'App Notifications'),
        ),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: {
          'path': notification.payloadPath,
          'data': notification.payloadData,
          'auth': notification.payloadAuth,
        }.toString(),
      );
    } catch (e, stackTrace) {
      // On Android 12+ (API 31+) with targetSdk >= 31, exact alarms require the
      // USE_EXACT_ALARM (or user-granted SCHEDULE_EXACT_ALARM) permission;
      // zonedSchedule throws otherwise.
      Log.exception(
        'Failed to schedule local notification',
        throwable: e,
        stackTrace: stackTrace,
      );
    }
  }

  // static Future<void> _handleSubscriptionStateChanges() async {}

  static void _handleNotification({required String? payload, String? actionId}) {
    Log.info(
      "local-notification-payload",
      data: {
        "payload": payload,
        "actionId": actionId,
      },
    );
  }
}
