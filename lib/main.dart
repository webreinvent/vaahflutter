import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './app_config.dart';
import './vaahextendflutter/base/base_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BaseController baseController = Get.put(BaseController());
  await baseController.init(
    app: const AppConfig(),
    errorApp: const ErrorAppConfig(),
  ); // Pass main app as argument in init method
}
