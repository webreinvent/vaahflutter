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
import '../services/notification/notification.dart';

class BaseController extends GetxController {
  Future<void> init({
    required Widget app,
    FirebaseOptions? firebaseOptions,
  }) async {
    // Storage initialization to store some properties locally
    await GetStorage.init();

    // Environment initialization
    EnvironmentConfig.setEnvConfig();
    final EnvironmentConfig config = EnvironmentConfig.getEnvConfig();

    // Initialization of Firebase and Services
    if (firebaseOptions != null) {
      await Firebase.initializeApp(
        options: firebaseOptions,
      );
      DynamicLinks.init();
    }

    // Other Local Initializations (Depends on your app)
    AppTheme.init();
    Api.init();

    // Other Core Services
    await AppNotification.init();

    // Sentry Initialization (And/ Or) Running main app
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
      // Running main app
      runApp(child);
    } else {
      // Running main app when sentry config is not there
      runApp(app);
    }
  }
}
