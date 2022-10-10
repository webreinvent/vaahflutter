import 'package:colorize/colorize.dart';
import 'package:flutter/material.dart';

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
    Console.printChunks(text);
  }

  static void log(String text, [Object? data]) {
    Colorize txt = Colorize(text);
    Console.printLog(txt);

    if (data != null) {
      Colorize dataColor = Colorize(data.toString());
      Console.printLog(dataColor);
    }
  }

  static void info(String text, [Object? data]) {
    Colorize txt = Colorize(text);
    txt.blue();
    Console.printLog(txt);

    if (data != null) {
      Colorize dataColor = Colorize(data.toString());
      dataColor.blue();
      Console.printLog(dataColor);
    }
  }

  static void success(String text, [Object? data]) {
    Colorize txt = Colorize(text);
    txt.green();
    Console.printLog(txt);

    if (data != null) {
      Colorize dataColor = Colorize(data.toString());
      dataColor.green();
      Console.printLog(dataColor);
    }
  }

  static void warning(String text, [Object? data]) {
    Colorize txt = Colorize(text);
    txt.yellow();
    Console.printLog(txt);

    if (data != null) {
      Colorize dataColor = Colorize(data.toString());
      dataColor.yellow();
      Console.printLog(dataColor);
    }
  }

  static void danger(String text, [Object? data]) {
    Colorize txt = Colorize(text);
    txt.red();
    Console.printLog(txt);

    if (data != null) {
      Colorize dataColor = Colorize(data.toString());
      dataColor.red();
      Console.printLog(dataColor);
    }
  }
}
