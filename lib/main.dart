import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import './app_config.dart';
import './vaahextendflutter/base/base_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BaseController baseController = Get.put(BaseController());
  await baseController.init();
  runApp(
    DefaultAssetBundle(
      bundle: SentryAssetBundle(enableStructuredDataTracing: true),
      child: const AppConfig(),
    ),
  );
}
