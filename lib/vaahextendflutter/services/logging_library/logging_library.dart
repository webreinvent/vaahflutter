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

  static List<NavigatorObserver> loggingServiceObserver = [
    if (_config.errorLoggingTypeService(isFirebaseEnabled: false).isSentry)
      SentryNavigatorObserver()
    else if (_config.errorLoggingTypeService(isFirebaseEnabled: false).isDatadog)
      DatadogNavigationObserver(
        datadogSdk: DataDogLoggingService.datadogSdk ?? DatadogSdk.instance,
      )
  ];

  static Future<Widget> init({
    required ErrorLoggingType errorLogging,
    required Widget app,
  }) async {
    if (errorLogging.isSentry) {
      _loggingService = SentryLoggingService();
    } else if (errorLogging.isDatadog) {
      _loggingService = DataDogLoggingService();
    } else if (errorLogging.isFirebase) {
      _loggingService = FirebaseLoggingService();
    }

    final updatedApp = await _loggingService?.init(app: app);

    return updatedApp ?? app;
  }

  static Future<void> logEvent({
    required String message,
    required EventType type,
    Object? data,
    bool disableLocalLogging = false,
    bool disableCloudLogging = false,
  }) async {
    if (_config.enableLocalLogs && !disableLocalLogging) {
      Console.log(message.toString(), data);
    }
    await _loggingService?.logEvent(message: message, type: type, data: data);
  }

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

  static Future<void> exception(
    dynamic throwable, {
    Object? data,
    dynamic source,
    dynamic stackTrace,
    dynamic hint,
    RumErrorSource? rumErrorSource,
    bool disableLocalLogging = false,
    bool disableCloudLogging = false,
  }) async {
    if (_config.enableLocalLogs && !disableLocalLogging) {
      Console.danger('$throwable\n$hint', data);
    }
    if (_config.enableCloudLogs && !disableCloudLogging) {
      final hintWithData = {
        'hint': hint,
        'data': data,
      };
      await _loggingService?.logException(
        throwable,
        stackTrace: stackTrace,
        hint: hintWithData,
      );
    }
  }

  static Future<void> logUserInfo({
    bool disableLocalLogging = false,
    bool disableCloudLogging = false,
    required String id,
    required String name,
    required String email,
    Map<String, dynamic> extraInfo = const {},
  }) async {
    if (_config.enableLocalLogs && !disableLocalLogging) {
      Console.info(name, extraInfo);
    }
    if (_config.enableCloudLogs && !disableCloudLogging) {
      await _loggingService?.setUserInfoLogger(
        id: id,
        name: name,
        email: email,
        extraInfo: extraInfo,
      );
    }
  }

  static Future<void> logActions({
    bool disableLocalLogging = false,
    bool disableCloudLogging = false,
    required RumActionType rumActionType,
    required String eventName,
    Map<String, Object>? eventProperties,
  }) async {
    if (_config.enableLocalLogs && !disableLocalLogging) {
      Console.success(eventName, eventProperties);
    }
    if (_config.enableCloudLogs && !disableCloudLogging) {
      await _loggingService?.addEventsLogger(
        eventName: eventName,
        eventProperties: eventProperties ?? {},
        rumActionType: rumActionType,
      );
    }
  }

  static Future<void> logSections({
    bool disableLocalLogging = false,
    bool disableCloudLogging = false,
    required String sectionName,
    required dynamic sectionValue,
  }) async {
    if (_config.enableLocalLogs && !disableLocalLogging) {
      Console.success(sectionName, sectionValue);
    }
    if (_config.enableCloudLogs && !disableCloudLogging) {
      await _loggingService?.addSectionLogger(
        sectionName: sectionName,
        sectionValue: sectionValue,
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
      await _loggingService?.logTransaction(
        execute: execute,
        details: details,
      );
    }
  }

  static Future<void> _logEvent(
    String text, {
    Object? data,
    EventType? type,
  }) async {
    await _loggingService?.logEvent(
      message: text,
      type: type!,
      data: data,
    );
  }
}
