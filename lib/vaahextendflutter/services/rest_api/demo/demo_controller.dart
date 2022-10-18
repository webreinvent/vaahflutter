import 'package:get/get.dart' as getx;
import 'package:team/vaahextendflutter/log/console.dart';

import '../api.dart';

class DemoController extends getx.GetxController {
  // Call API
  Api api = Api();

  Future<void> getDemoURL() async {
    await api.ajax(
      url: '/error',
      callback: getDemoURLAfter,
      query: {'code': 401},
      showAlert: false,
      alertType: 'dialog',
    );
  }

  Future<void> getDemoURLAfter(dynamic data, dynamic resp) async {
    if (data != null) {
      Console.info(data.toString());
    }
  }
}
