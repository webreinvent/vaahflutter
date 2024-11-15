import 'package:datadog_flutter_plugin/datadog_flutter_plugin.dart';
import 'package:flutter/material.dart';

import '../models/log.dart';

abstract class LoggingService {
  Future<Widget> init({
    required Widget app,
  });

  Future<void> logException(
    dynamic throwable, {
    dynamic source,
    dynamic stackTrace,
    dynamic hint,
  });

  Future<void> setUserInfoLogger({
    String? id,
    String? name,
    String? email,
    Map<String, dynamic>? extraInfo,
  });

  Future<void> logEvent({
    required String message,
    required EventType type,
    Object? data,
  });

  Future<void> addEventsLogger({
    required RumActionType rumActionType,
    required String eventName,
    Map<String, Object>? eventProperties,
  });

  Future<void> addSectionLogger({
    required String sectionName,
    required dynamic sectionValue,
  });

  Future<void> logTransaction({
    required Function execute,
    required TransactionDetails details,
  });
}
