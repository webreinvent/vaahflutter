import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../controllers/root_assets_controller.dart';
import '../app_theme.dart';
import '../env.dart';
import '../services/api.dart';

class BaseController extends GetxController {
  Future<void> init() async {
    await GetStorage.init();
    EnvironmentConfig.setEnvConfig();
    AppTheme.init();
    Api.init();
    Get.put(RootAssetsController());
  }
}
