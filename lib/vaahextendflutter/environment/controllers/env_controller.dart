import 'package:get/get.dart';

import '../../../env.dart';
import '../env_helpers.dart';

class EnvController extends GetxController {
  EnvironmentConfig _config = devEnvConfig;
  EnvironmentConfig get config => _config;

  EnvController(String environment) {
    switch (environment) {
      case 'prod':
        _config = prodEnvConfig;
        break;
      case 'stag':
        _config = stagEnvConfig;
        break;
      default:
        _config = devEnvConfig;
        break;
    }
    update();
  }
}
