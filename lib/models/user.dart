import 'package:get/get.dart';
import 'package:team/controllers/root_assets_controller.dart';
import 'package:team/vaahextendflutter/services/api.dart';

class User {
  static final RootAssetsController rootAssetsController = Get.find<RootAssetsController>();
  static const String apiEndPoint = 'user';

  // final String firstName;
  // final String? lastName;
  // final List<String> permissions;
  //
  // const User({
  //   required this.firstName,
  //   this.lastName,
  //   required this.permissions,
  // });

  static Future<void> signin(String username, String password) async {
    rootAssetsController.user = {
      "name": "name",
      "permissions": ["can-access-details", 'can-access-more-details']
    };
    // await Api.ajax(
    //   url: apiEndPoint, // TODO: change end point
    //   method: 'post',
    //   params: {"username": username, "password": password},
    // );
    return;
  }

  static Future<void> forgotPassword(String username) async {
    await Api.ajax(
      url: '$apiEndPoint/forgot-password', // TODO: change end point
      method: 'post',
      params: {"username": username},
    );
    return;
  }

  static Future<void> signout(String username) async {
    await Api.ajax(
      url: '$apiEndPoint/signout', // TODO: change end point
      method: 'post',
      params: {"username": username},
    );
    rootAssetsController.user = null;
    return;
  }

  static bool hasPermission(String value) {
    if (rootAssetsController.user?['permissions'] == null) {
      return false;
    }
    return (rootAssetsController.user?['permissions'] as List<String>).contains(value);
  }

  static Future<Map?> createItem(Map<String, dynamic> item) async {
    return await Api.ajax(
      url: apiEndPoint, // TODO: change end point
      method: 'post',
      params: {'data': item},
    );
  }

  static Future<List<Map>?> getList(String orderBy, int page, int itemsPerPage) async {
    Map<String, dynamic> query = {
      "orderBy": orderBy,
      "page": page,
      "itemsPerPage": itemsPerPage,
    }; // TODO: change the query
    return await Api.ajax(
      url: apiEndPoint, // TODO: change end point
      method: 'get',
      query: query,
    );
  }

  static Future<List<Map>?> updateList(List<Map> items) async {
    return await Api.ajax(
      url: apiEndPoint, // TODO: change end point
      method: 'post',
      params: {'data': items},
    );
  }
}
