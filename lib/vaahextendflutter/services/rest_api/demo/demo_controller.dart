import 'package:get/get.dart' as getx;

import '../../../log/console.dart';
import '../api.dart';
import '../models/api_response_type.dart';

class DemoController extends getx.GetxController {
  // Call API
  Api api = Api();

  Future<void> getDemoURL() async {
    await api.ajax(
      url: '/api/users',
      requestType: RequestType.post,
    );
  }

  Future<void> getDemoURLAfter(suceess, resp) async {}
}
