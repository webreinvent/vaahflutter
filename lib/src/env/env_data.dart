class VaahEnvData {
  const VaahEnvData({
    required this.appName,
    required this.packageName,
    required this.appVersion,
    required this.buildNumber,
    required this.vars,
  });

  final String appName;
  final String packageName;
  final String appVersion;
  final String buildNumber;
  final Map<String, dynamic> vars;
}
