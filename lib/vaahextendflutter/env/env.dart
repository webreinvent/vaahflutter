import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';

import '../services/logging_library/logging_library.dart';
import 'datadog_config.dart';
import 'notification.dart';
import 'sentry_logging.dart';

part 'env.g.dart';

class EnvController extends GetxController {
  EnvironmentConfig _config = EnvironmentConfig.defaultConfig();

  EnvironmentConfig get config => _config;

  Future<void> initialize() async {
    try {
      const String envPath = String.fromEnvironment("ENV_PATH");
      if (envPath.isEmpty) {
        Log.warning("INVALID ENVIRONMENT PATH");
        return;
      }
      Log.success("ENVIRONMENT PATH: $envPath");
      final String jsonConfig = await rootBundle.loadString(envPath);
      if (jsonConfig.isNotEmpty) {
        final Map<String, dynamic> json = jsonDecode(jsonConfig);
        _config = EnvironmentConfig.fromJson(json);
      } else {
        throw Exception('Environment configuration not found for key: $envPath');
      }
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace: stackTrace);
      exit(0);
    }
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class EnvironmentConfig {
  const EnvironmentConfig({
    required this.appTitle,
    required this.appTitleShort,
    required this.envType,
    required this.version,
    required this.build,
    required this.apiUrl,
    required this.timeoutLimit,
    required this.enableLocalLogs,
    required this.enableCloudLogs,
    required this.enableApiLogInterceptor,
    this.errorLoggingType = ErrorLoggingType.noService,
    this.sentryConfig,
    this.datadogConfig,
    required this.pushNotificationsServiceType,
    required this.internalNotificationsServiceType,
    this.oneSignalConfig,
    this.pusherConfig,
    required this.showDebugPanel,
    required this.debugPanelColor,
  });

  final String appTitle;
  final String appTitleShort;
  final String envType;
  final String version;
  final String build;
  final String apiUrl;
  final int timeoutLimit;
  final bool enableLocalLogs;
  final bool enableCloudLogs;
  final bool enableApiLogInterceptor;
  final ErrorLoggingType errorLoggingType;
  final SentryConfig? sentryConfig;
  final DatadogConfig? datadogConfig;
  final PushNotificationsServiceType pushNotificationsServiceType;
  final InternalNotificationsServiceType internalNotificationsServiceType;
  final OneSignalConfig? oneSignalConfig;
  final PusherConfig? pusherConfig;
  final bool showDebugPanel;
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  final Color debugPanelColor;

  static Color _colorFromJson(int color) {
    return Color(color);
  }

  static int _colorToJson(Color color) {
    return color.value;
  }

  factory EnvironmentConfig.fromJson(Map<String, dynamic> json) =>
      _$EnvironmentConfigFromJson(json);

  Map<String, dynamic> toJson() => _$EnvironmentConfigToJson(this);

  static EnvironmentConfig get getConfig {
    final bool isRegistered = Get.isRegistered<EnvController>();
    if (isRegistered) {
      EnvController envController = Get.find<EnvController>();
      return envController.config;
    } else {
      return EnvironmentConfig.defaultConfig();
    }
  }

  factory EnvironmentConfig.defaultConfig() {
    return EnvironmentConfig(
      appTitle: 'VaahFlutter',
      appTitleShort: 'VaahFlutter',
      envType: 'default',
      version: '1.0.0',
      build: '1',
      apiUrl: '',
      timeoutLimit: 20, // 20 seconds
      enableLocalLogs: true,
      errorLoggingType: ErrorLoggingType.noService,
      enableCloudLogs: false,
      sentryConfig: null,
      datadogConfig: null,
      oneSignalConfig: null,
      pusherConfig: null,
      enableApiLogInterceptor: false,
      pushNotificationsServiceType: PushNotificationsServiceType.none,
      internalNotificationsServiceType: InternalNotificationsServiceType.none,
      showDebugPanel: true,
      debugPanelColor: Colors.black.withOpacity(0.8),
    );
  }
}

extension ErrorLoggingTypeService on EnvironmentConfig {
  ErrorLoggingType errorLoggingTypeService({
    required bool isFirebaseEnabled,
  }) {
    ErrorLoggingType? errorLogging;

    if (errorLoggingType.isSentry && null != sentryConfig && sentryConfig!.dsn.isNotEmpty) {
      errorLogging = ErrorLoggingType.sentry;
    } else if (errorLoggingType.isDatadog &&
        null != datadogConfig &&
        (datadogConfig?.clientToken ?? '').isNotEmpty &&
        (datadogConfig?.applicationId ?? '').isNotEmpty) {
      errorLogging = ErrorLoggingType.datadog;
    } else if (errorLoggingType.isFirebase && isFirebaseEnabled) {
      errorLogging = ErrorLoggingType.firebase;
    }

    return errorLogging ?? ErrorLoggingType.noService;
  }
}

enum ErrorLoggingType {
  noService,
  sentry,
  datadog,
  firebase;

  bool get isSentry => this == ErrorLoggingType.sentry;

  bool get isDatadog => this == ErrorLoggingType.datadog;

  bool get isFirebase => this == ErrorLoggingType.firebase;

  bool get isNoService => this == ErrorLoggingType.noService;
}
