import 'services/base_service.dart';
import 'services/method_channel_service.dart';

BasePlatformService get service {
  return MethodChannelService();
}

abstract class PlatformService {
  static final BasePlatformService _service = service;

  static Future<T?> invokeMethod<T>(String method, [dynamic arguments]) {
    return _service.invokeMethod<T>(method, arguments);
  }

  static Stream<dynamic> getEventStream(String eventChannelName) {
    return _service.getEventStream(eventChannelName);
  }
}
