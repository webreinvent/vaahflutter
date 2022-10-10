import 'package:get/get.dart';

// After changing any const you will need to restart the app (Hot-reload won't work).

// Version and build
const String version = '1.0.0'; // version format 1.0.0 (major.minor.patch)
const String build = '2022100901'; // build no format '2022010101'

// Default config
const EnvironmentConfig defaultEnvironmentConfig = EnvironmentConfig(
  envType: 'default',
  version: version,
  build: build,
  baseUrl: '',
  apiBaseUrl: '',
  analyticsId: '',
  enableConsoleLogs: true,
  enableLocalLogs: true,
);

// Develop config
const EnvironmentConfig developEnvironmentConfig = EnvironmentConfig(
  envType: 'develop',
  version: version,
  build: build,
  baseUrl: '',
  apiBaseUrl: '',
  analyticsId: '',
  enableConsoleLogs: true,
  enableLocalLogs: true,
);

// Staging/ QA config
const EnvironmentConfig stageEnvironmentConfig = EnvironmentConfig(
  envType: 'stage',
  version: version,
  build: build,
  baseUrl: '',
  apiBaseUrl: '',
  analyticsId: '',
  enableConsoleLogs: true,
  enableLocalLogs: false,
);

// Production config
const EnvironmentConfig productionEnvironmentConfig = EnvironmentConfig(
  envType: 'production',
  version: version,
  build: build,
  baseUrl: '',
  apiBaseUrl: '',
  analyticsId: '',
  enableConsoleLogs: false,
  enableLocalLogs: false,
);

class EnvController extends GetxController {
  EnvironmentConfig _config = defaultEnvironmentConfig;
  EnvironmentConfig get config => _config;

  EnvController(String environment) {
    switch (environment) {
      case 'develop':
        _config = developEnvironmentConfig;
        break;
      case 'stage':
        _config = stageEnvironmentConfig;
        break;
      case 'production':
        _config = productionEnvironmentConfig;
        break;
      default:
        _config = defaultEnvironmentConfig;
        break;
    }
    update();
  }
}

String getEnvFromCommandLine() {
  String environment =
      const String.fromEnvironment('environment', defaultValue: 'default');
  if (!(environment == 'develop' ||
      environment == 'stage' ||
      environment == 'production')) {
    environment = 'default';
  }
  return environment;
}

class EnvironmentConfig {
  final String envType;
  final String version;
  final String build;
  final String baseUrl;
  final String apiBaseUrl;
  final String analyticsId;
  final bool enableConsoleLogs;
  final bool enableLocalLogs;

  const EnvironmentConfig({
    required this.envType,
    required this.version,
    required this.build,
    required this.baseUrl,
    required this.apiBaseUrl,
    required this.analyticsId,
    required this.enableConsoleLogs,
    required this.enableLocalLogs,
  });
}
