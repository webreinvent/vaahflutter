import './_cloud/firebase_logging_service.dart';
import './_cloud/logging_service.dart';
import './_cloud/sentry_logging_service.dart';
import './_local/console_service.dart';
import '../../env.dart';

class Log {
  static final List<Type> _services = [
    SentryLoggingService,
    // FirebaseLoggingService,
  ];

  static void log(
    dynamic text, {
    Object? data,
    bool disableConsoleLogging = false,
    bool disableCloudLogging = false,
  }) {
    EnvironmentConfig config = EnvironmentConfig.getEnvConfig();
    if (config.enableConsoleLogs && !disableConsoleLogging) {
      Console.log(text.toString(), data);
    }
    if (config.enableCloudLogs && !disableCloudLogging) {
      _logEvent(text.toString(), data: data, type: EventType.log);
    }
  }

  static void info(
    dynamic text, {
    Object? data,
    bool disableConsoleLogging = false,
    bool disableCloudLogging = false,
  }) {
    EnvironmentConfig config = EnvironmentConfig.getEnvConfig();
    if (config.enableConsoleLogs && !disableConsoleLogging) {
      Console.info(text.toString(), data);
    }
    if (config.enableCloudLogs && !disableCloudLogging) {
      _logEvent(text.toString(), data: data, type: EventType.info);
    }
  }

  static void success(
    dynamic text, {
    Object? data,
    bool disableConsoleLogging = false,
    bool disableCloudLogging = false,
  }) {
    EnvironmentConfig config = EnvironmentConfig.getEnvConfig();
    if (config.enableConsoleLogs && !disableConsoleLogging) {
      Console.success(text.toString(), data);
    }
    if (config.enableCloudLogs && !disableCloudLogging) {
      _logEvent(text.toString(), data: data, type: EventType.success);
    }
  }

  static void warning(
    dynamic text, {
    Object? data,
    bool disableConsoleLogging = false,
    bool disableCloudLogging = false,
  }) {
    EnvironmentConfig config = EnvironmentConfig.getEnvConfig();
    if (config.enableConsoleLogs && !disableConsoleLogging) {
      Console.warning(text.toString(), data);
    }
    if (config.enableCloudLogs && !disableCloudLogging) {
      _logEvent(text.toString(), data: data, type: EventType.warning);
    }
  }

  static void exception(
    dynamic throwable, {
    Object? data,
    dynamic stackTrace,
    dynamic hint,
    bool disableConsoleLogging = false,
    bool disableCloudLogging = false,
  }) {
    EnvironmentConfig config = EnvironmentConfig.getEnvConfig();
    if (config.enableConsoleLogs && !disableConsoleLogging) {
      Console.danger(throwable.toString(), data);
    }
    if (config.enableCloudLogs && !disableCloudLogging) {
      final hintWithData = {
        'hint': hint,
        'data': data,
      };
      for (var service in _services) {
        switch (service) {
          case SentryLoggingService:
            SentryLoggingService.logException(
              throwable,
              stackTrace: stackTrace,
              hint: hintWithData,
            );
            return;
          case FirebaseLoggingService:
            FirebaseLoggingService.logException(
              throwable,
              stackTrace: stackTrace,
              hint: hintWithData,
            );
            return;
          default:
            return;
        }
      }
    }
  }

  static void _logEvent(
    String text, {
    Object? data,
    EventType? type,
  }) {
    for (var service in _services) {
      switch (service) {
        case SentryLoggingService:
          SentryLoggingService.logEvent(
            message: text,
            level: type?.toSentryLevel,
            data: data,
          );
          return;
        case FirebaseLoggingService:
          FirebaseLoggingService.logEvent(
            message: text,
            type: type,
            data: data,
          );
          return;
        default:
          return;
      }
    }
  }
}
