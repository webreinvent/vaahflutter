import 'dart:io';

/// How to use: override http client global before run app
/// void main() {
/// setupSelfSignedHttpsOverrides();
///   runApp(MyApp());
/// }

void setupSelfSignedHttpsOverrides() {
  HttpOverrides.global = _SelfSignedHttps();
}

class _SelfSignedHttps extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final HttpClient client = super.createHttpClient(context);
    client.badCertificateCallback = (
      X509Certificate cert,
      String host,
      int port,
    ) =>
        true;
    return client;
  }
}

void setupProxyOverrides() {
  HttpOverrides.global = _AllowProxyHttpOverride();
}

String? _proxyAddressAndPort;
void setProxyService(String? proxyAddressAndPort) {
  _proxyAddressAndPort = proxyAddressAndPort;
}

class _AllowProxyHttpOverride extends HttpOverrides {
  _AllowProxyHttpOverride();

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final innerClient = super.createHttpClient(context);
    bool hasProxy() => _proxyAddressAndPort != null;
    innerClient.findProxy = (_) => hasProxy() ? 'PROXY $_proxyAddressAndPort' : 'DIRECT';
    innerClient.badCertificateCallback = (_, __, ___) => hasProxy();
    return innerClient;
  }
}
