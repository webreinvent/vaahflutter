import 'package:flutter/services.dart';

import 'base_service.dart';

class MethodChannelService implements BasePlatformService {
  static const _methodChannel = MethodChannel('com.example.app/method');
  static final Map<String, EventChannel> _eventChannels = {};

  @override
  Future<T?> invokeMethod<T>(String method, [dynamic arguments]) async {
    try {
      final result = await _methodChannel.invokeMethod<T>(method, arguments);
      return result;
    } on PlatformException catch (e) {
      throw 'Failed to invoke method: ${e.message}';
    }
  }

  @override
  Stream<dynamic> getEventStream(String eventChannelName) {
    if (!_eventChannels.containsKey(eventChannelName)) {
      _eventChannels[eventChannelName] = EventChannel(eventChannelName);
    }
    return _eventChannels[eventChannelName]!.receiveBroadcastStream();
  }
}
