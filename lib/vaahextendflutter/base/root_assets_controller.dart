import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/user.dart';
import '../services/http_overrides.dart';

const String _userKey = 'user';
const String _proxyKey = 'proxy';

class RootAssetsController extends GetxController {
  RootAssetsController() {
    _proxy = _storage.read(_proxyKey);
    HttpOverridesSetup.setProxyService(_proxy);
    if (_storage.hasData(_userKey)) {
      _user = User.fromJson(
        jsonDecode(
          _storage.read(_userKey),
        ),
      );
    }
  }

  final _storage = GetStorage();

  User? _user;
  User? get user => _user;
  final StreamController<User?> _userStreamController = StreamController<User?>.broadcast();
  Stream<User?> get userStream => _userStreamController.stream;

  void setUser(User? updatedUser) async {
    await _storage.write(_userKey, jsonEncode(user?.toJson()));
    _user = updatedUser;
    _userStreamController.add(user);
    update();
  }

  String? _proxy;
  String? get proxy => _proxy;
  set proxy(String? updatedProxy) {
    _proxy = (updatedProxy?.isNotEmpty ?? false) ? updatedProxy : null;
    _storage.write(_proxyKey, _proxy);
    HttpOverridesSetup.setProxyService(_proxy);
    update();
  }

  // TODO: Need to use api token in Api.ajax
}
