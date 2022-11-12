import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team/app_theme.dart';
import 'package:team/controllers/root_assets_controller.dart';
import 'package:team/env.dart';
import 'package:team/vaahextendflutter/helpers/console.dart';
import 'package:team/vaahextendflutter/services/api.dart';

class BaseController extends GetxController {
  Future<void> init() async {
    await GetStorage.init();
    initEnvController();
    AppTheme.init();
    await Api.init();
    Get.put(RootAssetsController());
  }
}

void initEnvController() {
  String environment = const String.fromEnvironment('environment', defaultValue: 'default');
  final EnvController envController = Get.put(EnvController(environment));
  Console.info('Env Type: ${envController.config.envType}');
  Console.info('Version: ${envController.config.version}+${envController.config.build}');
}
