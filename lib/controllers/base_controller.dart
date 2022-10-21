import 'package:get/get.dart';

import '../env.dart';
import '../vaahextendflutter/log/console.dart';
import '../vaahextendflutter/services/rest_api/api.dart';

class BaseController extends GetxController {
  Future<void> init() async {
    String environment =
        const String.fromEnvironment('environment', defaultValue: 'default');
    final EnvController envController = Get.put(
      EnvController(
        environment,
      ),
    );
    Console.info('>>>>> ${envController.config.envType}');
    Console.info(
      '>>>>> ${envController.config.version}+${envController.config.build}',
    );
    await Api.initApi();
  }
}
