import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;

import '../../../log/console.dart';
import '../models/api_response.dart';
import 'demo_api.dart';

class DemoController extends getx.GetxController {
  Future<void> getDemoURL() async {
    // Call API
    DemoApi api = DemoApi();
    final Response<dynamic> result =
        await api.getError().timeout(const Duration(seconds: 180));
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
