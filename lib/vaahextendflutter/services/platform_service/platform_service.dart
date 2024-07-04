import 'services/base_service.dart';
import 'services/platform_channel_service.dart';

BasePlatformService get service {
  return PlatformChannelService();
}

abstract class PlatformService {
  static final BasePlatformService _service = service;

  static Future<T?> invokeMethod<T>(String method, [dynamic arguments]) {
    return _service.invokeMethod<T>(method, arguments);
  }

  static Stream<dynamic> getEventStream(String eventChannelName, [dynamic arguments]) {
    return _service.getEventStream(eventChannelName, arguments);
  }
}
