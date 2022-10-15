import 'dart:async';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:get/get.dart' as getx;
import 'package:path_provider/path_provider.dart';

import '../../../env.dart';
import 'models/token.dart';

class Api {
  Api() {
    bool envControllerExists = getx.Get.isRegistered<EnvController>();
    if (!envControllerExists) {
      throw Exception('envController does not exist in app');
    }
    // get env controller and set variable showEnvAndVersionTag
    EnvController envController = getx.Get.find<EnvController>();
    apiBaseUrl = envController.config.apiBaseUrl;
    if (envController.config.enableApiLogs) {
      dio.interceptors.add(
        LogInterceptor(
          responseBody: true,
          requestBody: true,
        ),
      );
    }
    getApplicationDocumentsDirectory().then(
      (Directory appDocDir) async {
        final String appDocPath = appDocDir.path;
        final String cookiePath = '$appDocPath/cookies';
        final Directory dir = Directory(cookiePath);
        await dir.create();
        cookieJar = PersistCookieJar(
          storage: FileStorage(cookiePath),
        );
        dio.interceptors.add(
          CookieManager(cookieJar),
        );
        dio.interceptors.add(
          InterceptorsWrapper(
            onResponse: (Response<dynamic> response, handler) async {
              final String urlPath = response.requestOptions.path;
              final List<Cookie> cookies =
                  await cookieJar.loadForRequest(Uri.parse(urlPath));
              final String? xsrfToken = cookies
                  .firstWhereOrNull(
                    (Cookie c) => c.name == 'XSRF-TOKEN',
                  )
                  ?.value;
              // Set dio auth header token once time
              if (xsrfToken != null) {
                // The XSRF-TOKEN got from cookie requires decoded before add to header
                dio.options.headers['X-XSRF-TOKEN'] =
                    Uri.decodeComponent(xsrfToken);
                String cookieStr = '';
                for (int i = 0; i < cookies.length; i++) {
                  final Cookie c = cookies[i];
                  cookieStr += '${c.name}=${c.value}; ';
                }
                dio.options.headers['Cookie'] = cookieStr;
              }
              return;
            },
          ),
        );
      },
    );
  }

  // Credential info
  Token? token;

  // Get base url by env
  late final String apiBaseUrl;
  final Dio dio = Dio();
  late PersistCookieJar cookieJar;

  // Get request header options
  Future<Options> getOptions(
      {String contentType = Headers.jsonContentType}) async {
    final Map<String, String> header = <String, String>{};
    header.addAll(<String, String>{'Accept': 'application/json'});
    header.addAll(<String, String>{'X-Requested-With': 'XMLHttpRequest'});
    return Options(headers: header, contentType: contentType);
  }

  // Get auth header options
  Future<Options> getAuthOptions({required String contentType}) async {
    final Options options = await getOptions(contentType: contentType);

    if (token != null) {
      options.headers?.addAll(
          <String, String>{'Authorization': 'Bearer ${token?.bearerToken}'});
    }

    return options;
  }

  // Wrap Dio Exception
  Future<Response<T>> wrapE<T>(Future<Response<T>> Function() dioApi) async {
    try {
      return await dioApi();
    } catch (error) {
      if (error is DioError && error.type == DioErrorType.response) {
        final Response<dynamic>? response = error.response;
        try {
          // By pass dio header error code to get response content
          // Try to return response
          if (response == null) {
            throw DioError(
              requestOptions: error.requestOptions,
              response: error.response,
              type: error.type,
              error: response?.statusMessage,
            );
          }
          final Response<T> res = Response<T>(
            data: response.data as T,
            headers: response.headers,
            requestOptions: response.requestOptions,
            isRedirect: response.isRedirect,
            statusCode: response.statusCode,
            statusMessage: response.statusMessage,
            redirects: response.redirects,
            extra: response.extra,
          );
          throw DioError(
            requestOptions: error.requestOptions,
            response: res,
            type: error.type,
            error: res.statusMessage,
          );
        } catch (e) {
          rethrow;
          // ignore cast error type
        }
      }
      rethrow;
    }
  }
}
