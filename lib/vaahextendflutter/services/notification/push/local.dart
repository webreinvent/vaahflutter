import 'dart:async';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';

import './models/notification.dart';
import '../../logging_library/logging_library.dart';

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

  static Future<void> askPermission() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  static Future<void> subscribe() async {}

  static Future<void> unsubscribe() async {}

  static Future<void> push({
    String? heading,
    required String content,
    String? payloadPath,
    dynamic payloadData,
    dynamic payloadAuth,
    List<NotificationButton>? buttons,
    String? imageURL,
    DateTime? sendAfter,
  }) async {
    final DateTime scheduledDate = sendAfter ?? DateTime.now().add(const Duration(seconds: 5));
    _flutterLocalNotificationsPlugin.zonedSchedule(
      Random().nextInt(50000) + 100000,
      heading,
      content,
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
      androidAllowWhileIdle: true,
      payload: {
        'path': payloadPath,
        'data': payloadData,
        'auth': payloadAuth,
      }.toString(),
    );
  }

  // static Future<void> _handleSubscriptionStateChanges() async {}

  static void _handleNotification({required String? payload, String? actionId}) {
    Log.info(payload);
    Log.info(actionId);
  }
}
