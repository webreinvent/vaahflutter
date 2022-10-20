import 'dart:async';

import 'package:get/get.dart' as getx;
import '../../../log/console.dart';

import '../api.dart';

class DemoController extends getx.GetxController {
  Future<void> getDemoURL() async {
    await Api.ajax(
      url: '/search',
      query: {'code': 401},
      callback: getDemoURLAfter,
    );
  }

  Future<void> getDemoURLAfter(dynamic data, dynamic resp) async {
    Console.info('>>> callback <<< data: $data');
  }
}
