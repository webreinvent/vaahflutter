import 'dart:async';

import 'package:sentry_flutter/sentry_flutter.dart';

import '../../models/logs/log_record.dart';
import '../../models/logs/log_level.dart';
import '../../models/logs/log_remote_provider.dart';
import '../../models/user/vaah_user.dart';
import 'vaah_remote_log_provider.dart';

class VaahSentryLogProvider implements VaahRemoteLogProvider {
  const VaahSentryLogProvider(this._env, this._config);

  final String _env;
  final SentryRemoteProviderConfig _config;

  @override
  FutureOr<void> wrapAppRunner({required FutureOr<void> Function() appRunner}) {
    return SentryFlutter.init((options) {
      options.dsn = _config.dsn;
      options.tracesSampleRate = (_config.tracesSampleRate / 100).clamp(0, 1);
      options.environment = _env;
    }, appRunner: appRunner);
  }

  @override
  Future<void> bindUser(VaahUser user) async {
    await Sentry.configureScope((scope) {
      scope.setUser(
        SentryUser(id: user.id, username: user.username, email: user.email, name: user.name),
      );
    });
  }

  @override
  Future<void> unbindUser() async {
    await Sentry.configureScope((scope) {
      scope.setUser(null);
    });
  }

  @override
  Future<void> log(LogRecord record) async {
    if (record.level.priority >= LogLevel.error.priority) {
      return await _logException(record);
    }
    if (!_config.logExceptionsOnly) {
      return await _logMessage(record);
    }
  }

  Future<void> _logException(LogRecord record) async {
    await Sentry.captureException(
      record.error ?? record.message,
      stackTrace: record.stackTrace,
      message: SentryMessage(record.message),
      withScope: (Scope scope) {
        scope.level = _mapLevel(record.level);
        if (record.context?.entries.isNotEmpty ?? false) {
          for (final entry in record.context!.entries) {
            scope.setContexts(entry.key, entry.value);
          }
        }
      },
    );
  }

  Future<void> _logMessage(LogRecord record) async {
    await Sentry.captureMessage(
      record.message,
      level: _mapLevel(record.level),
      withScope: (scope) {
        if (record.context?.entries.isNotEmpty ?? false) {
          for (final entry in record.context!.entries) {
            scope.setContexts(entry.key, entry.value);
          }
        }
      },
    );
  }

  SentryLevel _mapLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return SentryLevel.debug;
      case LogLevel.info:
        return SentryLevel.info;
      case LogLevel.warn:
        return SentryLevel.warning;
      case LogLevel.error:
        return SentryLevel.error;
      case LogLevel.fatal:
        return SentryLevel.fatal;
    }
  }

  @override
  Future<void> dispose() async {
    // no-op
  }
}
