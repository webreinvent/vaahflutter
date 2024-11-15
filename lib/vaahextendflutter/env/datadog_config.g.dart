// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datadog_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DatadogConfig _$DatadogConfigFromJson(Map<String, dynamic> json) =>
    DatadogConfig(
      clientToken: json['client_token'] as String,
      applicationId: json['application_id'] as String,
      site: $enumDecode(_$DatadogSiteEnumMap, json['site']),
      nativeCrashReportEnabled:
          json['native_crash_report_enabled'] as bool? ?? false,
      reportFlutterPerformance:
          json['report_flutter_performance'] as bool? ?? false,
      firstPartyHosts: (json['first_party_hosts'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tracesSampleRate:
          (json['traces_sample_rate'] as num?)?.toDouble() ?? 20.0,
    );

Map<String, dynamic> _$DatadogConfigToJson(DatadogConfig instance) =>
    <String, dynamic>{
      'client_token': instance.clientToken,
      'application_id': instance.applicationId,
      'native_crash_report_enabled': instance.nativeCrashReportEnabled,
      'first_party_hosts': instance.firstPartyHosts,
      'site': _$DatadogSiteEnumMap[instance.site]!,
      'traces_sample_rate': instance.tracesSampleRate,
      'report_flutter_performance': instance.reportFlutterPerformance,
    };

const _$DatadogSiteEnumMap = {
  DatadogSite.us1: 'us1',
  DatadogSite.us3: 'us3',
  DatadogSite.us5: 'us5',
  DatadogSite.eu1: 'eu1',
  DatadogSite.us1Fed: 'us1Fed',
  DatadogSite.ap1: 'ap1',
};
