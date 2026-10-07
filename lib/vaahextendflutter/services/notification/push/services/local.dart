import 'dart:async';
import 'dart:convert';

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
      settings: const InitializationSettings(
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
    // JSON (not `Map.toString`) so the payload round-trips when the
    // notification is tapped and decoded on the app side.
    final String payload = jsonEncode({
      'path': notification.payloadPath,
      'data': notification.payloadData,
      'auth': notification.payloadAuth,
    });
    try {
      await _schedule(notification, scheduledDate, payload,
          AndroidScheduleMode.exactAllowWhileIdle);
    } catch (e) {
      // On Android 12+ (API 31+) exact alarms require the user-grantable
      // SCHEDULE_EXACT_ALARM permission; zonedSchedule throws when it isn't
      // available. Fall back to inexact so the notification still fires
      // (approximately on time) instead of being dropped.
      Log.warning(
        'Exact alarm unavailable; rescheduling inexact',
        data: {'id': notification.id, 'reason': '$e'},
      );
      try {
        await _schedule(notification, scheduledDate, payload,
            AndroidScheduleMode.inexactAllowWhileIdle);
      } catch (error, errorStackTrace) {
        Log.exception(
          'Failed to schedule local notification',
          throwable: error,
          stackTrace: errorStackTrace,
        );
      }
    }
  }

  static Future<void> _schedule(
    PushNotification notification,
    DateTime scheduledDate,
    String payload,
    AndroidScheduleMode mode,
  ) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id: notification.id,
      title: notification.heading,
      body: notification.content,
      scheduledDate: TZDateTime(
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
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails('vaahflutter_local_notifications', 'App Notifications'),
      ),
      androidScheduleMode: mode,
      payload: payload,
    );
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
