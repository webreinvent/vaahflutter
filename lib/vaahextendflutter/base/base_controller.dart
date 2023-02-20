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
    await SentryFlutter.init(
      (options) => options
        ..dsn = config.sentryDsn
        ..tracesSampleRate = config.sentryTracesSampleRate
        ..environment = config.envType,
      appRunner: () => runApp(
        DefaultAssetBundle(
          bundle: SentryAssetBundle(enableStructuredDataTracing: true),
          child: app,
        ),
      ),
    );
  }
}
