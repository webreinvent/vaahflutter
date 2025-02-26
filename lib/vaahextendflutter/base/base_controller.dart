import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../app_theme.dart';
import '../env/env.dart';
import '../services/api.dart';
import '../services/notification/internal/notification.dart';
import '../services/notification/push/notification.dart';
import 'root_assets_controller.dart';

class BaseController extends GetxController {
  Future<void> init({
    required Widget app,
    required Widget errorApp,
    FirebaseOptions? firebaseOptions,
  }) async {
    try {
      await GetStorage.init();

      final envController = Get.put(EnvController());
      await envController.initialize();
      final EnvironmentConfig config = EnvironmentConfig.getConfig;

      if (firebaseOptions != null) {
        await Firebase.initializeApp(
          options: firebaseOptions,
        );
      }

      AppTheme.init();
      Api.init();
      Get.put(RootAssetsController());

       // Temporary commented for testing purposes
      /* await PushNotifications.init();
      // await InternalNotifications.init();
      hNotifications.askPermission(); */

      if (config.sentryConfig?.dsn.isNotEmpty ?? false) {
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
          child = SentryUserInteractionWidget(child: child);
        }
        if (config.sentryConfig!.enableAssetsInstrumentation) {
          child = DefaultAssetBundle(
            bundle: SentryAssetBundle(enableStructuredDataTracing: true),
            child: child,
          );
        }

        runApp(child);
      } else {
        runApp(app);
      }
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
      runApp(errorApp);
    }
  }
}
