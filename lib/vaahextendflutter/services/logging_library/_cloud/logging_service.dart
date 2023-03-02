import 'package:sentry_flutter/sentry_flutter.dart';

abstract class LoggingService {
  static logEvent({
    required String message,
    required EventType type,
    Object? data,
  }) =>
      UnimplementedError();

  static logException(
    dynamic throwable, {
    dynamic stackTrace,
    dynamic hint,
  }) =>
      UnimplementedError();

  static logTransactionTime(
    Function execute,
  ) =>
      UnimplementedError();
}

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
