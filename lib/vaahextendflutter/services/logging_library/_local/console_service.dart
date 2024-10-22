import 'dart:convert';

import 'package:colorize/colorize.dart';
import 'package:flutter/material.dart';

import '../models/log.dart';

class Console {
  static void _printLog(String text, [Set<Styles>? logStyle]) {
    final RegExp pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((RegExpMatch match) {
      if (logStyle == null || logStyle.isEmpty) {
        return debugPrint(match.group(0));
      }
      Colorize chunk = Colorize(match.group(0).toString()).apply(logStyle.first);
      return debugPrint('$chunk');
    });
  }

  static String _parseData(Object? data) {
    try {
      JsonEncoder encoder = const JsonEncoder.withIndent('  ');
      return encoder.convert(data).toString();
    } catch (err) {
      danger("Cannot parse the data, please check the type of data!");
      return '';
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
    _printLog(
      message,
      {Styles.BLUE},
    );

    if (data != null) {
      _printLog(
        _parseData(data),
        {Styles.BLUE},
      );
    }
  }

  static void success(
    String message, {
    Object? data,
  }) {
    _printLog(
      message,
      {Styles.GREEN},
    );

    if (data != null) {
      _printLog(
        _parseData(data),
        {Styles.GREEN},
      );
    }
  }

  static void warning(
    String message, {
    Object? data,
  }) {
    _printLog(
      message,
      {Styles.YELLOW},
    );

    if (data != null) {
      _printLog(
        _parseData(data),
        {Styles.YELLOW},
      );
    }
  }

  static void danger(
    String message, {
    Object? throwable,
    StackTrace? stackTrace,
    dynamic hint,
  }) {
    _printLog(
      message,
      {Styles.RED},
    );

    if (throwable != null) {
      _printLog(
        _parseData(throwable),
        {Styles.RED},
      );
    }

    if (stackTrace != null) {
      _printLog(
        stackTrace.toString(),
        {Styles.RED},
      );
    }

    if (hint != null) {
      _printLog(
        _parseData(hint),
        {Styles.RED},
      );
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
