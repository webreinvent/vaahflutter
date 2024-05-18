import 'package:datadog_flutter_plugin/datadog_flutter_plugin.dart';
import 'package:flutter/foundation.dart' show PlatformDispatcher, FlutterError;

class DatadogLoggingService {
  DatadogLoggingService(this.datadogSdk);

  final DatadogSdk? datadogSdk;

  void logException(
    Object error, {
    RumErrorSource source = RumErrorSource.custom,
    required StackTrace? stackTrace,
  }) {
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      datadogSdk?.rum?.handleFlutterError(details);
      originalOnError?.call(details);
    };

    final platformOriginalOnError = PlatformDispatcher.instance.onError;
    PlatformDispatcher.instance.onError = (e, st) {
      datadogSdk?.rum?.addErrorInfo(
        error.toString(),
        source,
        stackTrace: st,
      );
      return platformOriginalOnError?.call(e, st) ?? false;
    };
  }
}
