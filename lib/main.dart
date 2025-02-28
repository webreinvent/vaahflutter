import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
<<<<<<< Updated upstream

import 'app_config.dart';
import 'vaahextendflutter/base/base_controller.dart';

Future<void> main() async {
=======
import 'package:vaahflutter/views/pages/home.dart';
import 'app_config.dart';
import 'vaahextendflutter/base/base_controller.dart';

void main() async {
  log("main called");
  app();
}

void app() async {
>>>>>>> Stashed changes
  WidgetsFlutterBinding.ensureInitialized();
  BaseController baseController = Get.put(BaseController());
  await baseController.init(
    app: const AppConfig(),
    errorApp: const ErrorAppConfig(),
  ); // Pass main app as argument in init method
}

void restartApp(BuildContext context) async {
  const MethodChannel _channel = MethodChannel('restart');

  await _channel.invokeMethod('restartApp', []) == "ok";
  main();
}
