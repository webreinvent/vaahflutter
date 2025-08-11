import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../app_theme.dart';
import '../env/env.dart';
import '../services/api.dart';
import '../services/http_overrides.dart';
import '../services/logging_library/logging_library.dart';
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
      HttpOverridesSetup.setupProxyOverrides();

      // Storage initialization to store some properties locally
      await GetStorage.init();

      final envController = Get.put(EnvController());
      await envController.initialize();
      final EnvironmentConfig config = EnvironmentConfig.getConfig;

      bool isFirebaseConfigured = firebaseOptions != null;
      if (isFirebaseConfigured) {
        await Firebase.initializeApp(
          options: firebaseOptions,
        );
      }

      AppTheme.init();
      Api.init();

      Get.put(RootAssetsController());

      // Other Core Services
      await PushNotifications.init();
      await InternalNotifications.init();
      PushNotifications.askPermission();

      Widget child = await Log.init(
        app: app,
        cloudLogging: config.cloudLoggingServiceType(
          isFirebaseConfigured: isFirebaseConfigured,
        ),
      );
      runApp(child);
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
      runApp(errorApp);
    }
  }
}
