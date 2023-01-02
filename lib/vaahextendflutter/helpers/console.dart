import 'dart:convert';

import 'package:colorize/colorize.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../env.dart';

class Console {
  static void printChunks(Colorize text) {
    final RegExp pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text.toString()).forEach(
          (RegExpMatch match) => debugPrint(
            match.group(0),
          ),
        );
  }

  static void printLog(Colorize text) {
    bool envControllerExists = Get.isRegistered<EnvController>();
    if (envControllerExists) {
      EnvController envController = Get.find<EnvController>();
      if (envController.config.enableConsoleLogs == false) return;
    }
    Console.printChunks(text);
  }

  static String _parseData(Object? data) {
    try {
      JsonEncoder encoder = const JsonEncoder.withIndent('  ');
      return encoder.convert(data).toString();
    } catch (err) {
      return "Cannot parse the data, please check the type of data!";
    }
  }

  static void log(String text, [Object? data]) {
    Colorize txt = Colorize(text);
    Console.printLog(txt);

    if (data != null) {
      Colorize dataColor = Colorize(_parseData(data));
      Console.printLog(dataColor);
    }
  }

  static void info(String text, [Object? data]) {
    Colorize txt = Colorize(text);
    txt.blue();
    Console.printLog(txt);

    if (data != null) {
      Colorize dataColor = Colorize(_parseData(data));
      dataColor.blue();
      Console.printLog(dataColor);
    }
  }

  static void success(String text, [Object? data]) {
    Colorize txt = Colorize(text);
    txt.green();
    Console.printLog(txt);

    if (data != null) {
      Colorize dataColor = Colorize(_parseData(data));
      dataColor.green();
      Console.printLog(dataColor);
    }
  }

  static void warning(String text, [Object? data]) {
    Colorize txt = Colorize(text);
    txt.yellow();
    Console.printLog(txt);

    if (data != null) {
      Colorize dataColor = Colorize(_parseData(data));
      dataColor.yellow();
      Console.printLog(dataColor);
    }
  }

  static void danger(String text, [Object? data]) {
    Colorize txt = Colorize(text);
    txt.red();
    Console.printLog(txt);

    if (data != null) {
      Colorize dataColor = Colorize(_parseData(data));
      dataColor.red();
      Console.printLog(dataColor);
    }
  }
}
