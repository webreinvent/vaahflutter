import 'package:json_annotation/json_annotation.dart';

part 'logging.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SentryConfig {
  final String dsn;
  final bool autoAppStart; // To record cold and warm start up time
  final double tracesSampleRate;
  final bool enableAutoPerformanceTracing;
  final bool enableUserInteractionTracing;
  final bool enableAssetsInstrumentation;

  const SentryConfig({
    required this.dsn,
    this.autoAppStart = true,
    this.tracesSampleRate = 0.6,
    this.enableAutoPerformanceTracing = true,
    this.enableUserInteractionTracing = true,
    this.enableAssetsInstrumentation = true,
  });

  factory SentryConfig.fromJson(Map<String, dynamic> json) => _$SentryConfigFromJson(json);

  Map<String, dynamic> toJson() => _$SentryConfigToJson(this);
}
