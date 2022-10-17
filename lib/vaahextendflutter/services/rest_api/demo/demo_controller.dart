import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' as getx;

import '../../../log/console.dart';
import '../api.dart';
import '../models/api_response_type.dart';

class DemoController extends getx.GetxController {
  Future<void> getDemoURL(BuildContext context) async {
    // Call API
    Api api = Api();
    final ApiResponseType? result = await api.ajax(
      url: '/error',
      queryParameters: {
        'code': 400,
      },
      // skipOnError: false,
      // showSuccessDialogue: true,
      customTimeoutLimit: 0,
    );
    if (result != null) {
      Console.log(result.toString());
    }
  }
}
