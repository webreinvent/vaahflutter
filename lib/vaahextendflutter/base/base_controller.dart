import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../app_theme.dart';
import '../env.dart';
import '../services/api.dart';
import '../services/dynamic_links.dart';

class BaseController extends GetxController {
  Future<void> init({
    required Widget app,
    FirebaseOptions? firebaseOptions,
  }) async {
    await GetStorage.init();

    EnvironmentConfig.setEnvConfig();
    final EnvironmentConfig config = EnvironmentConfig.getEnvConfig();

    if (firebaseOptions != null) {
      await Firebase.initializeApp(
        options: firebaseOptions,
      );
      DynamicLinks.init();
    }

    AppTheme.init();
    Api.init();

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
