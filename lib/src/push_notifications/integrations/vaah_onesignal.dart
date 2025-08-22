import 'dart:async';

import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../models/push_notifications/push_notifications_config.dart';
import '../../models/push_notifications/vaah_push_event.dart';
import '../../models/user/vaah_user.dart';
import 'vaah_push_provider.dart';

class VaahOneSignal extends VaahPushProvider {
  VaahOneSignal(this._config) {
    OneSignal.initialize(_config.appId);
    OneSignal.Notifications.addClickListener(_clickListener);
    OneSignal.Notifications.addForegroundWillDisplayListener(_foregroundWillDisplayListener);
  }

  final OneSignalPushProviderConfig _config;

  @override
  String? get subscriptionId => OneSignal.User.pushSubscription.id;

  final _receivedPushStreamController = StreamController<VaahPushEvent>.broadcast();
  @override
  Stream<VaahPushEvent> get receivedPushStream => _receivedPushStreamController.stream;

  final _openedPushStreamController = StreamController<VaahPushEvent>.broadcast();
  @override
  Stream<VaahPushEvent> get openedPushStream => _openedPushStreamController.stream;

  VaahPushEvent _createPushEvent({
    required OSNotification notification,
    OSNotificationClickResult? result,
  }) {
    return VaahPushEvent(
      id: notification.notificationId,
      title: notification.title,
      body: notification.body,
      payload: notification.additionalData,
      actionUrl: result?.url ?? notification.launchUrl,
      actionId: result?.actionId,
    );
  }

  void _foregroundWillDisplayListener(OSNotificationWillDisplayEvent event) {
    final pushEvent = _createPushEvent(notification: event.notification);
    _receivedPushStreamController.add(pushEvent);
  }

  void _clickListener(OSNotificationClickEvent event) {
    final pushEvent = _createPushEvent(notification: event.notification, result: event.result);
    _openedPushStreamController.add(pushEvent);
  }

  @override
  Future<void> grantConsent() async {
    await OneSignal.consentGiven(true);
  }

  @override
  Future<void> revokeConsent() async {
    await OneSignal.consentGiven(false);
  }

  @override
  Future<void> bindUser(VaahUser user) async {
    await OneSignal.login(user.id);
  }

  @override
  Future<void> unbindUser() async {
    await OneSignal.logout();
  }

  @override
  Future<void> dispose() async {
    await _openedPushStreamController.close();
    await _receivedPushStreamController.close();
  }
}
