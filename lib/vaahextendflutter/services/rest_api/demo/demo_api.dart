import 'package:dio/dio.dart';

import '../api.dart';

class DemoApi extends Api {
  /// How to get X-XSRF-TOKEN
  /// GET https://staging.theavenue.live/sanctum/csrf-cookie
  /// - Parse header cookie 'X-XSRF-TOKEN' => encoded_token
  /// - Use url decode 'encoded_token' to get auth Token
  /// - Add X-XSRF-TOKEN to header for any call
  /// Note with POST api header:
  /// - X-Requested-With=XMLHttpRequest
  /// - Content-Type=application/json
  Future<dynamic> getXSRFToken() async {
    final Options options = await getOptions();
    return wrapE<dynamic>(() =>
        dio.get<dynamic>('$apiBaseUrl/auth/csrf-cookie', options: options));
  }

  Future<dynamic> getError() async {
    final Options options = await getOptions();
    return wrapE<dynamic>(
        () => dio.get<dynamic>('$apiBaseUrl/error?code=400', options: options));
  }
}
