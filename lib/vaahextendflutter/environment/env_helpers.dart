// ****************************************
// Main.dart Environment helpers starts
// ****************************************

String getEnvFromCommandLine() {
  String environment =
      const String.fromEnvironment('environment', defaultValue: 'development');
  if (!(environment == 'production' || environment == 'staging')) {
    environment = 'development';
  }
  return environment;
}

// ****************************************
// Main.dart helpers ends
// ****************************************

class EnvironmentConfig {
  final String envType;
  final String version;
  final String build;
  final String baseUrl;
  final String apiBaseUrl;
  final String analyticsID;
  final bool enableConsoleLogs;
  final bool enableLocalLogs;

  const EnvironmentConfig({
    required this.envType,
    required this.version,
    required this.build,
    required this.baseUrl,
    required this.apiBaseUrl,
    required this.analyticsID,
    required this.enableConsoleLogs,
    required this.enableLocalLogs,
  });
}
