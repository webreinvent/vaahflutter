import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../controllers/root_assets_controller.dart';
import '../app_theme.dart';
import '../env.dart';
import '../services/api.dart';

class BaseController extends GetxController {
  Future<void> init(Widget app) async {
    await GetStorage.init();
    EnvironmentConfig.setEnvConfig();
    AppTheme.init();
    Api.init();
    Get.put(RootAssetsController());

    final EnvironmentConfig config = EnvironmentConfig.getEnvConfig();

    if (null != config.sentryConfig && config.sentryConfig!.dsn.isNotEmpty) {
      await SentryFlutter.init(
        (options) => options
          ..dsn = config.sentryConfig!.dsn
          ..autoAppStart = config.sentryConfig!.autoAppStart
          ..tracesSampleRate = config.sentryConfig!.tracesSampleRate
          ..enableAutoPerformanceTracking = config.sentryConfig!.enableAutoPerformanceTracking
          ..enableUserInteractionTracing = config.sentryConfig!.enableUserInteractionTracing
          ..environment = config.envType,
      );
      Widget child = app;
      if (config.sentryConfig!.enableUserInteractionTracing) {
        child = SentryUserInteractionWidget(
          child: child,
        );
      }
      if (config.sentryConfig!.enableAssetsInstrumentation) {
        child = DefaultAssetBundle(
          bundle: SentryAssetBundle(
            enableStructuredDataTracing: true,
          ),
          child: child,
        );
      }
      runApp(child);
    } else {
      runApp(app);
    }
  }
}
