import 'dart:async';

import '../env/env.dart';
import '../models/push_notifications/push_notifications_config.dart';
import '../models/push_notifications/vaah_push_event.dart';
import '../models/user/vaah_user.dart';
import 'integrations/vaah_onesignal.dart';
import 'integrations/vaah_push_provider.dart';

class VaahPushNotifications {
  factory VaahPushNotifications() => _instance;
  static final VaahPushNotifications _instance = VaahPushNotifications._internal();
  VaahPushNotifications._internal() {
    _initialize();
  }

  bool _initialized = false;

  void _initialize() {
    if (_initialized) return;
    final pushNotificationsConfig = _config.pushNotificationsConfig;
    if (pushNotificationsConfig?.providerConfig == null) {
      _initialized = true;
      return;
    }

    if (pushNotificationsConfig?.providerConfig is OneSignalPushProviderConfig &&
        _provider == null) {
      _provider = VaahOneSignal(
        pushNotificationsConfig?.providerConfig as OneSignalPushProviderConfig,
      );
    }
    _initialized = true;
  }

  VaahEnvData get _config => VaahEnv.instance.data;
  VaahPushProvider? _provider;

  String? get subscriptionId {
    return _provider?.subscriptionId;
  }

  Stream<VaahPushEvent> get receivedPushStream {
    return _provider?.receivedPushStream ?? const Stream<VaahPushEvent>.empty();
  }

  Stream<VaahPushEvent> get openedPushStream {
    return _provider?.openedPushStream ?? const Stream<VaahPushEvent>.empty();
  }

  Future<void> grantConsent() async {
    await _provider?.grantConsent();
  }

  Future<void> revokeConsent() async {
    await _provider?.revokeConsent();
  }

  Future<void> bindUser(VaahUser user) async {
    await _provider?.bindUser(user);
  }

  Future<void> unbindUser() async {
    await _provider?.unbindUser();
  }

  Future<void> dispose() async {
    await _provider?.dispose();
  }
}
