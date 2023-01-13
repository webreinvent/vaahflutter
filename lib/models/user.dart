import 'package:get/get.dart';
import 'package:team/controllers/root_assets_controller.dart';
import 'package:team/vaahextendflutter/services/api.dart';

class User {
  static const String apiEndPoint = '/users'; // TODO: change end point
  static final RootAssetsController rootAssetsController = Get.find<RootAssetsController>();

  static bool hasPermission(String value) {
    if (rootAssetsController.user == null || rootAssetsController.user?['permissions'] == null) {
      return false;
    }
    return (rootAssetsController.user?['permissions'] as List<String>).contains(value);
  }

  static Future<void> signin(String identifier, String password) async {
    Map<String, dynamic> user = await Api.ajax(
      url: apiEndPoint,
      method: 'post',
      params: {"identifier": identifier, "password": password},
    );
    rootAssetsController.user = user;
    rootAssetsController.apiToken = user['token'];
    return;
  }

  static Future<void> forgotPassword(String identifier) async {
    await Api.ajax(
      url: apiEndPoint,
      method: 'post',
      params: {"identifier": identifier},
    );
    // TODO: On the same page of the call Show enter otp, reset pass
    return;
  }

  static Future<void> signout() async {
    rootAssetsController.user = null;
    return;
  }

  static Future<Map?> createItem(Map<String, dynamic> item) async {
    return await Api.ajax(
      url: apiEndPoint,
      method: 'post',
      params: item,
    );
  }

  static Future<List<Map>?> getList(Map<String, dynamic> query) async {
    return await Api.ajax(
      url: apiEndPoint,
      method: 'get',
      query: query,
    );
  }

  static Future<List<Map>?> updateList(String type, List<Map> items) async {
    return await Api.ajax(
      url: apiEndPoint,
      method: 'post',
      params: {'type': type, 'data': items},
    );
  }

  static Future<List<Map>?> deleteList(String type, List<Map> items) async {
    return await Api.ajax(
      url: apiEndPoint,
      method: 'delete',
      params: {'type': type, 'data': items},
    );
  }

  static Future<List<Map>?> listAction(String type, List<Map> items) async {
    return await Api.ajax(
      url: apiEndPoint,
      method: 'patch',
      params: {'type': type, 'data': items},
    );
  }

  static Future<Map?> getItem(String id) async {
    return await Api.ajax(
      url: apiEndPoint,
      method: 'get',
      query: {"id": id},
    );
  }

  static Future<Map?> updateItem(String id, Map item) async {
    return await Api.ajax(
      url: apiEndPoint,
      method: 'patch',
      params: {'id': id, 'item': item},
    );
  }

  static Future<Map?> deleteItem(String id) async {
    return await Api.ajax(
      url: apiEndPoint,
      method: 'delete',
      params: {"id": id},
    );
  }

  static Future<Map?> itemAction(String id, String type) async {
    return await Api.ajax(
      url: apiEndPoint,
      method: 'post',
      params: {'id': id, 'type': type},
    );
  }
}
