import 'dart:ui';
import 'package:datadog_flutter_plugin/datadog_flutter_plugin.dart';
import 'package:datadog_tracking_http_client/datadog_tracking_http_client.dart';
import 'package:flutter/material.dart';
import '../../../env/env.dart';
import '../_local/console_service.dart';
import '../models/log.dart';
import 'logging_service.dart';

///DataDogLoggingService - It implements Datadog used for error monitoring and logging data.
class DataDogLoggingService implements LoggingService {
  static DatadogSdk? datadogSdk;

  static EnvironmentConfig get _config => EnvironmentConfig.getConfig;

  @override
  Future<Widget> init({
    required Widget app,
  }) async {
    // Initialize DataDog
    datadogSdk ??= DatadogSdk.instance;

    // Initialize the logger with network info enabled
    final configuration = DatadogLoggerConfiguration(networkInfoEnabled: true);
    datadogSdk?.logs?.createLogger(configuration);

    // Initialize DataDog with the configuration and consent
    datadogSdk?.initialize(await _generateConfig(), TrackingConsent.granted);

    // Initialize error handling
    _initializeErrorHandling();

    return app;
  }

// Generate config for DataDog
  static Future<DatadogConfiguration> _generateConfig() async {
    return DatadogConfiguration(
      clientToken: _config.datadogConfig?.clientToken ?? '',
      env: _config.envType.toLowerCase(),
      site: _config.datadogConfig?.site ?? DatadogSite.us5,
      nativeCrashReportEnabled: _config.datadogConfig?.nativeCrashReportEnabled ?? false,
      loggingConfiguration: DatadogLoggingConfiguration(),
      rumConfiguration: DatadogRumConfiguration(
        applicationId: _config.datadogConfig?.applicationId ?? '',
        sessionSamplingRate: 50,
        reportFlutterPerformance: _config.datadogConfig?.reportFlutterPerformance ?? false,
        traceSampleRate: _config.datadogConfig?.tracesSampleRate ?? 20.0,
      ),
      version: _config.version,
      firstPartyHosts: _config.datadogConfig?.firstPartyHosts ?? [],
    )..enableHttpTracking();
  }

// Initialize error handling
  static void _initializeErrorHandling() {
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      datadogSdk?.rum?.handleFlutterError(details);
      originalOnError?.call(details);
    };
    final platformOriginalOnError = PlatformDispatcher.instance.onError;
    PlatformDispatcher.instance.onError = (e, st) {
      datadogSdk?.rum?.addErrorInfo(
        e.toString(),
        RumErrorSource.source,
        stackTrace: st,
      );
      return platformOriginalOnError?.call(e, st) ?? false;
    };
  }

  @override
  Future<void> logException(throwable, {source, stackTrace, hint}) async {
    datadogSdk?.rum?.addError(
      throwable,
      source ?? RumErrorSource.custom,
      stackTrace: stackTrace,
      attributes: hint,
    );
  }

  @override
  Future<void> setUserInfoLogger({
    String? id,
    String? name,
    String? email,
    Map<String, dynamic>? extraInfo,
  }) async {
    datadogSdk?.setUserInfo(
      id: id,
      name: name,
      email: email,
      extraInfo: extraInfo ?? {},
    );
  }

  @override
  Future<void> logEvent({
    required String message,
    required EventType type,
    Object? data,
  }) async {
    Console.log(
      "~~~~~~> This method should be avoided with this logging service, as it doesn't do anything",
    );
  }

  @override
  Future<void> addEventsLogger({
    required RumActionType rumActionType,
    required String eventName,
    Map<String, Object>? eventProperties,
  }) async {
    datadogSdk?.rum?.addAction(
      rumActionType,
      eventName,
      eventProperties ?? {},
    );
  }

  @override
  Future<void> addSectionLogger({
    required String sectionName,
    required sectionValue,
  }) async {
    datadogSdk?.rum?.addAttribute(sectionName, sectionValue);
  }

  @override
  Future<void> logTransaction({
    required Function execute,
    required TransactionDetails details,
  }) async {
    Console.log(
      "~~~~~~> This method should be avoided with this logging service, as it doesn't do anything",
    );
  }
}
