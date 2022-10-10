// ****************************************
// Main.dart Environment helpers starts
// ****************************************

String getEnvFromCommandLine() {
  String environment =
      const String.fromEnvironment('environment', defaultValue: 'dev');
  if (!(environment == 'prod' || environment == 'stag')) {
    environment = 'dev';
  }
  return environment;
}

// ****************************************
// Main.dart helpers ends
// ****************************************

class AppVersion {
  final String build; // build no format '2022010101'
  final String version; // version format 1.0.0 (major.minor.patch)

  const AppVersion({required this.build, required this.version});
}

class EnvironmentConfig {
  final String envType;
  final AppVersion version;
  final String baseUrl;
  final String apiBaseUrl;
  final String analyticsID;
  final bool enableConsoleLogs;
  final bool enableLocalLogs;

  const EnvironmentConfig({
    required this.envType,
    required this.version,
    required this.baseUrl,
    required this.apiBaseUrl,
    required this.analyticsID,
    required this.enableConsoleLogs,
    required this.enableLocalLogs,
  });
}
