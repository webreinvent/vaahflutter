import '../models/log.dart';

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

  static logTransaction({
    required Function execute,
    required TransactionDetails details,
  }) async =>
      UnimplementedError();
}
