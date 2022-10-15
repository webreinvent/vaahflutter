import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../base/base_stateful.dart';
import '../../../log/console.dart';
import '../api_error.dart';
import 'demo_controller.dart';
import '../models/api_error_type.dart';

class DemoUI extends StatefulWidget {
  const DemoUI({super.key});

  @override
  State<DemoUI> createState() => _DemoUIState();
}

class _DemoUIState extends BaseStateful<DemoUI> with ApiError {
  @override
  Future<int> onApiError(dynamic error) async {
    final ApiErrorType errorType = parseApiErrorType(error);
    if (errorType.message.isNotEmpty) {
      Console.danger('>>>>> code: ${errorType.code}');
      Console.danger('>>>>> message: ${errorType.message}');

      await _showMyDialog();
    }
    if (errorType.code == ApiErrorCode.unauthorized) {
      // TODO: Logout
      return 1;
    }
    return 0;
  }

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
    await apiCallSafety(
      () => _controller!.getDemoURL(),
      onStart: () async {
        if (showLoading) {
          // AppLoadingProvider.show(context);
        }
      },
      onCompleted: (bool res, void _) async {
        if (showLoading) {
          // AppLoadingProvider.hide(context);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<void> _showMyDialog() async {
    Console.danger('>>>>> dialogue');

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
