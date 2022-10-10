import 'package:get/get.dart';

import 'vaahextendflutter/environment/env_helpers.dart';

// After changing any const you will need to restart the app (Hot-reload won't work).

// Version and build
const String version = '1.0.0'; // version format 1.0.0 (major.minor.patch)
const String build = '2022100901'; // build no format '2022010101'

// Production config
const EnvironmentConfig prodEnvConfig = EnvironmentConfig(
  envType: 'production',
  version: version,
  build: build,
  baseUrl: '',
  apiBaseUrl: '',
  analyticsID: '',
  enableConsoleLogs: false,
  enableLocalLogs: false,
);

// Staging/ QA config
const EnvironmentConfig stagEnvConfig = EnvironmentConfig(
  envType: 'staging',
  version: version,
  build: build,
  baseUrl: '',
  apiBaseUrl: '',
  analyticsID: '',
  enableConsoleLogs: true,
  enableLocalLogs: false,
);

// Development config
const EnvironmentConfig devEnvConfig = EnvironmentConfig(
  envType: 'development',
  version: version,
  build: build,
  baseUrl: '',
  apiBaseUrl: '',
  analyticsID: '',
  enableConsoleLogs: true,
  enableLocalLogs: true,
);

class EnvController extends GetxController {
  EnvironmentConfig _config = devEnvConfig;
  EnvironmentConfig get config => _config;

  EnvController(String environment) {
    switch (environment) {
      case 'production':
        _config = prodEnvConfig;
        break;
      case 'staging':
        _config = stagEnvConfig;
        break;
      default:
        _config = devEnvConfig;
        break;
    }
    update();
  }
}
