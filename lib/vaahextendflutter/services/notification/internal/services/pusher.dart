import 'dart:async';
import 'dart:convert';

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

  final List<InternalNotification> _notifications = [];

  @override
  List<InternalNotification> get notifications => _notifications;

  late final String userId;
  final String _channelPrefix = 'client-';
  String get _channelName => '$_channelPrefix$userId';

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
      onError: (message, code, error) => Log.exception(error, data: message),
      onSubscriptionError: (message, error) => Log.exception(error, data: message),
    );
    await _pusher.connect();
    await _pusher.subscribe(
      channelName: _channelName,
      onEvent: (event) {
        _updateNotifications(event.data);
      },
    );
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
          channelName: '$_channelPrefix$id',
          eventName: 'Internal Notification',
          data: jsonEncode(notification.toJson()),
        ),
      );
    }
  }

  void _updateNotifications(dynamic eventData) {
    try {
      final data = jsonDecode(eventData.toString());
      if (data == null || data.isEmpty) return;
      final InternalNotification notification = InternalNotification.fromJson(data);
      _notifications.add(notification);
      _notificationsStreamController.add(_notifications);
      final int count = notifications.where((element) => element.opened == false).length;
      _pendingNotificationsCountStreamController.add(count);
    } catch (error, stackTrace) {
      Log.exception(
        error,
        stackTrace: stackTrace,
        hint: "Error parsing pusher internal notification",
      );
    }
  }
}
