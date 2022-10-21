import 'dart:async';

import 'package:get/get.dart' as getx;

import '../../../vaahextendflutter/helpers/console.dart';
import '../../../vaahextendflutter/services/api.dart';

class DemoController extends getx.GetxController {
  Future<void> getDemoURL() async {
    await Api.ajax(
      url: '/api/data/',
      callback: getDemoURLAfter,
      // alertType: 'dialog'
    );
  }

  Future<void> getDemoURLAfter(dynamic data, dynamic resp) async {
    Console.info('>>> callback <<< data: $data');
  }
}
