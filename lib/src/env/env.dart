import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../models/logs/log_config.dart';
import 'env_data.dart';

export 'env_data.dart';

const String _filePathPrefix = 'assets/env';

class VaahEnv {
  VaahEnv._internal();
  static final VaahEnv instance = VaahEnv._internal();

  VaahEnvData? _data;
  VaahEnvData get data {
    if (_data == null) {
      throw Exception('VaahEnv has not been initialized');
    }
    return _data!;
  }

  static Future<void> init() async {
    const String rawConfig = String.fromEnvironment('ENV_CONFIG', defaultValue: '');
    final dynamic decodedConfig = jsonDecode(
      await rootBundle.loadString('$_filePathPrefix/$rawConfig'),
    );

    final String env = decodedConfig['env'] ?? 'development';

    final LoggerConfig loggerConfig;
    if (decodedConfig['logger_config'] != null &&
        decodedConfig['logger_config'] is Map<String, dynamic>) {
      loggerConfig = LoggerConfig.fromJson(decodedConfig['logger_config']);
    } else {
      loggerConfig = const LoggerConfig();
    }

    final info = await PackageInfo.fromPlatform();

    instance._data = VaahEnvData(
      env: env,
      appName: info.appName,
      packageName: info.packageName,
      appVersion: info.version,
      buildNumber: info.buildNumber,
      loggerConfig: loggerConfig,
    );
  }
}
