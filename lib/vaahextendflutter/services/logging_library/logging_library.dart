import 'package:datadog_flutter_plugin/datadog_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../env/env.dart';
import '_cloud/datadog_logging_service.dart';
import '_cloud/firebase_logging_service.dart';
import '_cloud/logging_service.dart';
import '_cloud/sentry_logging_service.dart';
import '_local/console_service.dart';
import 'models/log.dart';

class Log {
  static EnvironmentConfig get _config => EnvironmentConfig.getConfig;
  static LoggingService? _loggingService;

  static List<NavigatorObserver> navigatorObservers = [
    if (_config.cloudLoggingServiceType(isFirebaseConfigured: false).isSentry) ...[
      SentryNavigatorObserver(),
    ] else if (_config.cloudLoggingServiceType(isFirebaseConfigured: false).isDatadog) ...[
      DatadogNavigationObserver(
        datadogSdk: DataDogLoggingService.datadogSdk ?? DatadogSdk.instance,
      )
    ]
  ];

  static Future<Widget> init({
    required CloudLoggingService cloudLogging,
    required Widget app,
  }) async {
    if (cloudLogging.isSentry) {
      _loggingService = SentryLoggingService();
    } else if (cloudLogging.isDatadog) {
      _loggingService = DataDogLoggingService();
    } else if (cloudLogging.isFirebase) {
      _loggingService = FirebaseLoggingService();
    }

    final updatedApp = await _loggingService?.init(app: app);

    return updatedApp ?? app;
  }

  static void log(
    String message, {
    Map<String, dynamic>? data,
    bool disableLocalLogging = false,
    bool disableCloudLogging = false,
  }) {
    if (_config.enableLocalLogs && !disableLocalLogging) {
      Console.log(message, data: data);
    }
    if (_config.enableCloudLogs && !disableCloudLogging) {
      _logEvent(
        message,
        data: data,
        type: EventType.log,
      );
    }
  }

  static void info(
    String message, {
    Map<String, dynamic>? data,
    bool disableLocalLogging = false,
    bool disableCloudLogging = false,
  }) {
    if (_config.enableLocalLogs && !disableLocalLogging) {
      Console.info(message, data: data);
    }
    if (_config.enableCloudLogs && !disableCloudLogging) {
      _logEvent(
        message,
        data: data,
        type: EventType.info,
      );
    }
  }

  static void success(
    String message, {
    Map<String, dynamic>? data,
    bool disableLocalLogging = false,
    bool disableCloudLogging = false,
  }) {
    if (_config.enableLocalLogs && !disableLocalLogging) {
      Console.success(message, data: data);
    }
    if (_config.enableCloudLogs && !disableCloudLogging) {
      _logEvent(
        message,
        data: data,
        type: EventType.success,
      );
    }
  }

  static void warning(
    String message, {
    Map<String, dynamic>? data,
    bool disableLocalLogging = false,
    bool disableCloudLogging = false,
  }) {
    if (_config.enableLocalLogs && !disableLocalLogging) {
      Console.warning(message, data: data);
    }
    if (_config.enableCloudLogs && !disableCloudLogging) {
      _logEvent(
        message,
        data: data,
        type: EventType.warning,
      );
    }
  }

  static void _logEvent(
    String message, {
    Map<String, dynamic>? data,
    EventType? type,
  }) {
    _loggingService?.logEvent(
      message: message,
      data: data,
      type: type ?? EventType.info,
    );
  }

  static void exception(
    String message, {
    dynamic throwable,
    StackTrace? stackTrace,
    Map<String, dynamic>? hint,
    bool disableLocalLogging = false,
    bool disableCloudLogging = false,
  }) async {
    if (_config.enableLocalLogs && !disableLocalLogging) {
      Console.danger(
        message,
        throwable: throwable,
        stackTrace: stackTrace,
        hint: hint,
      );
    }
    if (_config.enableCloudLogs && !disableCloudLogging) {
      final hintWithData = {
        'hint': hint,
        'message': message,
      };
      _loggingService?.logException(
        throwable,
        hint: hintWithData,
        stackTrace: stackTrace,
      );
    }
  }

  static Future<void> setUserInfo({
    bool disableLocalLogging = false,
    bool disableCloudLogging = false,
    required String id,
    required String name,
    required String email,
    Map<String, dynamic> metaData = const {},
  }) async {
    if (_config.enableLocalLogs && !disableLocalLogging) {
      Console.info(
        name,
        data: metaData,
      );
    }
    if (_config.enableCloudLogs && !disableCloudLogging) {
      _loggingService?.setUserInfo(
        id: id,
        name: name,
        email: email,
        metaData: metaData,
      );
    }
  }

  static void unsetUserInfo({
    String? id,
    bool disableLocalLogging = false,
    bool disableCloudLogging = false,
  }) {
    _loggingService?.unsetUserInfo();

    if (_config.enableLocalLogs && !disableLocalLogging) {
      Console.info(
        'User info successfully cleared.',
      );
    }
  }

  static Future<void> logTransaction({
    required Function execute,
    required TransactionDetails details,
    bool disableLocalLogging = false,
    bool disableCloudLogging = false,
  }) async {
    if (_config.enableLocalLogs && !disableLocalLogging) {
      Console.logTransaction(execute: execute, details: details);
    }
    if (_config.enableCloudLogs && !disableCloudLogging) {
      _loggingService?.logTransaction(
        execute: execute,
        details: details,
      );
    }
  }
}
