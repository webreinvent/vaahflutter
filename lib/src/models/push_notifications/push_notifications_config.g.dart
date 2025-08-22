// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notifications_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushNotificationsConfig _$PushNotificationsConfigFromJson(
  Map<String, dynamic> json,
) => PushNotificationsConfig(
  providerConfig: PushNotificationsConfig._providerConfigFromJson(
    json['provider_config'],
  ),
);

OneSignalPushProviderConfig _$OneSignalPushProviderConfigFromJson(
  Map<String, dynamic> json,
) => OneSignalPushProviderConfig(
  name: json['name'] as String,
  appId: json['app_id'] as String,
);
