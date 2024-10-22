import 'package:sentry_flutter/sentry_flutter.dart';

import '../models/log.dart';
import 'logging_service.dart';

abstract class SentryLoggingService implements LoggingService {
  static logEvent(
    String message, {
    Object? data,
    SentryLevel? level,
  }) {
    final SentryEvent event = SentryEvent(message: SentryMessage(message), level: level);
    Sentry.captureEvent(
      event,
      hint: data == null ? null : Hint.withMap({'data': data}),
    );
  }

  static logException(
    String message, {
    Object? throwable,
    StackTrace? stackTrace,
    dynamic hint,
  }) {
    Sentry.captureException(
      throwable,
      stackTrace: stackTrace,
      hint: Hint.withMap({
        "message": message,
        "hint": hint,
      }),
    );
  }

  static logTransaction({
    required Function execute,
    required TransactionDetails details,
  }) async {
    final ISentrySpan transaction = Sentry.startTransaction(details.name, details.operation);
    await execute();
    await transaction.finish();
  }
}
