import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../env.dart';
import '../../../vaahextendflutter/base/base_stateful.dart';
import 'demo_controller.dart';

class DemoUI extends StatefulWidget {
  const DemoUI({super.key});

  @override
  State<DemoUI> createState() => _DemoUIState();
}

class _DemoUIState extends BaseStateful<DemoUI> {
  bool _isLoading = false;
  DemoController? _controller;

  @override
  void afterFirstBuild(BuildContext context) async {
    super.afterFirstBuild(context);
    Get.put(DemoController());
    _controller = Get.find<DemoController>();
    await load();
  }

  Future<void> load({
    bool showLoading = true,
  }) async {
    setState(() {
      _isLoading = true;
    });
    await _controller!.getDemoURL();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      height: 40,
      width: 150,
      child: ElevatedButton(
        onPressed: () => load(),
        child: _isLoading
            ? const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: whiteColor,
                  ),
                ),
              )
            : const Text('Request'),
      ),
    );
  }
}
