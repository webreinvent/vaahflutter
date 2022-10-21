import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../env.dart';

class Helpers {
  static logout() {
    // Navigate using getx
  }

  // ignore: unused_element
  static _toast({required String content, Color color = kWhiteColor}) {
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
    Color color = kWhiteColor,
  }) {
    return Get.dialog(
      AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            // TODO: define const
            Radius.circular(16.0),
          ),
        ),
        contentPadding: EdgeInsets.zero,
        title: Center(child: Text(title)),
        content: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // TODO: replace with const margin
              if (content != null && content.isNotEmpty)
                const SizedBox(height: 12),
              if (content != null && content.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    content.join('\n'),
                    textAlign: TextAlign.justify,
                  ),
                ),
              if ((content != null && content.isNotEmpty) || (hint != null && hint.trim().isNotEmpty))
                const SizedBox(height: 8),
              if (hint != null && hint.trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    hint,
                    textAlign: TextAlign.justify,
                  ),
                ),
              if (hint != null && hint.trim().isNotEmpty)
                const SizedBox(height: 8),
            ],
          ),
        ),
        actions: <Widget>[
          if (actions == null || actions.isNotEmpty)
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: color),
                child: Text(
                  'Ok',
                  style: TextStyle(
                    color: color == kWhiteColor ? kBlackColor : kWhiteColor,
                  ),
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            )
          else
            ...actions,
        ],
      ),
      barrierDismissible: false,
    );
  }

  static showErrorToast({required String content}) {
    _toast(content: content, color: kDangerColor);
  }

  static showSuccessToast({required String content}) {
    _toast(content: content, color: kSuccessColor);
  }

  static showErrorDialog({
    required String title,
    List<String>? content,
    String? hint,
    List<Widget>? actions,
  }) {
    _dialog(
      title: title,
      content: content,
      hint: hint,
      actions: actions,
      color: kDangerColor,
    );
  }

  static showSuccessDialog({
    required String title,
    List<String>? content,
    String? hint,
    List<Widget>? actions,
  }) {
    _dialog(
      title: title,
      content: content,
      hint: hint,
      actions: actions,
      color: kSuccessColor,
    );
  }
}
