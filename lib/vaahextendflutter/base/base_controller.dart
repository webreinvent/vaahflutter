import 'dart:async';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../app_theme.dart';
import '../env/env.dart';
import '../services/api.dart';

import 'root_assets_controller.dart';

class BaseController extends GetxController {
  Future<void> init({
    required GlobalKey<NavigatorState> restartKey,
    required Widget app,
    required Widget errorApp,
    FirebaseOptions? firebaseOptions,
  }) async {
    try {
      // Storage initialization to store some properties locally
      await GetStorage.init();
      log("baseController reinitialised");

      // Environment initialization
      final envController = Get.put(EnvController());
      await envController.initialize();
      final EnvironmentConfig config = EnvironmentConfig.getConfig;

      // Initialization of Firebase and Services
      if (firebaseOptions != null) {
        await Firebase.initializeApp(
          options: firebaseOptions,
        );
      }

      // Other Local Initializations (Depends on your app)
      AppTheme.init();
      Api.init();

      // RootAssets
      Get.put(RootAssetsController());

      // Temporary commented for testing purposes
      /* await PushNotifications.init();
      // await InternalNotifications.init();
      hNotifications.askPermission(); */

      // Sentry Initialization (And/ Or) Running main app
      if (null != config.sentryConfig && config.sentryConfig!.dsn.isNotEmpty) {
        await SentryFlutter.init(
          (options) => options
            ..dsn = config.sentryConfig!.dsn
            ..autoAppStart = config.sentryConfig!.autoAppStart
            ..tracesSampleRate = config.sentryConfig!.tracesSampleRate
            ..enableAutoPerformanceTracing = config.sentryConfig!.enableAutoPerformanceTracing
            ..enableUserInteractionTracing = config.sentryConfig!.enableUserInteractionTracing
            ..environment = config.envType,
        );
        Widget child = app;
        if (config.sentryConfig!.enableUserInteractionTracing) {
          log("route changes");

          child = SentryUserInteractionWidget(child: child);
        }
        if (config.sentryConfig!.enableAssetsInstrumentation) {
          child = DefaultAssetBundle(
            bundle: SentryAssetBundle(enableStructuredDataTracing: true),
            child: child,
          );
        }
        log("runapp child");

        runApp(child);
      } else {
        log("runapp app");

        runApp(app);
      }
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
      runApp(errorApp);
    }
  }
}
