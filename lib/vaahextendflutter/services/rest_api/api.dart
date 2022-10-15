import 'dart:async';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' as getx;
import 'package:path_provider/path_provider.dart';
import 'models/api_error_type.dart';

import '../../../env.dart';

enum RequestType { get, post, put, patch, delete }

class Api {
  late EnvController envController;

  // Get base url by env
  late final String apiBaseUrl;
  final Dio dio = Dio();
  late PersistCookieJar cookieJar;

  Api() {
    _initApi();
  }

  // Get request header options
  Future<Options> _getOptions(
      {String contentType = Headers.jsonContentType}) async {
    final Map<String, String> header = <String, String>{};
    header.addAll(<String, String>{'Accept': 'application/json'});
    header.addAll(<String, String>{'X-Requested-With': 'XMLHttpRequest'});
    return Options(headers: header, contentType: contentType);
  }

  Future<Response?> ajax<T>({
    required BuildContext context,
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    RequestType requestType = RequestType.get,
    bool skipOnError = true, // if true then error dialogue won't be
    bool showSuccessDialogue =
        false, // if false on success nothing will be shown
    bool showErrorDialogue = true, // if false on error nothing will be shown
    Function?
        customSuccessDialogue, // if passed will be showed this instead of default
    Function?
        customErrorDialogue, // if passed will be showed this instead of default
    int? customTimeoutLimit,
    Future<void> Function()? onStart,
    Future<void> Function(dynamic error)? onError,
    Future<void> Function(bool status, Response<dynamic>? res)? onCompleted,
    Future<void> Function()? onFinally,
  }) async {
    try {
      // On Start, use for show loading
      if (onStart != null) {
        await onStart();
      }
      Response? response;
      final Options options = await _getOptions();
      switch (requestType) {
        case RequestType.get:
          response = await dio
              .get<dynamic>(
                '$apiBaseUrl$url',
                queryParameters: queryParameters,
                options: options,
              )
              .timeout(
                Duration(
                  seconds:
                      customTimeoutLimit ?? envController.config.timeoutLimit,
                ),
              );
          break;

        case RequestType.post:
          if (data == null) 'invalid data'; //TODO:
          response = await dio
              .post<dynamic>(
                '$apiBaseUrl$url',
                data: data,
                queryParameters: queryParameters,
                options: options,
              )
              .timeout(
                Duration(
                  seconds:
                      customTimeoutLimit ?? envController.config.timeoutLimit,
                ),
              );
          break;

        case RequestType.put:
          if (data == null) 'invalid data'; //TODO:
          response = await dio
              .put<dynamic>(
                '$apiBaseUrl$url',
                data: data,
                queryParameters: queryParameters,
                options: options,
              )
              .timeout(
                Duration(
                  seconds:
                      customTimeoutLimit ?? envController.config.timeoutLimit,
                ),
              );
          break;

        case RequestType.patch:
          if (data == null) 'invalid data'; //TODO:
          response = await dio
              .patch<dynamic>(
                '$apiBaseUrl$url',
                data: data,
                queryParameters: queryParameters,
                options: options,
              )
              .timeout(
                Duration(
                  seconds:
                      customTimeoutLimit ?? envController.config.timeoutLimit,
                ),
              );
          break;

        case RequestType.delete:
          if (data == null) 'invalid data'; //TODO:
          response = await dio
              .delete<dynamic>(
                '$apiBaseUrl$url',
                data: data,
                queryParameters: queryParameters,
                options: options,
              )
              .timeout(
                Duration(
                  seconds:
                      customTimeoutLimit ?? envController.config.timeoutLimit,
                ),
              );
          break;

        default:
          // TODO: Invalid request type, try again
          break;
      }

      // On completed, use for hide loading
      if (onCompleted != null) {
        await onCompleted(true, response);
      }
      return response;
      // TODO:
    } catch (error) {
      // In case error:
      // On completed, use for hide loading
      if (onCompleted != null) {
        await onCompleted(false, null);
      }

      // On inline error
      if (onError != null) {
        await onError(error);
      }

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
          if (error.type == DioErrorType.response) {
            ApiErrorCode errorCode = ApiErrorCode.unknown;
            String message = error.message;
            if (error.response?.statusCode == 401) {
              errorCode = ApiErrorCode.unauthorized;
            }
            if (error.response?.data != null) {
              try {
                final Map<String, dynamic> response =
                    error.response?.data as Map<String, dynamic>;
                message = response['error'] ?? '';
              } catch (e) {
                // ignore parsing error
              }
            }
            ApiErrorType apiErrorType =
                ApiErrorType(code: errorCode, message: message);
            if (apiErrorType.code == ApiErrorCode.unauthorized) {
              // TODO: Logout
            }
            if (showErrorDialogue) {
              if (customErrorDialogue != null) {
                mainErrorDialogue(
                  skipOnError: skipOnError,
                  errorDialogue: () => customErrorDialogue(),
                );
              } else {
                mainErrorDialogue(
                  skipOnError: skipOnError,
                  errorDialogue: () => defaultErrorDialogue(
                    context: context,
                    title: 'Error',
                    content: apiErrorType.message,
                  ),
                );
              }
            }
          } else {
            rethrow;
          }
        }
      }
    } finally {
      /// Call finally function
      if (onFinally != null) {
        await onFinally();
      }
    }
    return null;
  }

  mainErrorDialogue(
      {required bool skipOnError, required Function() errorDialogue}) async {
    if (skipOnError) {
      await errorDialogue();
    } else {
      await errorDialogue();
      mainErrorDialogue(
        skipOnError: skipOnError,
        errorDialogue: () => errorDialogue,
      );
    }
  }

  defaultErrorDialogue({
    required BuildContext context,
    required String title,
    required String content,
    List<Widget>? actions,
  }) {
    return showCupertinoDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            if (actions == null || actions.isNotEmpty)
              CupertinoButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            else
              ...actions,
          ],
        );
      },
    );
  }

  Future<void> _initApi() async {
    bool envControllerExists = getx.Get.isRegistered<EnvController>();
    if (!envControllerExists) {
      throw Exception('envController does not exist in app');
    }
    // get env controller and set variable showEnvAndVersionTag
    envController = getx.Get.find<EnvController>();
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
}
