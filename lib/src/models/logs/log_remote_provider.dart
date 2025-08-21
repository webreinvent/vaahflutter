import 'package:json_annotation/json_annotation.dart';

part 'log_remote_provider.g.dart';

abstract class LogRemoteProviderConfig {
  String get name;
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class SentryRemoteProviderConfig implements LogRemoteProviderConfig {
  const SentryRemoteProviderConfig({
    required this.name,
    required this.dsn,
    this.tracesSampleRate = 100,
    this.logExceptionsOnly = true,
  });

  factory SentryRemoteProviderConfig.fromJson(Map<String, dynamic> json) =>
      _$SentryRemoteProviderConfigFromJson(json);

  @override
  final String name;

  final String dsn;

  final double tracesSampleRate;

  final bool logExceptionsOnly;
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class DatadogRemoteProviderConfig implements LogRemoteProviderConfig {
  const DatadogRemoteProviderConfig({
    required this.name,
    required this.clientToken,
    required this.siteName,
    this.rumApplicationId,
    this.tracesSampleRate = 100,
    this.logExceptionsOnly = true,
  });

  factory DatadogRemoteProviderConfig.fromJson(Map<String, dynamic> json) =>
      _$DatadogRemoteProviderConfigFromJson(json);

  @override
  final String name;

  final String clientToken;

  final String siteName;

  final String? rumApplicationId;

  final double tracesSampleRate;

  final bool logExceptionsOnly;
}
