import 'dart:async';

import 'package:datadog_flutter_plugin/datadog_flutter_plugin.dart';

import '../../models/logs/log_record.dart';
import '../../models/logs/log_remote_provider.dart';
import '../../models/logs/log_level.dart' as vl;
import '../../models/user/vaah_user.dart';
import 'vaah_remote_log_provider.dart';

class VaahDatadogLogProvider implements VaahRemoteLogProvider {
  VaahDatadogLogProvider(this._env, this._config);

  final String _env;
  final DatadogRemoteProviderConfig _config;

  DatadogLogger? _logger;

  @override
  FutureOr<void> wrapAppRunner({required FutureOr<void> Function() appRunner}) async {
    final DatadogRumConfiguration? rumConfiguration;
    if (_config.rumApplicationId == null) {
      rumConfiguration = null;
    } else {
      rumConfiguration = DatadogRumConfiguration(
        applicationId: _config.rumApplicationId!,
        traceSampleRate: _config.tracesSampleRate.clamp(0, 100),
      );
    }

    final site = DatadogSite.values.firstWhere(
      (site) => site.name.toLowerCase() == _config.siteName.toLowerCase(),
      orElse: () => DatadogSite.us1,
    );

    final configuration = DatadogConfiguration(
      clientToken: _config.clientToken,
      env: _env,
      site: site,
      nativeCrashReportEnabled: true,
      loggingConfiguration: DatadogLoggingConfiguration(),
      rumConfiguration: rumConfiguration,
    );
    await DatadogSdk.runApp(configuration, TrackingConsent.granted, appRunner);
    _logger = DatadogSdk.instance.logs?.createLogger(
      DatadogLoggerConfiguration(name: 'vaah', customConsoleLogFunction: (_, _, _, _, _, _) {}),
    );
    return;
  }

  @override
  Future<void> bindUser(VaahUser user) async {
    DatadogSdk.instance.setUserInfo(
      id: user.id,
      name: user.name,
      email: user.email,
      extraInfo: {if (user.username != null) 'username': user.username},
    );
  }

  @override
  Future<void> unbindUser() async {
    DatadogSdk.instance.setUserInfo(id: null, name: null, email: null, extraInfo: const {});
  }

  @override
  Future<void> log(LogRecord record) async {
    if (record.level.priority >= vl.LogLevel.error.priority) {
      return await _logException(record);
    }
    if (!_config.logExceptionsOnly) {
      return await _logMessage(record);
    }
  }

  Future<void> _logException(LogRecord record) async {
    final attributes = <String, Object?>{'context': record.context};
    _logger?.error(
      record.message,
      errorMessage: record.error?.toString(),
      errorKind: record.error?.runtimeType.toString(),
      errorStackTrace: record.stackTrace,
      attributes: attributes,
    );
  }

  Future<void> _logMessage(LogRecord record) async {
    final attributes = <String, Object?>{'context': record.context};
    if (record.level == vl.LogLevel.debug) {
      _logger?.debug(record.message, attributes: attributes);
    } else if (record.level == vl.LogLevel.info) {
      _logger?.info(record.message, attributes: attributes);
    } else if (record.level == vl.LogLevel.warn) {
      _logger?.warn(record.message, attributes: attributes);
    }
  }

  @override
  Future<void> dispose() async {
    // no-op
  }
}
