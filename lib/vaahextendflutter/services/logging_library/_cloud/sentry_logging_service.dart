import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../env/env.dart';
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
  void logEvent({
    required String message,
    required EventType? type,
    Map<String, dynamic>? data,
  }) {
    final SentryEvent event = SentryEvent(
      message: SentryMessage(message),
      level: type?.toSentryLevel,
    );
    Sentry.captureEvent(
      event,
      hint: data == null ? null : Hint.withMap({'data': data}),
    );
  }

  @override
  void logException(
    dynamic throwable, {
    StackTrace? stackTrace,
    Map<String, dynamic>? hint,
  }) {
    Sentry.captureException(
      throwable,
      stackTrace: stackTrace,
      hint: hint == null ? null : Hint.withMap(hint),
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
  void setUserInfo({
    String? id,
    String? name,
    String? email,
    Map<String, dynamic>? metaData,
  }) {
    Sentry.configureScope(
      (Scope scope) {
        scope.setUser(
          SentryUser(
            id: id,
            username: name,
            email: email,
            data: metaData,
          ),
        );
      },
    );
  }

  @override
  void unsetUserInfo() async {
    await Sentry.configureScope(
      (Scope scope) {
        scope.setUser(null);
      },
    );
  }
}
