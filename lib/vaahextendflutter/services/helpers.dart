import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Helpers {
  Helpers() {
    showErrorDialog = null;
    showErrorToast = null;
    showSuccessDialog = null;
    showSuccessToast = _showSuccessToast;
  }

  Function({
    required String title,
    List<String>? content,
    List<Function>? actions,
  })? showErrorDialog;

  Function({required String content})? showErrorToast;

  Function({
    required String title,
    List<String>? content,
    List<Function>? actions,
  })? showSuccessDialog;

  Function({required String content})? showSuccessToast;
}

void _showSuccessToast({required String content}) {
  _showToast(content: content, toastType: 'success');
}

void _showToast({
  required String content,
  String? toastType = 'default',
}) {
  switch (toastType) {
    case 'success':
      _defaultToast(content, Colors.green);
      break;
    case 'failure':
      _defaultToast(content, Colors.red);
      break;
    default:
      _defaultToast(content, Colors.white);
      break;
  }
}

void _defaultToast(String content, Color color) {
  Fluttertoast.showToast(
    msg: content,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: color.withOpacity(0.5),
    textColor: Colors.black,
    fontSize: 16.0,
  );
}
