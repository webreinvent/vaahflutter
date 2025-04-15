import 'package:datadog_flutter_plugin/datadog_flutter_plugin.dart';
import 'package:json_annotation/json_annotation.dart';

part 'datadog_config.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class DatadogConfig {
  const DatadogConfig({
    required this.clientToken,
    required this.applicationId,
    required this.site,
    this.nativeCrashReportEnabled = false,
    this.reportFlutterPerformance = false,
    this.firstPartyHosts = const [],
    this.tracesSampleRate = 20.0,
  });

  final String clientToken;
  final String applicationId;
  final DatadogSite site;
  final bool nativeCrashReportEnabled;
  final bool reportFlutterPerformance;
  final List<String> firstPartyHosts;
  final double tracesSampleRate;

  factory DatadogConfig.fromJson(Map<String, dynamic> json) => _$DatadogConfigFromJson(json);

  Map<String, dynamic> toJson() => _$DatadogConfigToJson(this);
}
