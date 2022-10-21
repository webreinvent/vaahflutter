import 'package:get/get.dart';

import '../env.dart';
import '../vaahextendflutter/helpers/console_log_helper.dart';
import '../vaahextendflutter/services/api.dart';

class BaseController extends GetxController {
  Future<void> init() async {
    String environment =
        const String.fromEnvironment('environment', defaultValue: 'default');
    final EnvController envController = Get.put(
      EnvController(
        environment,
      ),
    );
    Console.info('Env Type: ${envController.config.envType}');
    Console.info(
      'Version: ${envController.config.version}+${envController.config.build}',
    );
    await Api.initApi();
  }
}
