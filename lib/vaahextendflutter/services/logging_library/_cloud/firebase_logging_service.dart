import '../models/log.dart';
import 'logging_service.dart';

abstract class FirebaseLoggingService implements LoggingService {
  static logEvent(
    String message, {
    Object? data,
    EventType? type,
  }) =>
      throw UnimplementedError();

  static logException(
    String message, {
    Object? throwable,
    StackTrace? stackTrace,
    dynamic hint,
  }) =>
      throw UnimplementedError();

  static logTransaction({
    required Function execute,
    required TransactionDetails details,
  }) async =>
      UnimplementedError();
}
