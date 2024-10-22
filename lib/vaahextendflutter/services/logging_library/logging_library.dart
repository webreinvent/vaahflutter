import '../../env/env.dart';
import '_cloud/firebase_logging_service.dart';
import '_cloud/sentry_logging_service.dart';
import '_local/console_service.dart';
import 'models/log.dart';

class Log {
  static final EnvironmentConfig _config = EnvironmentConfig.getConfig;

  static final List<Type> _services = [
    SentryLoggingService,
    FirebaseLoggingService,
  ];

  static void log(
    String message, {
    Object? data,
    bool disableLocalLogging = false,
    bool disableCloudLogging = false,
  }) {
    if (_config.enableLocalLogs && !disableLocalLogging) {
      Console.log(message, data: data);
    }
    if (_config.enableCloudLogs && !disableCloudLogging) {
      _logEvent(message, data: data, type: EventType.log);
    }
  }

  static void info(
    String message, {
    Object? data,
    bool disableLocalLogging = false,
    bool disableCloudLogging = false,
  }) {
    if (_config.enableLocalLogs && !disableLocalLogging) {
      Console.info(message, data: data);
    }
    if (_config.enableCloudLogs && !disableCloudLogging) {
      _logEvent(message, data: data, type: EventType.info);
    }
  }

  static void success(
    String message, {
    Object? data,
    bool disableLocalLogging = false,
    bool disableCloudLogging = false,
  }) {
    if (_config.enableLocalLogs && !disableLocalLogging) {
      Console.success(message, data: data);
    }
    if (_config.enableCloudLogs && !disableCloudLogging) {
      _logEvent(message, data: data, type: EventType.success);
    }
  }

  static void warning(
    String message, {
    Object? data,
    bool disableLocalLogging = false,
    bool disableCloudLogging = false,
  }) {
    if (_config.enableLocalLogs && !disableLocalLogging) {
      Console.warning(message, data: data);
    }
    if (_config.enableCloudLogs && !disableCloudLogging) {
      _logEvent(message, data: data, type: EventType.warning);
    }
  }

  static void exception(
    String message, {
    Object? throwable,
    StackTrace? stackTrace,
    dynamic hint,
    bool disableLocalLogging = false,
    bool disableCloudLogging = false,
  }) {
    if (_config.enableLocalLogs && !disableLocalLogging) {
      Console.danger(
        message,
        throwable: throwable,
        stackTrace: stackTrace,
        hint: hint,
      );
    }
    if (_config.enableCloudLogs && !disableCloudLogging) {
      for (final service in _services) {
        switch (service) {
          case SentryLoggingService:
            SentryLoggingService.logException(
              message,
              throwable: throwable,
              stackTrace: stackTrace,
              hint: hint,
            );
            return;
          case FirebaseLoggingService:
            FirebaseLoggingService.logException(
              message,
              throwable: throwable,
              stackTrace: stackTrace,
              hint: hint,
            );
            return;
          default:
            return;
        }
      }
    }
  }

  static logTransaction({
    required Function execute,
    required TransactionDetails details,
    bool disableLocalLogging = false,
    bool disableCloudLogging = false,
  }) async {
    if (_config.enableLocalLogs && !disableLocalLogging) {
      Console.logTransaction(execute: execute, details: details);
    }
    if (_config.enableCloudLogs && !disableCloudLogging) {
      for (final service in _services) {
        switch (service) {
          case SentryLoggingService:
            SentryLoggingService.logTransaction(
              execute: execute,
              details: details,
            );
            return;
          case FirebaseLoggingService:
            FirebaseLoggingService.logTransaction(
              execute: execute,
              details: details,
            );
            return;
          default:
            return;
        }
      }
    }
  }

  static void _logEvent(
    String message, {
    Object? data,
    EventType? type,
  }) {
    for (final service in _services) {
      switch (service) {
        case SentryLoggingService:
          SentryLoggingService.logEvent(
            message,
            data: data,
            level: type?.toSentryLevel,
          );
          return;
        case FirebaseLoggingService:
          FirebaseLoggingService.logEvent(
            message,
            data: data,
            type: type,
          );
          return;
        default:
          return;
      }
    }
  }
}
