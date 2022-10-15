import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' as getx;
import '../api.dart';

import '../../../log/console.dart';
import '../models/api_response.dart';

class DemoController extends getx.GetxController {
  Future<void> getDemoURL(BuildContext context) async {
    // Call API
    Api api = Api();
    final Response? result = await api.ajax(
      context: context,
      url: '/error?code=401',
      // skipOnError: false,
    );
    Console.info(
      result.toString(),
    );
    // final DecodedResponse response = DecodedResponse(result.data);
    // if (response.data != null) {}
  }
}

class DecodedResponse extends BaseResponse<List<String>> {
  DecodedResponse(Map<String, dynamic>? fullJson) : super(fullJson);

  @override
  List<String> jsonToData(dynamic dataJson) {
    final List<dynamic>? dataList = dataJson as List<dynamic>?;
    return dataList != null
        ? List<String>.from(
            dataList.map<String>(
              (dynamic x) => x.toString(),
            ),
          )
        : <String>[];
  }
}
