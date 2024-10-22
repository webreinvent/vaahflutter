// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OneSignalConfig _$OneSignalConfigFromJson(Map<String, dynamic> json) =>
    OneSignalConfig(
      appId: json['app_id'] as String,
      apiKey: json['api_key'] as String?,
    );

Map<String, dynamic> _$OneSignalConfigToJson(OneSignalConfig instance) =>
    <String, dynamic>{
      'app_id': instance.appId,
      'api_key': instance.apiKey,
    };

PusherConfig _$PusherConfigFromJson(Map<String, dynamic> json) => PusherConfig(
      apiKey: json['api_key'] as String,
      cluster: json['cluster'] as String,
    );

Map<String, dynamic> _$PusherConfigToJson(PusherConfig instance) =>
    <String, dynamic>{
      'api_key': instance.apiKey,
      'cluster': instance.cluster,
    };
