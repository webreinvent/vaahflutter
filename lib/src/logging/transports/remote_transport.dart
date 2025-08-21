import 'dart:async';

import '../../models/logs/logs.dart';
import '../../models/user/vaah_user.dart';
import '../integrations/vaah_datadog.dart';
import '../integrations/vaah_remote_log_provider.dart';
import '../integrations/vaah_sentry.dart';

class RemoteTransport {
  RemoteTransport(this._env, this._config) {
    if (_config.remoteProviderConfig is SentryRemoteProviderConfig) {
      _remoteLogProvider = VaahSentryLogProvider(
        _env,
        _config.remoteProviderConfig as SentryRemoteProviderConfig,
      );
    } else if (_config.remoteProviderConfig is DatadogRemoteProviderConfig) {
      _remoteLogProvider = VaahDatadogLogProvider(
        _env,
        _config.remoteProviderConfig as DatadogRemoteProviderConfig,
      );
    }
  }

  final String _env;
  final LoggerConfig _config;
  VaahRemoteLogProvider? _remoteLogProvider;

  FutureOr<void> wrapAppRunner({required FutureOr<void> Function() appRunner}) {
    return _remoteLogProvider?.wrapAppRunner(appRunner: appRunner) ?? appRunner();
  }

  Future<void> bindUser(VaahUser user) async {
    return _remoteLogProvider?.bindUser(user);
  }

  Future<void> unbindUser() async {
    return _remoteLogProvider?.unbindUser();
  }

  Future<void> log(LogRecord record) async {
    return _remoteLogProvider?.log(record);
  }

  Future<void> dispose() async {
    return _remoteLogProvider?.dispose();
  }
}
