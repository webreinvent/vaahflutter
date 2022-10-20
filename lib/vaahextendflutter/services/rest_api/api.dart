import 'dart:async';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as getx;

import '../../log/console.dart';
import 'models/api_error_type.dart';
import '../../../env.dart';

// alertType : 'dialog', 'toast',

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
  Future<void> ajax<T>({
    required String url,
    Future<void> Function(dynamic data, Response<dynamic>? res)? callback,
    String method = 'get',
    Map<String, dynamic>?
        params, // eg: { 'name': 'abc' }. params is data passed in post, put, etc. requests.
    Map<String, dynamic>? query, // eg: { 'name': 'abc' }
    List<Map<String, String>>?
        headers, // eg: [{'title': 'content'}, {'key', 'value'}]
    int? customTimeoutLimit,
    bool showAlert =
        true, // if set false then on success or error, nothing will be shown
    String alertType = 'toast', // 'toast' and 'dialog' are valid values
    Future<void> Function()? showSuccessToast,
    Future<void> Function()? showErrorToast,
    Future<void> Function()? showSuccessDialog,
    Future<void> Function()? showErrorDialog,
    Future<void> Function()? onStart,
    Future<void> Function()? onCompleted,
    Future<void> Function(dynamic error)? onError,
    Future<void> Function()? onFinally,
  }) async {
    try {
      // On Start, use for show loading
      if (onStart != null) {
        await onStart();
      }

      Response<dynamic>? response = await handleRequest(
        url: url,
        method: method,
        query: query,
        params: params,
        headers: headers,
        customTimeoutLimit: customTimeoutLimit,
        showAlert: showAlert,
        alertType: alertType,
        showErrorDialog: showErrorDialog,
        showErrorToast: showErrorToast,
      );

      dynamic responseData = await handleResponse(
        response,
        showAlert,
        alertType,
        showSuccessDialog,
        showSuccessToast,
      );

      // On completed, use for hide loading
      if (onCompleted != null) {
        await onCompleted();
      }

      if (callback != null) {
        await callback(responseData, response);
      }

      return;
    } catch (error) {
      // On completed, use for hide loading
      if (onCompleted != null) {
        await onCompleted();
      }

      // On inline error
      if (onError != null) {
        await onError(error);
      }

      // All errors other than dio error eg. typeError
      if (error is! DioError) {
        if (callback != null) {
          await callback(null, null);
        }
        rethrow;
      }

      // Timeout Error
      else if (error.type == DioErrorType.sendTimeout ||
          error.type == DioErrorType.receiveTimeout) {
        await handleTimeoutError(
          error,
          showAlert,
          alertType,
          showErrorToast,
          showErrorDialog,
        );
        if (callback != null) {
          await callback(null, null);
        }
        return;
      }

      // Here response error means server sends error response. eg 401: unauthorised
      else if (error.type == DioErrorType.response) {
        await handleResponseError(
          error,
          showAlert,
          alertType,
          showErrorToast,
          showErrorDialog,
        );
        if (callback != null) {
          await callback(null, null);
        }
        return;
      }
      if (callback != null) {
        await callback(null, null);
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
    required String method,
    required String url,
    required Map<String, dynamic>? query,
    required Map<String, dynamic>? params,
    required List<Map<String, String>>? headers,
    required int? customTimeoutLimit,
    required bool showAlert,
    required String alertType,
    required Future<void> Function()? showErrorDialog,
    required Future<void> Function()? showErrorToast,
  }) async {
    Response? response;
    final Options options = await _getOptions();
    options.sendTimeout =
        customTimeoutLimit ?? envController.config.timeoutLimit;
    options.receiveTimeout =
        customTimeoutLimit ?? envController.config.timeoutLimit;
    if (headers != null && headers.isNotEmpty) {
      if (options.headers != null) {
        for (Map<String, String> element in headers) {
          options.headers?.addAll(element);
        }
      } else {
        final Map<String, String> customHeader = <String, String>{};
        for (Map<String, String> element in headers) {
          customHeader.addAll(element);
        }
        options.headers = customHeader;
      }
    }
    switch (method) {
      case 'get':
        response = await dio.get<dynamic>(
          '$apiBaseUrl$url',
          queryParameters: query,
          options: options,
        );
        break;

      case 'post':
        response = await dio.post<dynamic>(
          '$apiBaseUrl$url',
          data: params,
          queryParameters: query,
          options: options,
        );
        break;

      case 'put':
        response = await dio.put<dynamic>(
          '$apiBaseUrl$url',
          data: params,
          queryParameters: query,
          options: options,
        );
        break;

      case 'patch':
        response = await dio.patch<dynamic>(
          '$apiBaseUrl$url',
          data: params,
          queryParameters: query,
          options: options,
        );
        break;

      case 'delete':
        response = await dio.delete<dynamic>(
          '$apiBaseUrl$url',
          data: params,
          queryParameters: query,
          options: options,
        );
        break;

      default:
        if (showAlert) {
          if (alertType == 'dialog') {
            if (showErrorDialog != null) {
              await showErrorDialog();
              break;
            }
            showDialog(
              title: 'Error',
              content: ['Invalid request type!'],
            );
            break;
          } else {
            if (showErrorToast != null) {
              await showErrorToast();
              break;
            }
            showToast(content: 'Invalid request type!', toastType: 'failure');
            break;
          }
        }
    }
    return response;
  }

  Future<dynamic> handleResponse(
    Response<dynamic>? response,
    bool showAlert,
    String alertType,
    Future<void> Function()? showSuccessDialog,
    Future<void> Function()? showSuccessToast,
  ) async {
    if (response != null && response.data != null) {
      try {
        final Map<String, dynamic> formatedResponse =
            response.data as Map<String, dynamic>;
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
        if (showAlert) {
          if (alertType == 'dialog') {
            if (showSuccessDialog != null) {
              await showSuccessDialog();
            } else {
              showDialog(
                title: 'Success',
                content: responseMessages,
              );
            }
          } else {
            if (showSuccessToast != null) {
              await showSuccessToast();
            } else {
              showToast(
                content: responseMessages?.join(' ') ?? 'Successful',
                toastType: 'success',
              );
            }
          }
        }
        return responseData;
      } catch (e) {
        rethrow;
      }
    }
    throw Exception('response from server is null or response.data is null');
  }

  Future<void> handleTimeoutError(
    DioError error,
    bool showAlert,
    String alertType,
    Future<void> Function()? showErrorToast,
    Future<void> Function()? showErrorDialog,
  ) async {
    Console.danger(error.toString());
    if (showAlert) {
      if (alertType == 'dialog') {
        if (showErrorDialog != null) {
          await showErrorDialog();
          return;
        }
        showDialog(
          title: 'Error',
          content: ['Check your internet connection!'],
        );
      } else {
        if (showErrorToast != null) {
          await showErrorToast();
          return;
        }
        showToast(
          content: 'Check your internet connection!',
          toastType: 'failure',
        );
      }
    }
  }

  Future<void> handleResponseError(
    Object error,
    bool showAlert,
    String alertType,
    Future<void> Function()? showErrorToast,
    Future<void> Function()? showErrorDialog,
  ) async {
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
            // after that show the error dialog
          }
          if (showAlert) {
            if (alertType == 'dialog') {
              if (showErrorDialog != null) {
                await showErrorDialog();
                return;
              }
              Console.danger(apiErrorType.errors.toString());
              showDialog(
                title: 'Error',
                content: apiErrorType.errors,
              );
            } else {
              if (showErrorToast != null) {
                await showErrorToast();
                return;
              }
              showToast(
                content: apiErrorType.errors.isEmpty
                    ? 'Error'
                    : apiErrorType.errors.join(' '),
                toastType: 'failure',
              );
            }
          }
          return;
        }
        Console.danger(error.toString());
        rethrow;
      }
    }
  }

  void showToast({
    required String content,
    toastType = 'default',
  }) {
    switch (toastType) {
      case 'success':
        defaultToast(content, Colors.green);
        break;
      case 'failure':
        defaultToast(content, Colors.red);
        break;
      default:
        defaultToast(content, Colors.white);
        break;
    }
  }

  void defaultToast(String content, Color color) {
    Fluttertoast.showToast(
      msg: content,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: color.withOpacity(0.5),
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }

  showDialog({
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
              if (content != null && content.isNotEmpty) Text(content.join(' ')),
              // TODO: replace with const margin
              if (content != null && content.isNotEmpty) const SizedBox(height: 12),
              if (hint != null && hint.trim().isNotEmpty) Text(hint),
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
}
