import 'dart:async';

import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import './base_service.dart';
import '../../../../env.dart';
import '../../../logging_library/logging_library.dart';
import '../../models/notification.dart';

class InternalNotificationsWithPusher implements InternalNotificationsService {
  late final PusherChannelsFlutter _pusher;

  final StreamController<int> _pendingNotificationsCountStreamController =
      StreamController<int>.broadcast();

  @override
  late final Stream<int> pendingNotificationsCountStream;

  final StreamController<List<InternalNotification>> _notificationsStreamController =
      StreamController<List<InternalNotification>>.broadcast();

  @override
  late final Stream<List<InternalNotification>> notificationsStream;

  List<InternalNotification> _notifications = [];

  @override
  List<InternalNotification> get notifications => _notifications;

  late final String userId;

  @override
  Future<void> init() async {
    pendingNotificationsCountStream = _pendingNotificationsCountStreamController.stream;
    notificationsStream = _notificationsStreamController.stream;

    // Write your logic here to get user id
    userId = 'userId';

    final EnvironmentConfig environmentConfig = EnvironmentConfig.getEnvConfig();
    if (environmentConfig.pusherConfig == null) return;

    _pusher = PusherChannelsFlutter.getInstance();
    await _pusher.init(
      apiKey: environmentConfig.pusherConfig!.apiKey,
      cluster: environmentConfig.pusherConfig!.cluster,
      onAuthorizer: (String channelName, String socketId, dynamic options) {
        // return {"shared_secret": "11518af14b1d4acbd3b9"};
      },
      onEvent: (event) {
        Log.warning(event);
        if (event.data != null) {
          _notificationsUpdated([event.data]);
        }
      },
    );
    await _pusher.subscribe(channelName: 'private-$userId');
    await _pusher.connect(); // Connect with cluster
  }

  @override
  Future<void> dispose() async {}

  @override
  Future<void> subscribe() async {}

  @override
  Future<void> unsubscribe() async {}

  @override
  Future<void> push(List<String> userIds, InternalNotification notification) async {
    for (final id in userIds) {
      await _pusher.trigger(
        PusherEvent(
          channelName: 'private-$id',
          eventName: 'Internal Notification',
          data: notification.toJson(),
        ),
      );
    }
  }

  void _notificationsUpdated(List<Map<String, dynamic>> notifications) {
    int count = 0;
    final List<InternalNotification> updatedNotifications = [];
    for (final jsonNotification in notifications) {
      final InternalNotification notification = InternalNotification.fromJson(jsonNotification);
      if (!notification.opened) count++;
      updatedNotifications.add(notification);
    }
    _pendingNotificationsCountStreamController.add(count);
    _notificationsStreamController.add(updatedNotifications);
    _notifications = updatedNotifications;
  }
}
