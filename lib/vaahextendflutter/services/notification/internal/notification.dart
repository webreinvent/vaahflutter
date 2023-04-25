import 'dart:async';

import './models/internal_notification.dart';
import './services/base_service.dart';
import './services/custom.dart';
import './services/firebase.dart';
import './services/no_service.dart';
import './services/pusher.dart';
import '../../../env.dart';

InternalNotificationsService get getService {
  final InternalNotificationsServiceType serviceType =
      EnvironmentConfig.getEnvConfig().internalNotificationsServiceType;
  switch (serviceType) {
    case InternalNotificationsServiceType.firebase:
      return InternalNotificationsWithFirebase();
    case InternalNotificationsServiceType.pusher:
      return InternalNotificationsWithPusher();
    case InternalNotificationsServiceType.custom:
      return InternalNotificationsWithCustomService();
    case InternalNotificationsServiceType.none:
      return InternalNotificationsNoService();
  }
}

abstract class InternalNotifications {
  static final InternalNotificationsService _service = getService;

  static late final Stream<int> pendingNotificationsCountStream;

  static late List<InternalNotification> notifications;

  static late final Stream<List<InternalNotification>> notificationsStream;

  static Future<void> init() async {
    await _service.init();
    pendingNotificationsCountStream = _service.pendingNotificationsCountStream;
    notifications = _service.notifications;
    notificationsStream = _service.notificationsStream;
    _service.notificationsStream.listen((updatedNotifications) {
      notifications = updatedNotifications;
    });
  }

  static void dispose() async {
    await _service.dispose();
  }

  static Future<void> subscribe() async {
    await _service.subscribe();
  }

  static Future<void> unsubscribe() async {
    await _service.unsubscribe();
  }

  static Future<void> push(List<String> userIds, InternalNotification notification) async {
    await _service.push(userIds, notification);
  }
}
