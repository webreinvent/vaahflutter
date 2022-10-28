// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

<<<<<<< Updated upstream
import 'theme.dart';
import 'vaahextendflutter/helpers/console_log_helper.dart';
=======
<<<<<<< Updated upstream
import 'vaahextendflutter/log/console.dart';
=======
import 'app_theme.dart';
import 'vaahextendflutter/helpers/console_log_helper.dart';
>>>>>>> Stashed changes
>>>>>>> Stashed changes

// After changing any const you will need to restart the app (Hot-reload won't work).

// Version and build
const String version = '1.0.0'; // version format 1.0.0 (major.minor.patch)
const String build = '2022100901'; // build no format 'YYYYMMDDNUMBER'

<<<<<<< Updated upstream
final EnvironmentConfig defaultConfig = EnvironmentConfig(
=======
<<<<<<< Updated upstream
EnvironmentConfig defaultConfig = const EnvironmentConfig(
=======
final EnvironmentConfig defaultConfig = EnvironmentConfig(
  appTitle: 'WebReinvent Team',
  appTitleShort: 'Team',
>>>>>>> Stashed changes
>>>>>>> Stashed changes
  envType: 'default',
  version: version,
  build: build,
  backendUrl: '',
  apiUrl: 'https://apivoid.herokuapp.com',
  timeoutLimit: 60 * 1000, // 60 seconds
  firebaseId: '',
  enableConsoleLogs: true,
  enableLocalLogs: true,
  enableApiLogs: true,
  showEnvAndVersionTag: true,
  envAndVersionTagColor: AppTheme.colors['black']!.withOpacity(0.7),
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
  final String appTitle;
  final String appTitleShort;
  final String envType;
  final String version;
  final String build;
  final String backendUrl;
  final String apiUrl;
  final String firebaseId;
  final int timeoutLimit;
  final bool enableConsoleLogs;
  final bool enableLocalLogs;
  final bool enableApiLogs;
  final bool showEnvAndVersionTag;
  final Color envAndVersionTagColor;

  const EnvironmentConfig({
    required this.appTitle,
    required this.appTitleShort,
    required this.envType,
    required this.version,
    required this.build,
    required this.backendUrl,
    required this.apiUrl,
    required this.firebaseId,
    required this.timeoutLimit,
    required this.enableConsoleLogs,
    required this.enableLocalLogs,
    required this.enableApiLogs,
    required this.showEnvAndVersionTag,
    required this.envAndVersionTagColor,
  });

  static EnvironmentConfig getEnvConfig() {
    EnvController envController = Get.find<EnvController>();
    return envController.config;
  }

  EnvironmentConfig copyWith({
    String? appTitle,
    String? appTitleShort,
    String? envType,
    String? version,
    String? build,
    String? backendUrl,
    String? apiUrl,
    String? firebaseId,
    int? timeoutLimit,
    bool? enableConsoleLogs,
    bool? enableLocalLogs,
    bool? enableApiLogs,
    bool? showEnvAndVersionTag,
    Color? envAndVersionTagColor,
  }) {
    return EnvironmentConfig(
      appTitle: appTitle ?? this.appTitle,
      appTitleShort: appTitleShort ?? this.appTitleShort,
      envType: envType ?? this.envType,
      version: version ?? this.version,
      build: build ?? this.build,
      backendUrl: backendUrl ?? this.backendUrl,
      apiUrl: apiUrl ?? this.apiUrl,
      firebaseId: firebaseId ?? this.firebaseId,
      timeoutLimit: timeoutLimit ?? this.timeoutLimit,
      enableConsoleLogs: enableConsoleLogs ?? this.enableConsoleLogs,
      enableLocalLogs: enableLocalLogs ?? this.enableLocalLogs,
      enableApiLogs: enableApiLogs ?? this.enableApiLogs,
      showEnvAndVersionTag: showEnvAndVersionTag ?? this.showEnvAndVersionTag,
      envAndVersionTagColor: envAndVersionTagColor ?? this.envAndVersionTagColor,
    );
  }
}