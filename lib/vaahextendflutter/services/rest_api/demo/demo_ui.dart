import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/base_stateful.dart';
import 'demo_controller.dart';

class DemoUI extends StatefulWidget {
  const DemoUI({super.key});

  @override
  State<DemoUI> createState() => _DemoUIState();
}

class _DemoUIState extends BaseStateful<DemoUI> {
  DemoController? _controller;
  @override
  void afterFirstBuild(BuildContext context) {
    Get.put(DemoController());
    _controller = Get.find<DemoController>();
    load();
    super.afterFirstBuild(context);
  }

  Future<void> load({
    bool showLoading = true,
  }) async {
    await _controller!.getDemoURL(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container();
  }
}
