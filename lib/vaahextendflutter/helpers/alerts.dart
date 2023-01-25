import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../app_theme.dart';
import 'constants.dart';

class Alerts {
  static Future<void> _toast({required String content}) async {
    await Fluttertoast.showToast(
      msg: content,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.colors['white'],
      textColor: AppTheme.colors['black'],
      fontSize: 16.0,
    );
  }

  static _dialog({
    required String title,
    List<String>? content,
    String? hint,
    List<Widget>? actions,
    Color color = Colors.white,
  }) {
    return Get.dialog(
      AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(defaultPadding),
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
              if (content != null && content.isNotEmpty) verticalMargin12,
              if (content != null && content.isNotEmpty)
                Padding(
                  padding: horizontalPadding8,
                  child: Text(
                    content.join('\n'),
                    textAlign: TextAlign.center,
                  ),
                ),
              if ((content != null && content.isNotEmpty) ||
                  (hint != null && hint.trim().isNotEmpty))
                verticalMargin8,
              if (hint != null && hint.trim().isNotEmpty)
                Padding(
                  padding: horizontalPadding8,
                  child: Text(
                    hint,
                    textAlign: TextAlign.center,
                  ),
                ),
              if (hint != null && hint.trim().isNotEmpty) verticalMargin8
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
                    color: color == AppTheme.colors['white']
                        ? AppTheme.colors['black']
                        : AppTheme.colors['white'],
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

  static Future<void> Function({
    required String content,
  })? showInfoToast = ({required String content}) async {
    await _toast(content: content);
  };

  static Future<void> Function({
    required String content,
  })? showErrorToast = ({required String content}) async {
    await _toast(content: 'Error: $content');
  };

  static Future<void> Function({
    required String content,
  })? showSuccessToast = ({required String content}) async {
    await _toast(content: content);
  };

  static Future<void> Function({
    required String title,
    List<String>? content,
    String? hint,
    List<Widget>? actions,
  })? showErrorDialog = ({
    required String title,
    List<String>? content,
    String? hint,
    List<Widget>? actions,
  }) async {
    await _dialog(
      title: title,
      content: content,
      hint: hint,
      actions: actions,
      color: AppTheme.colors['danger']!,
    );
  };

  static Future<void> Function({
    required String title,
    List<String>? content,
    String? hint,
    List<Widget>? actions,
  })? showSuccessDialog = ({
    required String title,
    List<String>? content,
    String? hint,
    List<Widget>? actions,
  }) async {
    await _dialog(
      title: title,
      content: content,
      hint: hint,
      actions: actions,
      color: AppTheme.colors['success']!,
    );
  };
}
