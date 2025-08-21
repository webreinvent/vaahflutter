// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_remote_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SentryRemoteProviderConfig _$SentryRemoteProviderConfigFromJson(
  Map<String, dynamic> json,
) => SentryRemoteProviderConfig(
  name: json['name'] as String,
  dsn: json['dsn'] as String,
  tracesSampleRate: (json['traces_sample_rate'] as num?)?.toDouble() ?? 100,
  logExceptionsOnly: json['log_exceptions_only'] as bool? ?? true,
);

DatadogRemoteProviderConfig _$DatadogRemoteProviderConfigFromJson(
  Map<String, dynamic> json,
) => DatadogRemoteProviderConfig(
  name: json['name'] as String,
  clientToken: json['client_token'] as String,
  siteName: json['site_name'] as String,
  rumApplicationId: json['rum_application_id'] as String?,
  tracesSampleRate: (json['traces_sample_rate'] as num?)?.toDouble() ?? 100,
  logExceptionsOnly: json['log_exceptions_only'] as bool? ?? true,
);
