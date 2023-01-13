import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team/controllers/root_assets_controller.dart';
import 'package:team/vaahextendflutter/app_theme.dart';
import 'package:team/vaahextendflutter/env.dart';
import 'package:team/vaahextendflutter/services/api.dart';

class BaseController extends GetxController {
  Future<void> init() async {
    await GetStorage.init();
    EnvironmentConfig.setEnvConfig();
    AppTheme.init();
    Api.init();
    Get.put(RootAssetsController());
  }
}
