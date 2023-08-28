import 'dart:async';

import '../../models/notification.dart';
import 'base_service.dart';

class InternalNotificationsNoService implements InternalNotificationsService {
  @override
  final Stream<int> pendingNotificationsCountStream = const Stream.empty();

  @override
  final Stream<List<InternalNotification>> notificationsStream = const Stream.empty();

  @override
  List<InternalNotification> get notifications => [];

  @override
  Future<void> init() async {}

  @override
  Future<void> dispose() async {}

  @override
  Future<void> subscribe() async {}

  @override
  Future<void> unsubscribe() async {}

  @override
  Future<void> push(List<String> userIds, InternalNotification notification) async {}
}
