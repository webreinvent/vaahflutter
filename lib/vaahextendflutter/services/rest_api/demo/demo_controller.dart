import 'dart:async';

import 'package:get/get.dart' as getx;
import 'package:team/vaahextendflutter/log/console.dart';

import '../api.dart';

class DemoController extends getx.GetxController {
  // Call API
  Api api = Api();

  Future<void> getDemoURL() async {
    await api.ajax(
      url: '/search',
      callback: getDemoURLAfter,
    );
  }

  Future<void> getDemoURLAfter(dynamic data, dynamic resp) async {
    Console.info('>>> callback <<< data: $data');
  }
}
