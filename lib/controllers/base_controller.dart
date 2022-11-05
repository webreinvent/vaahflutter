import 'package:get/get.dart';
import 'package:team/app_theme.dart';
import 'package:team/controllers/user_controller.dart';
import 'package:team/env.dart';
import 'package:team/routes/controller.dart';
import 'package:team/vaahextendflutter/helpers/console.dart';
import 'package:team/vaahextendflutter/services/api.dart';

class BaseController extends GetxController {
  Future<void> init() async {
    String environment = const String.fromEnvironment('environment', defaultValue: 'default');
    final EnvController envController = Get.put(
      EnvController(
        environment,
      ),
    );
    Console.info('Env Type: ${envController.config.envType}');
    Console.info('Version: ${envController.config.version}+${envController.config.build}');
    Get.put(RouteController());
    Get.put(UserController());
    await Api.initApi();
    AppTheme.init();
  }
}
