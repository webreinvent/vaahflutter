import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Helpers {
  
  static logout() {
    // Navigate using getx
  }


  // ignore: unused_element
  static _toast({required String content, Color color = Colors.white}) {
    Fluttertoast.showToast(
      msg: content,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: color.withOpacity(0.5),
      textColor: color,
      fontSize: 16.0,
    );
  }

  // ignore: unused_element
  static _dialog({
    required String title,
    List<String>? content,
    String? hint,
    List<Widget>? actions,
  }) {
    return Get.dialog(
      CupertinoAlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (content != null && content.isNotEmpty)
                Text(content.join('\n')),
              // TODO: replace with const margin
              if (content != null && content.isNotEmpty)
                const SizedBox(height: 8),
              if (hint != null && hint.trim().isNotEmpty) Text(hint),
            ],
          ),
        ),
        actions: <Widget>[
          if (actions == null || actions.isNotEmpty)
            CupertinoButton(
              child: const Text('Okay'),
              onPressed: () {
                Get.back();
              },
            )
          else
            ...actions,
        ],
      ),
      barrierDismissible: false,
    );
  }

  static showErrorToast({required String content}) {
    _toast(content: content, color: Colors.red);
  }

  // static const showErrorToast = null;

  static showSuccessToast({required String content}) {
    _toast(content: content, color: Colors.green);
  }

  // static const showSuccessToast = null;

  // static showErrorDialog({
  //   required String title,
  //   List<String>? content,
  //   String? hint,
  //   List<Function>? actions,
  // }) {}

  static const showErrorDialog = null;

  // static showSuccessDialog({
  //   required String title,
  //   List<String>? content,
  //   String? hint,
  //   List<Function>? actions,
  // }) {}

  static const showSuccessDialog = null;
}
