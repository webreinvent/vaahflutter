import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_config.dart';
import 'deep_link_handler.dart';
import 'vaahextendflutter/base/base_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BaseController baseController = Get.put(BaseController());
  await baseController.init(
    app: const AppConfig(),
    errorApp: const ErrorAppConfig(),
  ); // Pass main app as argument in init method

  // The app is running now (router exists); react to deep links — both the
  // cold-start link the service buffered and any that arrive live.
  DeepLinkNavigator.listen();
}
