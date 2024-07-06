abstract class BasePlatformService {
  Future<T?> invokeMethod<T>(String method, [dynamic arguments]);
  Stream<dynamic> getEventStream(String eventChannelName, [dynamic arguments]);
}
