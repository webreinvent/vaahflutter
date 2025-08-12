import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
    final info = await PackageInfo.fromPlatform();
    const String env = String.fromEnvironment('ENV_CONFIG', defaultValue: '');
    final vars = jsonDecode(await rootBundle.loadString('$_filePathPrefix/$env'));

    instance._data = VaahEnvData(
      appName: info.appName,
      packageName: info.packageName,
      appVersion: info.version,
      buildNumber: info.buildNumber,
      vars: vars,
    );
  }
}
