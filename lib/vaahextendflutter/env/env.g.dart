// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnvironmentConfig _$EnvironmentConfigFromJson(Map<String, dynamic> json) =>
    EnvironmentConfig(
      appTitle: json['app_title'] as String,
      appTitleShort: json['app_title_short'] as String,
      envType: json['env_type'] as String,
      version: json['version'] as String,
      build: json['build'] as String,
      apiUrl: json['api_url'] as String,
      firebaseId: json['firebase_id'] as String?,
      timeoutLimit: json['timeout_limit'] as int,
      enableLocalLogs: json['enable_local_logs'] as bool,
      enableCloudLogs: json['enable_cloud_logs'] as bool,
      enableApiLogInterceptor: json['enable_api_log_interceptor'] as bool,
      sentryConfig: json['sentry_config'] == null
          ? null
          : SentryConfig.fromJson(
              json['sentry_config'] as Map<String, dynamic>),
      pushNotificationsServiceType: $enumDecode(
          _$PushNotificationsServiceTypeEnumMap,
          json['push_notifications_service_type']),
      internalNotificationsServiceType: $enumDecode(
          _$InternalNotificationsServiceTypeEnumMap,
          json['internal_notifications_service_type']),
      oneSignalConfig: json['one_signal_config'] == null
          ? null
          : OneSignalConfig.fromJson(
              json['one_signal_config'] as Map<String, dynamic>),
      pusherConfig: json['pusher_config'] == null
          ? null
          : PusherConfig.fromJson(
              json['pusher_config'] as Map<String, dynamic>),
      showDebugPanel: json['show_debug_panel'] as bool,
      networkStorageType: $enumDecode(
          _$NetworkStorageTypeEnumMap, json['network_storage_type']),
      supabaseConfig: json['supabase_config'] == null
          ? null
          : SupabaseConfig.fromJson(
              json['supabase_config'] as Map<String, dynamic>),
      debugPanelColor:
          EnvironmentConfig._colorFromJson(json['debug_panel_color'] as int),
    );

Map<String, dynamic> _$EnvironmentConfigToJson(EnvironmentConfig instance) =>
    <String, dynamic>{
      'app_title': instance.appTitle,
      'app_title_short': instance.appTitleShort,
      'env_type': instance.envType,
      'version': instance.version,
      'build': instance.build,
      'api_url': instance.apiUrl,
      'firebase_id': instance.firebaseId,
      'timeout_limit': instance.timeoutLimit,
      'enable_local_logs': instance.enableLocalLogs,
      'enable_cloud_logs': instance.enableCloudLogs,
      'enable_api_log_interceptor': instance.enableApiLogInterceptor,
      'sentry_config': instance.sentryConfig,
      'push_notifications_service_type': _$PushNotificationsServiceTypeEnumMap[
          instance.pushNotificationsServiceType]!,
      'internal_notifications_service_type':
          _$InternalNotificationsServiceTypeEnumMap[
              instance.internalNotificationsServiceType]!,
      'one_signal_config': instance.oneSignalConfig,
      'pusher_config': instance.pusherConfig,
      'network_storage_type':
          _$NetworkStorageTypeEnumMap[instance.networkStorageType]!,
      'supabase_config': instance.supabaseConfig,
      'show_debug_panel': instance.showDebugPanel,
      'debug_panel_color':
          EnvironmentConfig._colorToJson(instance.debugPanelColor),
    };

const _$PushNotificationsServiceTypeEnumMap = {
  PushNotificationsServiceType.local: 'local',
  PushNotificationsServiceType.remote: 'remote',
  PushNotificationsServiceType.both: 'both',
  PushNotificationsServiceType.none: 'none',
};

const _$InternalNotificationsServiceTypeEnumMap = {
  InternalNotificationsServiceType.pusher: 'pusher',
  InternalNotificationsServiceType.firebase: 'firebase',
  InternalNotificationsServiceType.custom: 'custom',
  InternalNotificationsServiceType.none: 'none',
};

const _$NetworkStorageTypeEnumMap = {
  NetworkStorageType.firebase: 'firebase',
  NetworkStorageType.supabase: 'supabase',
  NetworkStorageType.none: 'none',
};
