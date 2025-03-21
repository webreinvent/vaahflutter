import 'package:flutter/services.dart';

import 'base_service.dart';

class PlatformChannelService implements BasePlatformService {
  static final Map<String, EventChannel> _eventChannels = {};
  static final Map<String, String> _methodChannels = {};

  @override
  Future<T?> invokeMethod<T>(String method, [dynamic arguments]) async {
    final String methodChannelName = _methodChannels.putIfAbsent(method, () => method);

    if (methodChannelName.isEmpty) {
      throw 'Method channel name not found for method: $method';
    }

    final MethodChannel channel = MethodChannel(methodChannelName);

    try {
      return await channel.invokeMethod<T>(methodChannelName, arguments);
    } on MissingPluginException catch (e) {
      throw 'No plugin handler for the method call: ${e.message} (${channel.name})';
    } on PlatformException catch (e) {
      throw 'Failed to invoke method: ${e.message}';
    } catch (e) {
      throw 'Unexpected error invoking method: $e';
    }
  }

  @override
  Stream<dynamic> getEventStream(String eventChannelName, [dynamic arguments]) {
    return _eventChannels
        .putIfAbsent(eventChannelName, () => EventChannel(eventChannelName))
        .receiveBroadcastStream(arguments);
  }
}
