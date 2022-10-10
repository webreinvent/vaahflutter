import 'vaahextendflutter/environment/env_helpers.dart';

const AppVersion version = AppVersion(version: '1.0.0', build: '2022100901');

// After changing any const you will need to restart the app (Hot-reload won't work).

// Production config
const EnvironmentConfig prodEnvConfig = EnvironmentConfig(
  envType: 'prod',
  version: version,
  baseUrl: '',
  apiBaseUrl: '',
  analyticsID: '',
  enableConsoleLogs: false,
  enableLocalLogs: false,
);

// Staging/ QA config
const EnvironmentConfig stagEnvConfig = EnvironmentConfig(
  envType: 'stag',
  version: version,
  baseUrl: '',
  apiBaseUrl: '',
  analyticsID: '',
  enableConsoleLogs: true,
  enableLocalLogs: false,
);

// Development config
const EnvironmentConfig devEnvConfig = EnvironmentConfig(
  envType: 'dev',
  version: version,
  baseUrl: '',
  apiBaseUrl: '',
  analyticsID: '',
  enableConsoleLogs: true,
  enableLocalLogs: true,
);
