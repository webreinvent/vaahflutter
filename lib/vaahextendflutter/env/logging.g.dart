// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logging.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SentryConfig _$SentryConfigFromJson(Map<String, dynamic> json) => SentryConfig(
      dsn: json['dsn'] as String,
      autoAppStart: json['auto_app_start'] as bool? ?? true,
      tracesSampleRate: (json['traces_sample_rate'] as num?)?.toDouble() ?? 0.6,
      enableAutoPerformanceTracing:
          json['enable_auto_performance_tracing'] as bool? ?? true,
      enableUserInteractionTracing:
          json['enable_user_interaction_tracing'] as bool? ?? true,
      enableAssetsInstrumentation:
          json['enable_assets_instrumentation'] as bool? ?? true,
    );

Map<String, dynamic> _$SentryConfigToJson(SentryConfig instance) =>
    <String, dynamic>{
      'dsn': instance.dsn,
      'auto_app_start': instance.autoAppStart,
      'traces_sample_rate': instance.tracesSampleRate,
      'enable_auto_performance_tracing': instance.enableAutoPerformanceTracing,
      'enable_user_interaction_tracing': instance.enableUserInteractionTracing,
      'enable_assets_instrumentation': instance.enableAssetsInstrumentation,
    };
