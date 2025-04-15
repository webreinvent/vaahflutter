import 'package:flutter/material.dart';
import '../models/log.dart';

abstract class LoggingService {
  Future<Widget> init({
    required Widget app,
  });

  void logEvent({
    required String message,
    required EventType type,
    Map<String, dynamic>? data,
  });

  void logException(
    dynamic throwable, {
    StackTrace? stackTrace,
    Map<String, dynamic>? hint,
  });

  Future<void> logTransaction({
    required Function execute,
    required TransactionDetails details,
  });

  void setUserInfo({
    String? id,
    String? name,
    String? email,
    Map<String, dynamic>? metaData,
  });

  void unsetUserInfo();
}
