import 'package:get/get.dart';
import 'package:team/controllers/user_controller.dart';

class RouteController extends GetxController {
  bool checkRoutePermission(String path) {
    UserController userController = Get.find<UserController>();
    if (userController.user == null) {
      return false;
    }
    return userController.user!.permissions.routes
        .where((element) => element.path == path)
        .isNotEmpty;
  }
}
