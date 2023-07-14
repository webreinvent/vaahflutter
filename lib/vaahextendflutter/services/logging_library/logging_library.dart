import '../../env.dart';
import '_cloud/firebase_logging_service.dart';
import '_cloud/sentry_logging_service.dart';
import '_local/console_service.dart';
import 'models/log.dart';

class Log {
  static final EnvironmentConfig _config = EnvironmentConfig.getEnvConfig();

  static final List<Type> _services = [
    SentryLoggingService,
    FirebaseLoggingService,
  ];

  static void log(
    dynamic text, {
    Object? data,
    bool disableLocalLogging = false,
    bool disableCloudLogging = false,
  }) {
    if (_config.enableLocalLogs && !disableLocalLogging) {
      Console.log(text.toString(), data);
    }
    if (_config.enableCloudLogs && !disableCloudLogging) {
      _logEvent(text.toString(), data: data, type: EventType.log);
    }
  }

  static void info(
    dynamic text, {
    Object? data,
    bool disableLocalLogging = false,
    bool disableCloudLogging = false,
  }) {
    if (_config.enableLocalLogs && !disableLocalLogging) {
      Console.info(text.toString(), data);
    }
    if (_config.enableCloudLogs && !disableCloudLogging) {
      _logEvent(text.toString(), data: data, type: EventType.info);
    }
  }

  static void success(
    dynamic text, {
    Object? data,
    bool disableLocalLogging = false,
    bool disableCloudLogging = false,
  }) {
    if (_config.enableLocalLogs && !disableLocalLogging) {
      Console.success(text.toString(), data);
    }
    if (_config.enableCloudLogs && !disableCloudLogging) {
      _logEvent(text.toString(), data: data, type: EventType.success);
    }
  }

  static void warning(
    dynamic text, {
    Object? data,
    bool disableLocalLogging = false,
    bool disableCloudLogging = false,
  }) {
    if (_config.enableLocalLogs && !disableLocalLogging) {
      Console.warning(text.toString(), data);
    }
    if (_config.enableCloudLogs && !disableCloudLogging) {
      _logEvent(text.toString(), data: data, type: EventType.warning);
    }
  }

  static void exception(
    dynamic throwable, {
    Object? data,
    dynamic stackTrace,
    dynamic hint,
    bool disableLocalLogging = false,
    bool disableCloudLogging = false,
  }) {
    if (_config.enableLocalLogs && !disableLocalLogging) {
      Console.danger('$throwable\n$hint', data);
    }
    if (_config.enableCloudLogs && !disableCloudLogging) {
      final hintWithData = {
        'hint': hint,
        'data': data,
      };
      for (final service in _services) {
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
    String text, {
    Object? data,
    EventType? type,
  }) {
    for (final service in _services) {
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
