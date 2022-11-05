import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team/app_config.dart';
import 'package:team/controllers/base_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BaseController baseController = Get.put(BaseController());
  await baseController.init();
  runApp(const AppConfig());
}