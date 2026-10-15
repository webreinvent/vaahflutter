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

    final String? payload = _encodePayload(notification);
    if (payload == null) return;

    try {
      await _schedule(notification, scheduledDate, payload,
          AndroidScheduleMode.exactAllowWhileIdle);
    } catch (e) {
      // Exact alarms can fail for reasons other than the missing permission; fall back to inexact.
      Log.warning(
        'exact-alarm-unavailable-rescheduling-inexact',
        data: {'id': notification.id, 'reason': '$e'},
      );
      try {
        await _schedule(notification, scheduledDate, payload,
            AndroidScheduleMode.inexactAllowWhileIdle);
      } catch (error, errorStackTrace) {
        Log.exception(
          'failed-to-schedule-local-notification',
          throwable: error,
          stackTrace: errorStackTrace,
        );
      }
    }
  }

  /// Encodes the payload as JSON, or null (logging the failure) if a field is not JSON-encodable.
  static String? _encodePayload(PushNotification notification) {
    try {
      return jsonEncode({
        'path': notification.payloadPath,
        'data': notification.payloadData,
        'auth': notification.payloadAuth,
      });
    } catch (error, errorStackTrace) {
      Log.exception(
        'invalid-notification-payload',
        throwable: error,
        stackTrace: errorStackTrace,
      );
      return null;
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
