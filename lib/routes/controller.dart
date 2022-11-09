import 'package:get/get.dart';
import 'package:team/controllers/user_controller.dart';
import 'package:team/vaahextendflutter/helpers/console.dart';

class RouteController extends GetxController {

  bool checkRoutePermission(String path) {
    if(Get.isRegistered<UserController>()){
      Console.danger("UserController is not initialized!");
      return false;
    }
    UserController userController = Get.find<UserController>();
    if (userController.user == null) {
      return false;
    }
    return userController.user!.permissions.contains(path);
  }

}
