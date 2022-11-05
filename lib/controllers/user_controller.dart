import 'package:get/get.dart';
import 'package:team/models/user/permission/permission.dart';
import 'package:team/models/user/permission/route/route.dart';
import 'package:team/models/user/user.dart';
import 'package:team/vaahextendflutter/helpers/console.dart';
import 'package:team/vaahextendflutter/helpers/helpers.dart';
import 'package:team/view/pages/details.dart';
import 'package:team/view/pages/more_details.dart';

class UserController extends GetxController {
  User? _user;

  User? get user => _user;

  set user(User? user) {
    _user = user;
    update();
  }

  UserController() {
    // Check if user exists locally?
    Console.danger('Check if user exists locally?');
  }

  Future<void> login(String username, String password) async {
    // Use user api services
    user = const User(
      firstName: "test",
      permissions: Permission(
        modifyLog: [],
        routes: [
          RouteModel(path: DetailsPage.routeName),
          RouteModel(path: MoreDetailsPage.routeName),
        ],
      ),
    );
    Helpers.showSuccessToast(content: 'Successful');
  }

  Future<void> forgotPassword(String username) async {}

  Future<void> logout() async {
    user = null;
    Helpers.showSuccessToast(content: 'Successful');
  }
}
