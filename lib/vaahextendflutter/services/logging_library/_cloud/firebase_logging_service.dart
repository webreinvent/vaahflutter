import './logging_service.dart';
import '../models/log.dart';

abstract class FirebaseLoggingService implements LoggingService {
  static logEvent({
    required String message,
    EventType? type,
    Object? data,
  }) =>
      throw UnimplementedError();

  static logException(
    dynamic throwable, {
    dynamic stackTrace,
    dynamic hint,
  }) =>
      throw UnimplementedError();

  static logTransaction({
    required Function execute,
    required TransactionDetails details,
  }) async =>
      UnimplementedError();
}
