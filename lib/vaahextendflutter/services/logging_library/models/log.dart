import 'package:sentry_flutter/sentry_flutter.dart';

enum EventType {
  log,
  info,
  success,
  warning,
}

extension EventTypeExtension on EventType {
  String get toStr => toString().split('.')[1];

  SentryLevel? get toSentryLevel {
    switch (this) {
      case EventType.log:
        return SentryLevel.debug;
      case EventType.info:
        return SentryLevel.info;
      case EventType.success:
        return SentryLevel.info;
      case EventType.warning:
        return SentryLevel.warning;
      default:
        return null;
    }
  }
}

class TransactionDetails {
  final String name;
  final String operation;
  final String? description;

  const TransactionDetails({
    required this.name,
    required this.operation,
    this.description,
  });
}
