import 'dart:async';

import '../../../../../vaahextendflutter/env/notification.dart';
import '../../../../../vaahextendflutter/services/notification/internal/services/base_service.dart';
import '../../../../../vaahextendflutter/services/notification/internal/services/custom.dart';
import '../../../../../vaahextendflutter/services/notification/internal/services/firebase.dart';
import '../../../../../vaahextendflutter/services/notification/internal/services/no_service.dart';

import '../../../../../vaahextendflutter/services/notification/internal/services/pusher.dart';
import '../../../../../vaahextendflutter/services/notification/models/notification.dart';
import '../../../env_bloc/env_bloc.dart';

InternalNotificationsService get getService {
  final InternalNotificationsServiceType serviceType =
      EnvBloc.instance.config.internalNotificationsServiceType;
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
