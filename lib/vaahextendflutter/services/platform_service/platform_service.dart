import 'package:flutter/foundation.dart';

import 'services/base_service.dart';
import 'services/platform_channel_service.dart';

BasePlatformService get service {
  return PlatformChannelService();
}

abstract class PlatformService {
  static final BasePlatformService _service = service;

  /// Invokes a [method] with or without [arguments] present at the native side.
  ///
  /// Returns a [Future] which completes to one of the following:
  ///
  /// * on successful invocation, a result (possibly null),
  /// * if the invocation failed in the platform plugin, a [PlatformException],
  /// * if the method has not been implemented by a platform plugin, a [MissingPluginException].
  ///
  /// Example:
  /// ```dart
  /// final int sum = await PlatformService.invokeMethod<int>('getSum', {'a': 10, 'b': 20});
  /// print(sum); // 30
  /// ```
  static Future<T?> invokeMethod<T>(String method, [dynamic arguments]) {
    return _service.invokeMethod<T>(method, arguments);
  }

  /// Sets up a [Stream] using the [eventChannelName] with or without [argumetns].
  ///
  /// Returns a broadcast [Stream] which emits events to listeners as follows:
  ///
  /// * for every successfull event, a decoded data event (possibly null) is received from the
  ///   platform plugin;
  /// * for every error event, an error event containing a [PlatformException]
  ///   received from the platform plugin.
  ///
  /// When a stream is activated or deactivated, errors that happen are reported using the
  /// [FlutterError] capability. Only when the number of stream listeners increases from 0 to 1 does
  /// the stream become active. Deactivation of the stream only occurs when the number of stream
  /// listeners drops to zero.
  ///
  /// Example:
  /// ```dart
  /// final myStream = PlatformService.getEventStream('com.example.app/battery');
  /// ```
  static Stream<dynamic> getEventStream(String eventChannelName, [dynamic arguments]) {
    return _service.getEventStream(eventChannelName, arguments);
  }
}
