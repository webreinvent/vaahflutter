import 'package:datadog_flutter_plugin/datadog_flutter_plugin.dart';
import 'package:json_annotation/json_annotation.dart';

part 'datadog_config.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class DatadogConfig {
  final String clientToken;
  final String applicationId;
  final bool nativeCrashReportEnabled;
  final List<String> firstPartyHosts;
  final DatadogSite site;
  final double tracesSampleRate;
  final bool reportFlutterPerformance;

  DatadogConfig({
    required this.clientToken,
    required this.applicationId,
    required this.site,
    this.nativeCrashReportEnabled = false,
    this.reportFlutterPerformance = false,
    this.firstPartyHosts = const [],
    this.tracesSampleRate = 20.0,
  });

  factory DatadogConfig.fromJson(Map<String, dynamic> json) => _$DatadogConfigFromJson(json);

  Map<String, dynamic> toJson() => _$DatadogConfigToJson(this);
}
