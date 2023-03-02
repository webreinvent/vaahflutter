import 'dart:convert';

import 'package:colorize/colorize.dart';
import 'package:flutter/material.dart';

import '../../../env.dart';

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
    if (!EnvironmentConfig.getEnvConfig().enableConsoleLogs) return;
    Console._printChunks(text);
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
    Console._printLog(txt);

    if (data != null) {
      Colorize dataColor = Colorize(_parseData(data));
      dataColor.white();
      Console._printLog(dataColor);
    }
  }

  static void info(String text, [Object? data]) {
    Colorize txt = Colorize(text);
    txt.blue();
    Console._printLog(txt);

    if (data != null) {
      Colorize dataColor = Colorize(_parseData(data));
      dataColor.blue();
      Console._printLog(dataColor);
    }
  }

  static void success(String text, [Object? data]) {
    Colorize txt = Colorize(text);
    txt.green();
    Console._printLog(txt);

    if (data != null) {
      Colorize dataColor = Colorize(_parseData(data));
      dataColor.green();
      Console._printLog(dataColor);
    }
  }

  static void warning(String text, [Object? data]) {
    Colorize txt = Colorize(text);
    txt.yellow();
    Console._printLog(txt);

    if (data != null) {
      Colorize dataColor = Colorize(_parseData(data));
      dataColor.yellow();
      Console._printLog(dataColor);
    }
  }

  static void danger(String text, [Object? data]) {
    Colorize txt = Colorize(text);
    txt.red();
    Console._printLog(txt);

    if (data != null) {
      Colorize dataColor = Colorize(_parseData(data));
      dataColor.red();
      Console._printLog(dataColor);
    }
  }
}
