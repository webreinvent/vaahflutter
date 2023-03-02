import 'package:sentry_flutter/sentry_flutter.dart';

import './logging_service.dart';

abstract class SentryLoggingService implements LoggingService {
  static logEvent({
    required String message,
    SentryLevel? level,
    Object? data,
  }) {
    final SentryEvent event = SentryEvent(message: SentryMessage(message), level: level);
    Sentry.captureEvent(
      event,
      hint: data,
    );
  }

  static logException(
    dynamic throwable, {
    dynamic stackTrace,
    dynamic hint,
  }) {
    Sentry.captureException(throwable, stackTrace: stackTrace, hint: hint);
  }

  static logTransactionTime(
    Function execute,
  ) =>
      UnimplementedError();
}
