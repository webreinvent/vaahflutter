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
      timeoutLimit: (json['timeout_limit'] as num).toInt(),
      enableLocalLogs: json['enable_local_logs'] as bool,
      enableCloudLogs: json['enable_cloud_logs'] as bool,
      enableApiLogInterceptor: json['enable_api_log_interceptor'] as bool,
      cloudLoggingService: $enumDecodeNullable(
              _$CloudLoggingServiceEnumMap, json['cloud_logging_service']) ??
          CloudLoggingService.noService,
      sentryConfig: json['sentry_config'] == null
          ? null
          : SentryConfig.fromJson(
              json['sentry_config'] as Map<String, dynamic>),
      datadogConfig: json['datadog_config'] == null
          ? null
          : DatadogConfig.fromJson(
              json['datadog_config'] as Map<String, dynamic>),
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
      debugPanelColor: EnvironmentConfig._colorFromJson(
          (json['debug_panel_color'] as num).toInt()),
    );

Map<String, dynamic> _$EnvironmentConfigToJson(EnvironmentConfig instance) =>
    <String, dynamic>{
      'app_title': instance.appTitle,
      'app_title_short': instance.appTitleShort,
      'env_type': instance.envType,
      'version': instance.version,
      'build': instance.build,
      'api_url': instance.apiUrl,
      'timeout_limit': instance.timeoutLimit,
      'enable_local_logs': instance.enableLocalLogs,
      'enable_cloud_logs': instance.enableCloudLogs,
      'enable_api_log_interceptor': instance.enableApiLogInterceptor,
      'cloud_logging_service':
          _$CloudLoggingServiceEnumMap[instance.cloudLoggingService]!,
      'sentry_config': instance.sentryConfig,
      'datadog_config': instance.datadogConfig,
      'push_notifications_service_type': _$PushNotificationsServiceTypeEnumMap[
          instance.pushNotificationsServiceType]!,
      'internal_notifications_service_type':
          _$InternalNotificationsServiceTypeEnumMap[
              instance.internalNotificationsServiceType]!,
      'one_signal_config': instance.oneSignalConfig,
      'pusher_config': instance.pusherConfig,
      'show_debug_panel': instance.showDebugPanel,
      'debug_panel_color':
          EnvironmentConfig._colorToJson(instance.debugPanelColor),
    };

const _$CloudLoggingServiceEnumMap = {
  CloudLoggingService.noService: 'no_service',
  CloudLoggingService.sentry: 'sentry',
  CloudLoggingService.datadog: 'datadog',
  CloudLoggingService.firebase: 'firebase',
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
