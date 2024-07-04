import 'package:flutter/services.dart';

import '../../../env/env.dart';
import 'base_service.dart';

class PlatformChannelService implements BasePlatformService {
  final String _methodChannelName = EnvironmentConfig.getConfig.methodChannelName;
  static final Map<String, EventChannel> _eventChannels = {};

  @override
  Future<T?> invokeMethod<T>(String method, [dynamic arguments]) async {
    final MethodChannel channel = MethodChannel(_methodChannelName);
    try {
      final result = await channel.invokeMethod<T>(method, arguments);
      return result;
    } on MissingPluginException catch (e) {
      if (channel.name.isEmpty) {
        throw 'Please provide correct method_channel_name in env config: ${e.message}';
      }
      throw 'No plugin handler for the method call was found: ${e.message}(${channel.name})';
    } on PlatformException catch (e) {
      throw 'Failed to invoke method: ${e.message}';
    }
  }

  @override
  Stream<dynamic> getEventStream(String eventChannelName, [dynamic arguments]) {
    if (!_eventChannels.containsKey(eventChannelName)) {
      _eventChannels[eventChannelName] = EventChannel(eventChannelName);
    }
    return _eventChannels[eventChannelName]!.receiveBroadcastStream(arguments);
  }
}
