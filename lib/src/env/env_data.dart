import '../models/logs/log_config.dart';

class VaahEnvData {
  const VaahEnvData({
    required this.env,
    required this.appName,
    required this.packageName,
    required this.appVersion,
    required this.buildNumber,
    required this.loggerConfig,
  });

  final String env;
  final String appName;
  final String packageName;
  final String appVersion;
  final String buildNumber;
  final LoggerConfig loggerConfig;
}
