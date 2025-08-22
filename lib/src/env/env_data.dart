import '../models/logs/log_config.dart';
import '../models/push_notifications/push_notifications_config.dart';

class VaahEnvData {
  const VaahEnvData({
    required this.env,
    required this.appName,
    required this.packageName,
    required this.appVersion,
    required this.buildNumber,
    required this.loggerConfig,
    this.pushNotificationsConfig,
  });

  final String env;
  final String appName;
  final String packageName;
  final String appVersion;
  final String buildNumber;
  final LoggerConfig loggerConfig;
  final PushNotificationsConfig? pushNotificationsConfig;
}
