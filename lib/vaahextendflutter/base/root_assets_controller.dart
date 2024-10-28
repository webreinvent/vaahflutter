import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/user.dart';

const String userKey = 'user';

class RootAssetsController extends GetxController {
  RootAssetsController() {
    if (_storage.hasData(userKey)) {
      final String rawUser = _storage.read(userKey);
      _user = User.fromJson(jsonDecode(rawUser));
    }
  }

  final _storage = GetStorage();

  User? _user;
  User? get user => _user;
  final StreamController<User?> _userStreamController = StreamController<User?>.broadcast();
  Stream<User?> get userStream => _userStreamController.stream;

  void setUser(User? updatedUser) async {
    await _storage.write(userKey, jsonEncode(user?.toJson()));
    _user = updatedUser;
    _userStreamController.add(user);
    update();
  }

  // TODO: Need to use api token in Api.ajax
}
