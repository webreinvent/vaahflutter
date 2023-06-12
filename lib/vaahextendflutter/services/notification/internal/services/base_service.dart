import 'dart:async';

import '../../models/notification.dart';

abstract class InternalNotificationsService {
  final Stream<int> pendingNotificationsCountStream = const Stream.empty();

  final Stream<List<InternalNotification>> notificationsStream = const Stream.empty();

  List<InternalNotification> get notifications => [];

  Future<void> init() async {}

  Future<void> dispose() async {}

  Future<void> subscribe() async {}

  Future<void> unsubscribe() async {}

  Future<void> push(List<String> userIds, InternalNotification notification) async {}
}
