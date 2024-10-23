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
    _flutterLocalNotificationsPlugin.zonedSchedule(
      notification.id,
      notification.heading,
      notification.content,
      TZDateTime(
        getLocation('Asia/Kolkata'),
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day,
        scheduledDate.hour,
        scheduledDate.minute,
        scheduledDate.second,
        scheduledDate.millisecond,
        scheduledDate.microsecond,
      ),
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
  }

  // static Future<void> _handleSubscriptionStateChanges() async {}

  static void _handleNotification({required String? payload, String? actionId}) {
    Log.info(payload);
    Log.info(actionId);
  }
}
