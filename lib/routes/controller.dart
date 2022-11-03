import 'package:get/get.dart';
import 'package:team/models/user/permission/permission.dart';
import 'package:team/models/user/permission/route/route.dart';
import 'package:team/models/user/user.dart';
import 'package:team/view/pages/something_went_wrong.dart';

class RouteController extends GetxController {
  bool checkRoutePermission(String path) {
    // check userController => isLoggedIn => currentUser.permissions.routes contain askedPath
    // e.g. dummy user
    User user = const User(
      firstName: "Name",
      permissions: Permission(
        modifyLog: [],
        routes: [
          RouteModel(path: SomethingWentWrong.routeName),
        ],
      ),
    );
    return user.permissions.routes.where((element) => element.path == path).isNotEmpty;
  }
}
