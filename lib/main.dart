import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_config.dart';
import 'vaahextendflutter/base/base_controller.dart';

void main() async {
  log("main called");
  app();
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void app() async {
  WidgetsFlutterBinding.ensureInitialized();
  BaseController baseController = Get.put(BaseController());
  await baseController.init(
    restartKey: navigatorKey,
    app: const AppConfig(),
    errorApp: const ErrorAppConfig(),
  ); // Pass main app as argument in init method
}

void restartApp(BuildContext context) async {
  // Get.delete<BaseController>();
  app();
  // const MethodChannel channel = MethodChannel('restart');

  // await channel.invokeMethod('restartApp', []) == "ok";
  // main();
}
