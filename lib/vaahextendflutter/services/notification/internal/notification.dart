import 'dart:async';

abstract class InternalNotifications {
  static Future<void> init() async {}

  static void dispose() {}

  static Future<void> subscribe() async {}
  static Future<void> unsubscribe() async {}

  static Future<void> push() async {}
}
