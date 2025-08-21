import 'package:json_annotation/json_annotation.dart';

import 'log_level.dart';
import 'log_remote_provider.dart';
import 'log_transport.dart';

part 'log_config.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class LoggerConfig {
  const LoggerConfig({
    this.level = LogLevel.info,
    this.transports = const [],
    this.remoteProviderConfig,
  });

  factory LoggerConfig.fromJson(Map<String, dynamic> json) => _$LoggerConfigFromJson(json);

  final LogLevel level;
  final List<LogTransport> transports;
  @JsonKey(fromJson: _remoteProviderConfigFromJson)
  final LogRemoteProviderConfig? remoteProviderConfig;

  static LogRemoteProviderConfig? _remoteProviderConfigFromJson(dynamic json) {
    switch (json['name']) {
      case 'sentry':
        return SentryRemoteProviderConfig.fromJson(json);
      case 'datadog':
        return DatadogRemoteProviderConfig.fromJson(json);
      default:
        return null;
    }
  }
}
