import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';

import '../app_theme.dart';
import '../services/logging_library/logging_library.dart';
import '../widgets/debug/section_data.dart';
import '../widgets/debug/custom_debug_section.dart';
import '../widgets/debug/panel_content_holder.dart';
import 'logging.dart';
import 'notification.dart';

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
    this.firebaseId,
    required this.timeoutLimit,
    required this.enableLocalLogs,
    required this.enableCloudLogs,
    required this.enableApiLogInterceptor,
    this.sentryConfig,
    required this.pushNotificationsServiceType,
    required this.internalNotificationsServiceType,
    this.oneSignalConfig,
    this.pusherConfig,
    required this.showDebugPanel,
    required this.debugPanelColor,
    this.customDebugSections,
  });

  final String appTitle;
  final String appTitleShort;
  final String envType;
  final String version;
  final String build;
  final String apiUrl;
  final String? firebaseId;
  final int timeoutLimit;
  final bool enableLocalLogs;
  final bool enableCloudLogs;
  final bool enableApiLogInterceptor;
  final SentryConfig? sentryConfig;
  final PushNotificationsServiceType pushNotificationsServiceType;
  final InternalNotificationsServiceType internalNotificationsServiceType;
  final OneSignalConfig? oneSignalConfig;
  final PusherConfig? pusherConfig;
  final bool showDebugPanel;
  final List<CustomDebugSection>? customDebugSections;
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
      enableCloudLogs: false,
      enableApiLogInterceptor: false,
      pushNotificationsServiceType: PushNotificationsServiceType.none,
      internalNotificationsServiceType: InternalNotificationsServiceType.none,
      showDebugPanel: true,
      debugPanelColor: Colors.black.withOpacity(0.8),
      customDebugSections: [
        CustomDebugSection(
          sectionName: 'Section Test 1',
          contentHolder: PanelDataContentHolder(content: {
            'Topic 1': SectionData(
                value: 'Test Value 1', color: AppTheme.colors['success'], tooltip: 'Tip'),
            'Topic 2': const SectionData(value: 'Test Value 2'),
          }),
        ),
        CustomDebugSection(
          sectionName: 'Section 2',
          contentHolder: const PanelDataContentHolder(content: {
            'Topic 1': SectionData(value: 'Test Value 1'),
            'Topic 2': SectionData(value: 'Test Value 2'),
          }),
        ),
      ],
    );
  }
}
