import 'dart:convert';

import 'package:colorize/colorize.dart';
import 'package:flutter/material.dart';

import '../models/log.dart';

class Console {
  static void _printChunks(Colorize text) {
    final RegExp pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text.toString()).forEach(
          (RegExpMatch match) => debugPrint(
            match.group(0),
          ),
        );
  }

  static void _printLog(Colorize text) {
    _printChunks(text);
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

  static void log(String text, [Object? data]) {
    Colorize txt = Colorize(text);
    _printLog(txt);

    if (data != null) {
      Colorize dataColor = Colorize(_parseData(data));
      dataColor.white();
      _printLog(dataColor);
    }
  }

  static void info(String text, [Object? data]) {
    Colorize txt = Colorize(text);
    txt.blue();
    _printLog(txt);

    if (data != null) {
      Colorize dataColor = Colorize(_parseData(data));
      dataColor.blue();
      _printLog(dataColor);
    }
  }

  static void success(String text, [Object? data]) {
    Colorize txt = Colorize(text);
    txt.green();
    _printLog(txt);

    if (data != null) {
      Colorize dataColor = Colorize(_parseData(data));
      dataColor.green();
      _printLog(dataColor);
    }
  }

  static void warning(String text, [Object? data]) {
    Colorize txt = Colorize(text);
    txt.yellow();
    _printLog(txt);

    if (data != null) {
      Colorize dataColor = Colorize(_parseData(data));
      dataColor.yellow();
      _printLog(dataColor);
    }
  }

  static void danger(String text, [Object? data]) {
    Colorize txt = Colorize(text);
    txt.red();
    _printLog(txt);

    if (data != null) {
      Colorize dataColor = Colorize(_parseData(data));
      dataColor.red();
      _printLog(dataColor);
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
