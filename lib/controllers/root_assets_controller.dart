import 'package:get/get.dart';

class RootAssetsController extends GetxController {
  Map? _user;

  Map? get user => _user;

  set user(Map? user) {
    _user = user;
    update();
  }
}
