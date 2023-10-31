import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app_theme.dart';
import 'services/logging_library/logging_library.dart';
import '././helpers/assets.dart';

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
  enableLocalLogs: true,
  enableCloudLogs: true,
  enableApiLogInterceptor: true,
  pushNotificationsServiceType: PushNotificationsServiceType.none,
  internalNotificationsServiceType: InternalNotificationsServiceType.none,
  showDebugPanel: true,
  debugPanelColor: AppTheme.colors['black']!.withOpacity(0.8),
);

class EnvController extends GetxController {
  final GetStorage _storage = GetStorage();
  EnvironmentConfig _config = defaultConfig;

  EnvironmentConfig get config => _config;

  EnvController(String environment) {
    getSpecificConfig(environment);
  }

  void getSpecificConfig(String environment) async {
    try {
      await getConfigFromJson(environment);
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace: stackTrace);
      exit(0);
    }
  }

  Future<void> getConfigFromJson(String key) async {
    final String envJson = await rootBundle.loadString(DataAssets.envJson(key));
    if (envJson.isNotEmpty) {
      final Map<String, dynamic> json = jsonDecode(envJson);
      final result = EnvironmentConfig.fromJson(json);
      _config = defaultConfig.copyWith(
          appTitle: result.appTitle,
          appTitleShort: result.appTitleShort,
          envType: result.envType,
          version: result.version,
          build: result.build,
          backendUrl: result.backendUrl,
          apiUrl: result.apiUrl,
          timeoutLimit: result.timeoutLimit,
          enableLocalLogs: result.enableLocalLogs,
          enableCloudLogs: result.enableCloudLogs,
          enableApiLogInterceptor: result.enableApiLogInterceptor,
          showDebugPanel: result.showDebugPanel,
          openCount: _storage.read('open_count'));
    } else {
      throw Exception('Environment configuration not found for key: $key');
    }
  }

  Future<void> increaseOpenCount() async {
    await _storage.write('open_count', _config.openCount + 1);
    _config = _config.copyWith(openCount: _config.openCount + 1);
  }
}

class EnvironmentConfig {
  final String appTitle;
  final String appTitleShort;
  final String envType;
  final String version;
  final String build;
  final int openCount;
  final String backendUrl;
  final String apiUrl;
  final String? firebaseId;
  final int timeoutLimit;
  final bool enableLocalLogs;
  final bool enableCloudLogs;
  final SentryConfig? sentryConfig;
  final bool enableApiLogInterceptor;
  final PushNotificationsServiceType pushNotificationsServiceType;
  final InternalNotificationsServiceType internalNotificationsServiceType;
  final OneSignalConfig? oneSignalConfig;
  final PusherConfig? pusherConfig;
  final bool showDebugPanel;
  final Color debugPanelColor;

  const EnvironmentConfig({
    required this.appTitle,
    required this.appTitleShort,
    required this.envType,
    required this.version,
    required this.build,
    this.openCount = 0,
    required this.backendUrl,
    required this.apiUrl,
    this.firebaseId,
    required this.timeoutLimit,
    required this.enableLocalLogs,
    required this.enableCloudLogs,
    this.sentryConfig,
    required this.enableApiLogInterceptor,
    required this.pushNotificationsServiceType,
    required this.internalNotificationsServiceType,
    this.oneSignalConfig,
    this.pusherConfig,
    required this.showDebugPanel,
    required this.debugPanelColor,
  });

  static EnvironmentConfig getEnvConfig() {
    final bool envControllerExists = Get.isRegistered<EnvController>();
    if (!envControllerExists) {
      return setEnvConfig();
    }
    EnvController envController = Get.find<EnvController>();
    return envController.config;
  }

  static EnvironmentConfig setEnvConfig() {
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
    return envController.config;
  }

  factory EnvironmentConfig.fromJson(Map<String, dynamic> json) {
    return EnvironmentConfig(
      appTitle: json["app_title"],
      appTitleShort: json["app_title_short"],
      envType: json["env_type"],
      version: json["version"],
      build: json["build"],
      openCount: json["open_count"],
      backendUrl: json["backend_url"],
      apiUrl: json["api_url"],
      firebaseId: json["firebase_id"],
      timeoutLimit: json["timeout_limit"],
      enableLocalLogs: json["enable_local_logs"],
      enableCloudLogs: json["enable_cloud_logs"],
      enableApiLogInterceptor: json["enable_api_log_interceptor"],
      pushNotificationsServiceType: PushNotificationsServiceType.none,
      internalNotificationsServiceType: InternalNotificationsServiceType.none,
      showDebugPanel: json["show_debug_panel"],
      debugPanelColor: AppTheme.colors['black']!.withOpacity(0.8),
    );
  }

  EnvironmentConfig copyWith({
    String? appTitle,
    String? appTitleShort,
    String? envType,
    String? version,
    String? build,
    int? openCount,
    String? backendUrl,
    String? apiUrl,
    String? firebaseId,
    int? timeoutLimit,
    bool? enableLocalLogs,
    bool? enableCloudLogs,
    SentryConfig? sentryConfig,
    bool? enableApiLogInterceptor,
    PushNotificationsServiceType? pushNotificationsServiceType,
    InternalNotificationsServiceType? internalNotificationsServiceType,
    OneSignalConfig? oneSignalConfig,
    PusherConfig? pusherConfig,
    bool? showDebugPanel,
    Color? debugPanelColor,
  }) {
    return EnvironmentConfig(
      appTitle: appTitle ?? this.appTitle,
      appTitleShort: appTitleShort ?? this.appTitleShort,
      envType: envType ?? this.envType,
      version: version ?? this.version,
      build: build ?? this.build,
      openCount: openCount ?? this.openCount,
      backendUrl: backendUrl ?? this.backendUrl,
      apiUrl: apiUrl ?? this.apiUrl,
      firebaseId: firebaseId ?? this.firebaseId,
      timeoutLimit: timeoutLimit ?? this.timeoutLimit,
      enableLocalLogs: enableLocalLogs ?? this.enableLocalLogs,
      enableCloudLogs: enableCloudLogs ?? this.enableCloudLogs,
      sentryConfig: sentryConfig ?? this.sentryConfig,
      enableApiLogInterceptor: enableApiLogInterceptor ?? this.enableApiLogInterceptor,
      pushNotificationsServiceType:
          pushNotificationsServiceType ?? this.pushNotificationsServiceType,
      internalNotificationsServiceType:
          internalNotificationsServiceType ?? this.internalNotificationsServiceType,
      oneSignalConfig: oneSignalConfig ?? this.oneSignalConfig,
      pusherConfig: pusherConfig ?? this.pusherConfig,
      showDebugPanel: showDebugPanel ?? this.showDebugPanel,
      debugPanelColor: debugPanelColor ?? this.debugPanelColor,
    );
  }

  Future<void> increaseOpenCount() async {
    final bool envControllerExists = Get.isRegistered<EnvController>();
    if (!envControllerExists) throw Exception('No EnvController Is Registered');
    await Get.find<EnvController>().increaseOpenCount();
  }
}

enum PushNotificationsServiceType { local, remote, both, none }

enum InternalNotificationsServiceType { pusher, firebase, custom, none }

class SentryConfig {
  final String dsn;
  final bool autoAppStart; // To record cold and warm start up time
  final double tracesSampleRate;
  final bool enableAutoPerformanceTracing;
  final bool enableUserInteractionTracing;
  final bool enableAssetsInstrumentation;

  const SentryConfig({
    required this.dsn,
    this.autoAppStart = true,
    this.tracesSampleRate = 0.6,
    this.enableAutoPerformanceTracing = true,
    this.enableUserInteractionTracing = true,
    this.enableAssetsInstrumentation = true,
  });

  SentryConfig copyWith({
    String? dsn,
    bool? autoAppStart,
    double? tracesSampleRate,
    bool? enableAutoPerformanceTracing,
    bool? enableUserInteractionTracing,
    bool? enableAssetsInstrumentation,
  }) {
    return SentryConfig(
      dsn: dsn ?? this.dsn,
      autoAppStart: autoAppStart ?? this.autoAppStart,
      tracesSampleRate: tracesSampleRate ?? this.tracesSampleRate,
      enableAutoPerformanceTracing:
          enableAutoPerformanceTracing ?? this.enableAutoPerformanceTracing,
      enableUserInteractionTracing:
          enableUserInteractionTracing ?? this.enableUserInteractionTracing,
      enableAssetsInstrumentation: enableAssetsInstrumentation ?? this.enableAssetsInstrumentation,
    );
  }
}

class OneSignalConfig {
  final String appId;

  const OneSignalConfig({
    required this.appId,
  });

  OneSignalConfig copyWith({
    String? appId,
  }) {
    return OneSignalConfig(
      appId: appId ?? this.appId,
    );
  }
}

class PusherConfig {
  final String apiKey;
  final String cluster;

  const PusherConfig({
    required this.apiKey,
    required this.cluster,
  });

  PusherConfig copyWith({
    String? apiKey,
    String? cluster,
  }) {
    return PusherConfig(
      apiKey: apiKey ?? this.apiKey,
      cluster: cluster ?? this.cluster,
    );
  }
}
