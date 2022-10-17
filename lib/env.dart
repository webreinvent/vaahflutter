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
  apiBaseUrl: 'https://reqres.in',
  timeoutLimit: 60 * 1000, // 60 seconds
  analyticsId: '',
  enableConsoleLogs: true,
  enableLocalLogs: true,
  enableApiLogs: true,
  showEnvAndVersionTag: true,
  envAndVersionTagColor: Colors.red,
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
