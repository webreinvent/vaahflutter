import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../env/env.dart';
import '../_local/console_service.dart';
import '../models/log.dart';
import 'logging_service.dart';

class SentryLoggingService implements LoggingService {
  static EnvironmentConfig get _config => EnvironmentConfig.getConfig;

  @override
  Future<Widget> init({
    required Widget app,
  }) async {
    Widget widget = app;
    await SentryFlutter.init(
      (options) => options
        ..dsn = _config.sentryConfig!.dsn
        ..autoAppStart = _config.sentryConfig!.autoAppStart
        ..tracesSampleRate = _config.sentryConfig!.tracesSampleRate
        ..enableAutoPerformanceTracing = _config.sentryConfig!.enableAutoPerformanceTracing
        ..enableUserInteractionTracing = _config.sentryConfig!.enableUserInteractionTracing
        ..environment = _config.envType,
    );

    if (_config.sentryConfig!.enableUserInteractionTracing) {
      widget = SentryUserInteractionWidget(
        child: widget,
      );
    }
    if (_config.sentryConfig!.enableAssetsInstrumentation) {
      widget = DefaultAssetBundle(
        bundle: SentryAssetBundle(
          enableStructuredDataTracing: true,
        ),
        child: widget,
      );
    }
    return widget;
  }

  @override
  Future<void> addEventsLogger({
    required dynamic rumActionType,
    required String eventName,
    Map<String, Object>? eventProperties,
  }) async {
    Console.log(
      "~~~~~~> This method should be avoided with this logging service, as it doesn't do anything",
    );
  }

  @override
  Future<void> addSectionLogger({
    required String sectionName,
    required sectionValue,
  }) async {
    Console.log(
      "~~~~~~> This method should be avoided with this logging service, as it doesn't do anything",
    );
  }

  @override
  Future<void> logEvent({
    required String message,
    EventType? type,
    Object? data,
  }) async {
    final SentryEvent event = SentryEvent(
      message: SentryMessage(message),
      level: type!.toSentryLevel,
    );
    Sentry.captureEvent(
      event,
      hint: data == null ? null : Hint.withMap({'data': data}),
    );
  }

  @override
  Future<void> logException(
    throwable, {
    source,
    stackTrace,
    hint,
  }) async {
    Sentry.captureException(
      throwable,
      stackTrace: stackTrace,
      hint: hint,
    );
  }

  @override
  Future<void> logTransaction({
    required Function execute,
    required TransactionDetails details,
  }) async {
    final ISentrySpan transaction = Sentry.startTransaction(
      details.name,
      details.operation,
    );
    await execute();
    await transaction.finish();
  }

  @override
  Future<void> setUserInfoLogger({
    String? id,
    String? name,
    String? email,
    Map<String, dynamic>? extraInfo,
  }) async {
    Console.log(
      "~~~~~~> This method should be avoided with this logging service, as it doesn't do anything",
    );
  }
}
