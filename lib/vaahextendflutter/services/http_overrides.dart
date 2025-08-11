import 'dart:io';

abstract class HttpOverridesSetup {
  static void setupSelfSignedHttpsOverrides() {
    HttpOverrides.global = _SelfSignedHttps();
  }

  static void setupProxyOverrides() {
    HttpOverrides.global = _AllowProxyHttpOverride();
  }

  static void setProxyService(String? proxyAddressAndPort) {
    _AllowProxyHttpOverride.setProxyAddressAndPort(proxyAddressAndPort);
  }
}

class _SelfSignedHttps extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final HttpClient client = super.createHttpClient(context);
    client.badCertificateCallback = (
      X509Certificate cert,
      String host,
      int port,
    ) {
      return true;
    };
    return client;
  }
}

class _AllowProxyHttpOverride extends HttpOverrides {
  static String? _proxyAddressAndPort;

  _AllowProxyHttpOverride();

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final innerClient = super.createHttpClient(context);
    bool hasProxy() => _proxyAddressAndPort != null;
    innerClient.findProxy = (_) => hasProxy() ? 'PROXY $_proxyAddressAndPort' : 'DIRECT';
    innerClient.badCertificateCallback = (_, __, ___) => hasProxy();
    return innerClient;
  }

  static void setProxyAddressAndPort(String? proxyAddressAndPort) {
    _proxyAddressAndPort = proxyAddressAndPort;
  }
}
