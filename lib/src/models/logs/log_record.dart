import 'log_level.dart';

class LogRecord {
  LogRecord({
    required this.timestamp,
    required this.level,
    required this.message,
    this.context,
    this.error,
    this.stackTrace,
  });

  final DateTime timestamp;
  final LogLevel level;
  final String message;
  final Map<String, dynamic>? context;
  final Object? error;
  final StackTrace? stackTrace;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'ts': timestamp.toUtc().toIso8601String(),
      'level': level.name,
      'msg': message,
    };
    if (context != null) {
      json.addAll(context!);
    }
    if (error != null) {
      json['error'] = error.toString();
    }
    if (stackTrace != null) {
      json['stack'] = stackTrace.toString();
    }
    return json;
  }
}
