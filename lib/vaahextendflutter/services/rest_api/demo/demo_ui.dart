import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/base_stateful.dart';
import '../../../log/console.dart';
import '../api_error.dart';
import '../models/api_error_type.dart';
import 'demo_controller.dart';

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
      await _showErrorDialog(
        title: 'Error',
        content: errorType.message,
      );
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
      skipOnError: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container();
  }

  Future<void> _showErrorDialog({
    required String title,
    required String content,
    List<Widget>? actions,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            if (actions == null || actions.isNotEmpty)
              TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            else
              ...actions,
          ],
        );
      },
    );
  }
}
