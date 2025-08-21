import 'dart:async' show scheduleMicrotask;

import 'package:flutter/foundation.dart' show kDebugMode;

import '../../models/logs/logs.dart';
import '../../models/user/vaah_user.dart';

class ConsoleTransport {
  const ConsoleTransport();

  static const _reset = '\x1B[0m';
  static const _blue = '\x1B[34m';
  static const _yellow = '\x1B[33m';
  static const _red = '\x1B[31m';

  Future<void> bindUser(VaahUser user) async {
    await log(
      LogRecord(
        timestamp: DateTime.now().toUtc(),
        level: LogLevel.info,
        message: 'User bound: ${user.id}',
        context: {'name': user.name, 'username': user.username, 'email': user.email},
      ),
    );
  }

  Future<void> unbindUser() async {
    await log(
      LogRecord(timestamp: DateTime.now().toUtc(), level: LogLevel.info, message: 'User unbound'),
    );
  }

  Future<void> log(LogRecord record) async {
    try {
      final ts = record.timestamp.toIso8601String();
      final level = record.level.name.toUpperCase();

      final String color;
      switch (record.level) {
        case LogLevel.info:
        case LogLevel.debug:
          color = _blue;
          break;
        case LogLevel.warn:
          color = _yellow;
          break;
        case LogLevel.error:
        case LogLevel.fatal:
          color = _red;
          break;
      }
      String ctxStr;
      if (record.context == null || record.context!.isEmpty) {
        ctxStr = '';
      } else {
        ctxStr = ' | ${record.context!.entries.map((e) => '${e.key}=${e.value}').join(' ')}';
      }

      final base = '[$level] $ts | ${record.message}$ctxStr';
      final out = '$color$base$_reset';

      scheduleMicrotask(() {
        if (kDebugMode) {
          print(out);
        }
      });

      if (record.error != null) {
        scheduleMicrotask(() {
          if (kDebugMode) {
            print(record.error);
          }
        });
      }
      if (record.stackTrace != null) {
        scheduleMicrotask(() {
          if (kDebugMode) {
            print(record.stackTrace);
          }
        });
      }
    } catch (_) {
      // swallow
    }
  }

  Future<void> dispose() async {
    // no-op
  }
}
