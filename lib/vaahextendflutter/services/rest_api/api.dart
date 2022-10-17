import 'dart:async';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' as getx;
import 'package:path_provider/path_provider.dart';

import '../../log/console.dart';
import 'models/api_response_type.dart';
import 'models/api_error_type.dart';
import '../../../env.dart';

enum RequestType { get, post, put, patch, delete }

class Api {
  // To check  env variables logs enabled, apiUrl and timeout limit for requests
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

  // return type of ajax is ApiResponseType? so if there is error
  // then null will be returned otherwise ApiResponseType object
  Future<ApiResponseType?> ajax<T>({
    required String url,
    RequestType requestType = RequestType.get,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool showSuccessDialogue =
        false, // if false on success nothing will be shown
    bool showErrorDialogue = true, // if false on error nothing will be shown
    bool skipOnError = true, // if true then error dialogue will be dismissible
    Function?
        customSuccessDialogue, // if passed will be showed this instead of default
    Function?
        customErrorDialogue, // if passed will be showed this instead of default
    int? customTimeoutLimit,
    Future<void> Function()? onStart,
    Future<void> Function(dynamic error)? onError,
    Future<void> Function(bool status, ApiResponseType? res)? onCompleted,
    Future<void> Function()? onFinally,
  }) async {
    try {
      // On Start, use for show loading
      if (onStart != null) {
        await onStart();
      }

      Response<dynamic>? response = await handleRequest(
        requestType: requestType,
        url: url,
        data: data,
        skipOnError: skipOnError,
        queryParameters: queryParameters,
        customTimeoutLimit: customTimeoutLimit,
      );
      Console.danger('>>> $response');

      ApiResponseType apiResponseType = handleResponse(
        response,
        showSuccessDialogue,
        customSuccessDialogue,
      );

      // On completed, use for hide loading
      if (onCompleted != null) {
        await onCompleted(true, apiResponseType);
      }

      return apiResponseType;
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
      // All errors other than dio error eg. typeError
      if (error is! DioError) {
        rethrow;
      }
      // Timeout Error
      else if (error.type == DioErrorType.sendTimeout ||
          error.type == DioErrorType.receiveTimeout) {
        handleTimeoutError(error, skipOnError);
        return null;
      }
      // Here response error means server sends error response. eg 401: unauthorised
      else if (error.type == DioErrorType.response) {
        handleResponseError(
          error,
          showErrorDialogue,
          customErrorDialogue,
          skipOnError,
        );
        return null;
      }
      rethrow;
    } finally {
      // Call finally function
      if (onFinally != null) {
        await onFinally();
      }
    }
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
  }

  Future<Response<dynamic>?> handleRequest({
    required RequestType requestType,
    required String url,
    required Map<String, dynamic>? data,
    required Map<String, dynamic>? queryParameters,
    required int? customTimeoutLimit,
    required bool skipOnError,
  }) async {
    Response? response;
    final Options options = await _getOptions();
    options.sendTimeout =
        customTimeoutLimit ?? envController.config.timeoutLimit;
    options.receiveTimeout =
        customTimeoutLimit ?? envController.config.timeoutLimit;
    switch (requestType) {
      case RequestType.get:
        response = await dio.get<dynamic>(
          '$apiBaseUrl$url',
          queryParameters: queryParameters,
          options: options,
        );
        break;

      case RequestType.post:
        if (data == null) {
          mainDialogue(
            skip: skipOnError,
            dialogue: () => defaultErrorDialogue(
              title: 'Error',
              content: ['Invalid data!'],
            ),
          );
          break;
        }
        response = await dio.post<dynamic>(
          '$apiBaseUrl$url',
          data: data,
          queryParameters: queryParameters,
          options: options,
        );
        break;

      case RequestType.put:
        if (data == null) {
          mainDialogue(
            skip: skipOnError,
            dialogue: () => defaultErrorDialogue(
              title: 'Error',
              content: ['Invalid data!'],
            ),
          );
          break;
        }
        response = await dio.put<dynamic>(
          '$apiBaseUrl$url',
          data: data,
          queryParameters: queryParameters,
          options: options,
        );
        break;

      case RequestType.patch:
        if (data == null) {
          mainDialogue(
            skip: skipOnError,
            dialogue: () => defaultErrorDialogue(
              title: 'Error',
              content: ['Invalid data!'],
            ),
          );
          break;
        }
        response = await dio.patch<dynamic>(
          '$apiBaseUrl$url',
          data: data,
          queryParameters: queryParameters,
          options: options,
        );
        break;

      case RequestType.delete:
        if (data == null) {
          mainDialogue(
            skip: skipOnError,
            dialogue: () => defaultErrorDialogue(
              title: 'Error',
              content: ['Invalid data!'],
            ),
          );
          break;
        }
        response = await dio.delete<dynamic>(
          '$apiBaseUrl$url',
          data: data,
          queryParameters: queryParameters,
          options: options,
        );
        break;

      default:
        mainDialogue(
          skip: skipOnError,
          dialogue: () => defaultErrorDialogue(
            title: 'Error',
            content: ['Invalid request type!'],
          ),
        );
        break;
    }
    return response;
  }

  ApiResponseType handleResponse(
    Response<dynamic>? response,
    bool showSuccessDialogue,
    Function? customSuccessDialogue,
  ) {
    if (response != null && response.data != null) {
      try {
        final Map<String, dynamic> formatedResponse =
            response.data as Map<String, dynamic>;
        bool? responseSuccess = formatedResponse['success'];
        if (responseSuccess == null) {
          Console.warning('response doesn\'t contain success key.');
        }
        dynamic responseData = formatedResponse['data'];
        if (responseData == null) {
          Console.warning('response doesn\'t contain data key.');
        }
        List<String>? responseMessages = formatedResponse['messages'];
        if (responseMessages == null) {
          Console.warning('response doesn\'t contain messages key.');
        }
        String? responseHint = formatedResponse['hint'];
        if (responseHint == null) {
          Console.warning('response doesn\'t contain hint key.');
        }
        if (showSuccessDialogue) {
          if (customSuccessDialogue != null) {
            mainDialogue(
              skip: true,
              dialogue: () => customSuccessDialogue(),
            );
          } else {
            mainDialogue(
              skip: true,
              dialogue: () => defaultSuccessDialogue(
                title: 'Success',
                content: responseMessages,
                hint: responseHint,
              ),
            );
          }
        }
        return ApiResponseType(
          success: responseSuccess ?? true,
          data: responseData,
          messages: responseMessages,
          hint: responseHint,
        );
      } catch (e) {
        rethrow;
      }
    }
    throw Exception('response from server is null or response.data is null');
  }

  void handleTimeoutError(DioError error, bool skipOnError) {
    Console.danger(error.toString());
    mainDialogue(
      skip: skipOnError,
      dialogue: () => defaultErrorDialogue(
        title: 'Error',
        content: ['Check your internet connection!'],
      ),
    );
  }

  void handleResponseError(
    Object error,
    bool showErrorDialogue,
    Function? customErrorDialogue,
    bool skipOnError,
  ) {
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
        final Response res = Response(
          data: response.data,
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
          List<String> errors = [error.message];
          String? debug;
          if (error.response?.statusCode == 401) {
            errorCode = ApiErrorCode.unauthorized;
          }
          if (error.response?.data != null) {
            try {
              final Map<String, dynamic> response =
                  error.response?.data as Map<String, dynamic>;
              errors = response['errors'] ?? [];
              if (errors.isEmpty) {
                Console.warning('response doesn\'t contain errors key.');
              }
              debug = response['debug'];
              if (debug == null) {
                Console.warning('response doesn\'t contain debug key.');
              }
            } catch (e) {
              throw Exception(
                'Unable to parse error response.',
              );
            }
          }
          ApiErrorType apiErrorType =
              ApiErrorType(code: errorCode, errors: errors, debug: debug);
          if (apiErrorType.code == ApiErrorCode.unauthorized) {
            Console.danger('Error type: unauthorized');
            // TODO: Logout
            // Logout user from controller and then send them to login screen
            // after that show the error dialogue
          }
          if (showErrorDialogue) {
            if (customErrorDialogue != null) {
              mainDialogue(
                skip: skipOnError,
                dialogue: () => customErrorDialogue(),
              );
              return;
            }
            mainDialogue(
              skip: skipOnError,
              dialogue: () => defaultErrorDialogue(
                title: 'Error',
                content: apiErrorType.errors,
              ),
            );
          }
          return;
        }
        Console.danger(error.toString());
        rethrow;
      }
    }
  }

  void mainDialogue({required bool skip, required Function() dialogue}) async {
    if (!skip) {
      await dialogue();
      mainDialogue(
        skip: skip,
        dialogue: () => dialogue,
      );
      return;
    }
    await dialogue();
    return;
  }

  defaultSuccessDialogue({
    required String title,
    List<String>? content,
    String? hint,
    List<Widget>? actions,
  }) {
    return getx.Get.dialog(
      CupertinoAlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (content != null) Text(content.join(' ')),
              // TODO: replace with const margin
              if (content != null) const SizedBox(height: 12),
              if (hint != null) Text(hint),
            ],
          ),
        ),
        actions: <Widget>[
          if (actions == null || actions.isNotEmpty)
            CupertinoButton(
              child: const Text('Okay'),
              onPressed: () {
                getx.Get.back();
              },
            )
          else
            ...actions,
        ],
      ),
      barrierDismissible: false,
    );
  }

  defaultErrorDialogue({
    required String title,
    required List<String> content,
    List<Widget>? actions,
  }) {
    return getx.Get.dialog(
      CupertinoAlertDialog(
        title: Text(title),
        content: Text(content.join(' ')),
        actions: <Widget>[
          if (actions == null || actions.isNotEmpty)
            CupertinoButton(
              child: const Text('Okay'),
              onPressed: () {
                getx.Get.back();
              },
            )
          else
            ...actions,
        ],
      ),
      barrierDismissible: false,
    );
  }
}
