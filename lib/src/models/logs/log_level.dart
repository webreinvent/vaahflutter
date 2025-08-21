enum LogLevel {
  debug(10),
  info(20),
  warn(30),
  error(40),
  fatal(50);

  const LogLevel(this.priority);
  final int priority;

  static LogLevel fromJson(String value) {
    switch (value.toLowerCase()) {
      case 'debug':
        return LogLevel.debug;
      case 'info':
        return LogLevel.info;
      case 'warn':
        return LogLevel.warn;
      case 'error':
        return LogLevel.error;
      case 'fatal':
        return LogLevel.fatal;
      default:
        return LogLevel.info;
    }
  }

  @override
  String toString() => name;
}
