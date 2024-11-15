import 'package:flutter/widgets.dart';

import '../_local/console_service.dart';
import '../models/log.dart';
import 'logging_service.dart';

class FirebaseLoggingService implements LoggingService {
  @override
  Future<Widget> init({
    required Widget app,
  }) async {
    return app;
  }

  @override
  Future<void> addEventsLogger({
    required dynamic rumActionType,
    required String eventName,
    Map<String, Object>? eventProperties,
  }) async {
    Console.log(
      "~~~~~~> This method should be avoided with this logging service, as it doesn't do anything",
    );
  }

  @override
  Future<void> addSectionLogger({
    required String sectionName,
    required sectionValue,
  }) async {
    Console.log(
      "~~~~~~> This method should be avoided with this logging service, as it doesn't do anything",
    );
  }

  @override
  Future<void> logEvent({
    required String message,
    required EventType type,
    Object? data,
  }) async {
    Console.log(
      "~~~~~~> This method should be avoided with this logging service, as it doesn't do anything",
    );
  }

  @override
  Future<void> logException(
    throwable, {
    source,
    stackTrace,
    hint,
  }) async {
    Console.log(
      "~~~~~~> This method should be avoided with this logging service, as it doesn't do anything",
    );
  }

  @override
  Future<void> logTransaction({
    required Function execute,
    required TransactionDetails details,
  }) async {
    Console.log(
      "~~~~~~> This method should be avoided with this logging service, as it doesn't do anything",
    );
  }

  @override
  Future<void> setUserInfoLogger({
    String? id,
    String? name,
    String? email,
    Map<String, dynamic>? extraInfo,
  }) async {
    Console.log(
      "~~~~~~> This method should be avoided with this logging service, as it doesn't do anything",
    );
  }
}
