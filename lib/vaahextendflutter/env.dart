import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './app_theme.dart';
import './services/logging_library/logging_library.dart';

// After changing any const you will need to restart the app (Hot-reload won't work).

// Version and build
const String version = '1.0.0'; // version format 1.0.0 (major.minor.patch)
const String build = '2022030201'; // build no format 'YYYYMMDDNUMBER'

final EnvironmentConfig defaultConfig = EnvironmentConfig(
  appTitle: 'VaahFlutter',
  appTitleShort: 'VaahFlutter',
  envType: 'default',
  version: version,
  build: build,
  backendUrl: '',
  apiUrl: '',
  timeoutLimit: 20 * 1000, // 20 seconds
  firebaseId: '',
  enableLocalLogs: true,
  enableCloudLogs: true,
  enableApiLogInterceptor: true,
  showDebugPanel: true,
  debugPanelColor: AppTheme.colors['black']!.withOpacity(0.7),
);

// To add new configuration add new key, value pair in envConfigs
Map<String, EnvironmentConfig> envConfigs = {
  // Do not remove default config
  'default': defaultConfig.copyWith(
    envType: 'default',
  ),
  'develop': defaultConfig.copyWith(
    envType: 'develop',
    enableCloudLogs: false,
  ),
  'stage': defaultConfig.copyWith(
    envType: 'stage',
    enableCloudLogs: true,
  ),
  'production': defaultConfig.copyWith(
    envType: 'production',
    enableLocalLogs: false,
    enableApiLogInterceptor: false,
    showDebugPanel: false,
  ),
};

class EnvController extends GetxController {
  late EnvironmentConfig _config;
  EnvironmentConfig get config => _config;

  EnvController(String environment) {
    try {
      _config = getSpecificConfig(environment);
      update();
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace: stackTrace);
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
  final bool enableLocalLogs;
  final bool enableCloudLogs;
  final SentryConfig? sentryConfig;
  final bool enableApiLogInterceptor;
  final bool showDebugPanel;
  final Color debugPanelColor;

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
    required this.enableLocalLogs,
    required this.enableCloudLogs,
    this.sentryConfig,
    required this.enableApiLogInterceptor,
    required this.showDebugPanel,
    required this.debugPanelColor,
  });

  static EnvironmentConfig getEnvConfig() {
    final bool envControllerExists = Get.isRegistered<EnvController>();
    if (!envControllerExists) {
      setEnvConfig();
    }
    EnvController envController = Get.find<EnvController>();
    return envController.config;
  }

  static void setEnvConfig() {
    String environment = const String.fromEnvironment('environment', defaultValue: 'default');
    final EnvController envController = Get.put(EnvController(environment));
    Log.info(
      'Env Type: ${envController.config.envType}',
      disableCloudLogging: true,
    );
    Log.info(
      'Version: ${envController.config.version}+${envController.config.build}',
      disableCloudLogging: true,
    );
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
    bool? enableLocalLogs,
    bool? enableCloudLogs,
    SentryConfig? sentryConfig,
    bool? enableApiLogInterceptor,
    bool? showDebugPanel,
    Color? debugPanelColor,
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
      enableLocalLogs: enableLocalLogs ?? this.enableLocalLogs,
      enableCloudLogs: enableCloudLogs ?? this.enableCloudLogs,
      sentryConfig: sentryConfig ?? this.sentryConfig,
      enableApiLogInterceptor: enableApiLogInterceptor ?? this.enableApiLogInterceptor,
      showDebugPanel: showDebugPanel ?? this.showDebugPanel,
      debugPanelColor: debugPanelColor ?? this.debugPanelColor,
    );
  }
}

class SentryConfig {
  final String dsn;
  final bool autoAppStart; // To record cold and warm start up time
  final double tracesSampleRate;
  final bool enableAutoPerformanceTracking;
  final bool enableUserInteractionTracing;
  final bool enableAssetsInstrumentation;

  const SentryConfig({
    required this.dsn,
    this.autoAppStart = true,
    this.tracesSampleRate = 0.6,
    this.enableAutoPerformanceTracking = true,
    this.enableUserInteractionTracing = true,
    this.enableAssetsInstrumentation = true,
  });

  SentryConfig copyWith({
    String? dsn,
    bool? autoAppStart,
    double? tracesSampleRate,
    bool? enableAutoPerformanceTracking,
    bool? enableUserInteractionTracing,
    bool? enableAssetsInstrumentation,
  }) {
    return SentryConfig(
      dsn: dsn ?? this.dsn,
      autoAppStart: autoAppStart ?? this.autoAppStart,
      tracesSampleRate: tracesSampleRate ?? this.tracesSampleRate,
      enableAutoPerformanceTracking:
          enableAutoPerformanceTracking ?? this.enableAutoPerformanceTracking,
      enableUserInteractionTracing:
          enableUserInteractionTracing ?? this.enableUserInteractionTracing,
      enableAssetsInstrumentation: enableAssetsInstrumentation ?? this.enableAssetsInstrumentation,
    );
  }
}
