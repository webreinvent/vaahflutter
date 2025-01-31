import 'dart:convert';

import 'package:colorize/colorize.dart';
import 'package:flutter/material.dart';

import '../models/log.dart';

class Console {
  static void _printLog(
    String text, {
    Styles? style,
  }) {
    final RegExp pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((RegExpMatch match) {
      if (style == null) {
        return debugPrint(match.group(0));
      }
      Colorize chunk = Colorize(match.group(0).toString()).apply(style);
      return debugPrint('$chunk');
    });
  }

  static String _parseData(Object? data) {
    try {
      JsonEncoder encoder = const JsonEncoder.withIndent('  ');
      return encoder.convert(data).toString();
    } catch (err) {
      danger("Cannot parse the data, please check the type of data!");
      return data.toString();
    }
  }

  static void log(
    String message, {
    Object? data,
  }) {
    _printLog(message);

    if (data != null) {
      _printLog(_parseData(data));
    }
  }

  static void info(
    String message, {
    Object? data,
  }) {
    _printLog(message, style: Styles.BLUE);

    if (data != null) {
      _printLog(_parseData(data), style: Styles.BLUE);
    }
  }

  static void success(
    String message, {
    Object? data,
  }) {
    _printLog(message, style: Styles.GREEN);

    if (data != null) {
      _printLog(_parseData(data), style: Styles.GREEN);
    }
  }

  static void warning(
    String message, {
    Object? data,
  }) {
    _printLog(message, style: Styles.YELLOW);

    if (data != null) {
      _printLog(_parseData(data), style: Styles.YELLOW);
    }
  }

  static void danger(
    String message, {
    Object? throwable,
    StackTrace? stackTrace,
    dynamic hint,
  }) {
    _printLog(message, style: Styles.RED);

    if (throwable != null) {
      _printLog(_parseData(throwable), style: Styles.RED);
    }

    if (stackTrace != null) {
      _printLog(stackTrace.toString(), style: Styles.RED);
    }

    if (hint != null) {
      _printLog(_parseData(hint), style: Styles.RED);
    }
  }

  static logTransaction({
    required Function execute,
    required TransactionDetails details,
  }) async {
    final DateTime start = DateTime.now();
    await execute();
    final DateTime end = DateTime.now();
    final diff = end.difference(start);
    success('------------- execution details -------------');
    info('Transaction Name: ${details.name} | Operation: ${details.operation}');
    if (null != details.description && details.description!.isNotEmpty) {
      info('Description: ${details.description}');
    }
    info('Execution time in milliseconds: ${diff.inMilliseconds}');
  }
}
