import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../app_theme.dart';
import '../env/env.dart';
import '../services/api.dart';
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
      // Storage initialization to store some properties locally
      await GetStorage.init();

      // Environment initialization
      final envController = Get.put(EnvController());
      await envController.initialize();
      final EnvironmentConfig config = EnvironmentConfig.getConfig;

      // Initialization of Firebase and Services
      bool isFirebaseEnabled = firebaseOptions != null;
      if (isFirebaseEnabled) {
        await Firebase.initializeApp(
          options: firebaseOptions,
        );
      }

      // Other Local Initializations (Depends on your app)
      AppTheme.init();
      Api.init();

      // RootAssets
      Get.put(RootAssetsController());

      // Other Core Services
      await PushNotifications.init();
      await InternalNotifications.init();
      PushNotifications.askPermission();

      // Error Monitoring & Logging
      Widget child = await Log.init(
        app: app,
        errorLogging: config.errorLoggingTypeService(
          isFirebaseEnabled: isFirebaseEnabled,
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
