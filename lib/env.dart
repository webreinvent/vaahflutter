import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'vaahextendflutter/log/console.dart';

// After changing any const you will need to restart the app (Hot-reload won't work).

// Version and build
const String version = '1.0.0'; // version format 1.0.0 (major.minor.patch)
const String build = '2022100901'; // build no format 'YYYYMMDDNUMBER'

EnvironmentConfig defaultConfig = const EnvironmentConfig(
  envType: 'default',
  version: version,
  build: build,
  baseUrl: '',
  apiBaseUrl: 'http://192.168.1.12:5000',
  timeoutLimit: 60 * 1000, // 60 seconds
  analyticsId: '',
  enableConsoleLogs: true,
  enableLocalLogs: true,
  enableApiLogs: true,
  showEnvAndVersionTag: true,
  envAndVersionTagColor: kDangerColor,
);

// To add new configuration add new key, value pair in envConfigs
Map<String, EnvironmentConfig> envConfigs = {
  // Do not remove default config
  'default': defaultConfig.copyWith(
    envType: 'default',
  ),
  'develop': defaultConfig.copyWith(
    envType: 'develop',
    enableLocalLogs: false,
  ),
  'stage': defaultConfig.copyWith(
    envType: 'stage',
    enableLocalLogs: false,
  ),
  'production': defaultConfig.copyWith(
    envType: 'production',
    enableConsoleLogs: false,
    enableLocalLogs: false,
    showEnvAndVersionTag: false,
  ),
};

class EnvController extends GetxController {
  late EnvironmentConfig _config;
  EnvironmentConfig get config => _config;

  EnvController(String environment) {
    try {
      _config = getSpecificConfig(environment);
      update();
    } catch (e) {
      Console.danger(e.toString());
      exit(0);
    }
  }

  EnvironmentConfig getSpecificConfig(String key) {
    bool configExists = envConfigs.containsKey(key);
    if (configExists) {
      return envConfigs[key]!;
    }
    throw Exception('Environment configuration not found for key: $key');
  }
}

class EnvironmentConfig {
  final String envType;
  final String version;
  final String build;
  final String baseUrl;
  final String apiBaseUrl;
  final int timeoutLimit; // in milli seconds
  final String analyticsId;
  final bool enableConsoleLogs;
  final bool enableLocalLogs;
  final bool enableApiLogs;
  final bool showEnvAndVersionTag;
  final Color envAndVersionTagColor;

  const EnvironmentConfig({
    required this.envType,
    required this.version,
    required this.build,
    required this.baseUrl,
    required this.apiBaseUrl,
    required this.timeoutLimit,
    required this.analyticsId,
    required this.enableConsoleLogs,
    required this.enableLocalLogs,
    required this.enableApiLogs,
    required this.showEnvAndVersionTag,
    required this.envAndVersionTagColor,
  });

  EnvironmentConfig copyWith({
    String? envType,
    String? version,
    String? build,
    String? baseUrl,
    String? apiBaseUrl,
    int? timeoutLimit,
    String? analyticsId,
    bool? enableConsoleLogs,
    bool? enableLocalLogs,
    bool? enableApiLogs,
    bool? showEnvAndVersionTag,
    Color? envAndVersionTagColor,
  }) {
    return EnvironmentConfig(
      envType: envType ?? this.envType,
      version: version ?? this.version,
      build: build ?? this.build,
      baseUrl: baseUrl ?? this.baseUrl,
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
      timeoutLimit: timeoutLimit ?? this.timeoutLimit,
      analyticsId: analyticsId ?? this.analyticsId,
      enableConsoleLogs: enableConsoleLogs ?? this.enableConsoleLogs,
      enableLocalLogs: enableLocalLogs ?? this.enableLocalLogs,
      enableApiLogs: enableApiLogs ?? this.enableApiLogs,
      showEnvAndVersionTag: showEnvAndVersionTag ?? this.showEnvAndVersionTag,
      envAndVersionTagColor:
          envAndVersionTagColor ?? this.envAndVersionTagColor,
    );
  }
}

const MaterialColor kPrimaryColor = MaterialColor(
  0xFF3366FF,
  <int, Color>{
    50: Color(0xFFD6E4FF),
    100: Color(0xFFD6E4FF),
    200: Color(0xFFADC8FF),
    300: Color(0xFF84A9FF),
    400: Color(0xFF6690FF),
    500: Color(0xFF3366FF),
    600: Color(0xFF254EDB),
    700: Color(0xFF1939B7),
    800: Color(0xFF102693),
    900: Color(0xFF091A7A),
  },
);

const MaterialColor kSuccessColor = MaterialColor(
  0xFF4FB52D,
  <int, Color>{
    50: Color(0xFFE9FBD5),
    100: Color(0xFFE9FBD5),
    200: Color(0xFFCFF7AD),
    300: Color(0xFFA8E87F),
    400: Color(0xFF81D25B),
    500: Color(0xFF4FB52D),
    600: Color(0xFF369B20),
    700: Color(0xFF228216),
    800: Color(0xFF11680E),
    900: Color(0xFF08560B),
  },
);

const MaterialColor kInfoColor = MaterialColor(
  0xFF4CA8FF,
  <int, Color>{
    50: Color(0xFFDBF4FF),
    100: Color(0xFFDBF4FF),
    200: Color(0xFFB7E7FF),
    300: Color(0xFF93D5FF),
    400: Color(0xFF78C4FF),
    500: Color(0xFF4CA8FF),
    600: Color(0xFF3783DB),
    700: Color(0xFF2662B7),
    800: Color(0xFF184493),
    900: Color(0xFF0E2F7A),
  },
);

const MaterialColor kWarningColor = MaterialColor(
  0xFFFFBF00,
  <int, Color>{
    50: Color(0xFFFFF7CC),
    100: Color(0xFFFFF7CC),
    200: Color(0xFFFFED99),
    300: Color(0xFFFFE066),
    400: Color(0xFFFFD33F),
    500: Color(0xFFFFBF00),
    600: Color(0xFFDB9E00),
    700: Color(0xFFB77F00),
    800: Color(0xFF936300),
    900: Color(0xFF7A4E00),
  },
);

const MaterialColor kDangerColor = MaterialColor(
  0xFFFF382D,
  <int, Color>{
    50: Color(0xFFFFE5D5),
    100: Color(0xFFFFE5D5),
    200: Color(0xFFFFC4AB),
    300: Color(0xFFFF9C81),
    400: Color(0xFFFF7661),
    500: Color(0xFFFF382D),
    600: Color(0xFFDB2026),
    700: Color(0xFFB71629),
    800: Color(0xFF930E28),
    900: Color(0xFF7A0828),
  },
);



const MaterialColor kWhiteColor = MaterialColor(
  0xFFFFFFFF,
  <int, Color>{
    50: Color(0xFFFFFFFF),
    100: Color(0xFFFFFFFF),
    200: Color(0xFFFFFFFF),
    300: Color(0xFFFFFFFF),
    400: Color(0xFFFFFFFF),
    500: Color(0xFFFFFFFF),
    600: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
    800: Color(0xFFFFFFFF),
    900: Color(0xFFFFFFFF),
  },
);

const MaterialColor kBlackColor = MaterialColor(
  0xFF000000,
  <int, Color>{
    50: Color(0xFFF2F2F2),
    100: Color(0xFFF2F2F2),
    200: Color(0xFFE5E5E5),
    300: Color(0xFFB2B2B2),
    400: Color(0xFF666666),
    500: Color(0xFF000000),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);
