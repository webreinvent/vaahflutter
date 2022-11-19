import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RootAssetsController extends GetxController {

  RootAssetsController() {
    if(storage.read('apiToken') != null){
      // get user by token User.byToken(); USE WEBHOOKS and SOCKETS
    }
  }

  final storage = GetStorage();

  Map? _user;
  Map? get user => _user;
  set user(Map? user) {
    _user = user;
    update();
  }

  String? _apiToken;
  String? get apiToken => _apiToken;
  set apiToken(String? apiToken) {
    storage.write('apiToken', apiToken);
    _apiToken = apiToken;
    update();
  }

  // TODO: Need to use api token in Api.ajax
}
