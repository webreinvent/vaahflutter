import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as getx;

import '../../../env.dart';
import '../../app_theme.dart';
import '../helpers/console.dart';
import '../helpers/constants.dart';
import '../helpers/helpers.dart';

// alertType : 'dialog', 'toast',

class Api {
  // To check  env variables logs enabled, apiUrl and timeout limit for requests
  static late final EnvController _envController;

  // Get base url by env
  static late final String _apiBaseUrl;
  static final Dio _dio = Dio();

  // Get request header options
  static Future<Options> _getOptions(
      {String contentType = Headers.jsonContentType}) async {
    final Map<String, String> header = <String, String>{};
    header.addAll(<String, String>{'Accept': 'application/json'});
    header.addAll(<String, String>{'X-Requested-With': 'XMLHttpRequest'});
    return Options(headers: header, contentType: contentType);
  }

  static dynamic _parseKeys({
    required dynamic data,
    required Function changeKeys,
  }) {
    if (data is List) {
      dynamic parsedData = [];
      for (var e in data) {
        parsedData.add(_parseKeys(data: e, changeKeys: changeKeys));
      }
      return parsedData;
    } else if (data is Map) {
      Map<String, dynamic> parsedData = {};
      data.forEach(
        (key, value) {
          dynamic parsedvalue = _parseKeys(data: value, changeKeys: changeKeys);
          parsedData.addAll({
            changeKeys(key): parsedvalue,
          });
        },
      );
      return parsedData;
    }
    return data;
  }

  static String _lowerCamelCaseToSnakeCase(String data) {
    List<String> parts = data.split(RegExp(r"(?=(?!^)[A-Z])"));
    String result = parts.join('_');
    return result.toLowerCase();
  }

  static String _snakeCasetoLowerCamelCase(String data) {
    List<String> sentence = data.split('_');
    sentence.removeWhere((element) => element.isEmpty);
    String result = '';
    for (var e in sentence) {
      result += e[0].toUpperCase() + e.substring(1);
    }
    if (result.isEmpty) {
      return data;
    }
    if (result[0].isAlphabetOnly) {
      result = result[0].toLowerCase() + result.substring(1);
    }
    return result;
  }

  // return type of ajax is ApiResponseType? so if there is error
  // then null will be returned otherwise ApiResponseType object
  static Future<void> ajax<T>({
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

      Response<dynamic>? response = await _handleRequest(
        url: url,
        method: method,
        query: query,
        params: params,
        headers: headers,
        customTimeoutLimit: customTimeoutLimit,
        showAlert: showAlert,
        alertType: alertType,
      );

      dynamic responseData = await _handleResponse(
        response,
        showAlert,
        alertType,
      );

      // On completed, use for hide loading
      if (onCompleted != null) {
        await onCompleted();
      }

      if (callback != null) {
        await callback(
          _parseKeys(
            data: responseData,
            changeKeys: _snakeCasetoLowerCamelCase,
          ),
          response,
        );
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
        await _handleTimeoutError(
          error,
          showAlert,
          alertType,
        );
        if (callback != null) {
          await callback(null, null);
        }
        return;
      }

      // Here response error means server sends error response. eg 401: unauthorised
      else if (error.type == DioErrorType.response) {
        await _handleResponseError(
          error,
          showAlert,
          alertType,
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

  static Future<void> initApi() async {
    bool envControllerExists = getx.Get.isRegistered<EnvController>();
    if (!envControllerExists) {
      throw Exception('envController does not exist in app');
    }
    // get env controller and set variable showEnvAndVersionTag
    _envController = getx.Get.find<EnvController>();
    _apiBaseUrl = _envController.config.apiUrl;
    if (_envController.config.enableApiLogs) {
      _dio.interceptors.add(
        LogInterceptor(
          responseBody: true,
          requestBody: true,
        ),
      );
    }
  }

  static Future<Response<dynamic>?> _handleRequest({
    required String method,
    required String url,
    required Map<String, dynamic>? query,
    required Map<String, dynamic>? params,
    required List<Map<String, String>>? headers,
    required int? customTimeoutLimit,
    required bool showAlert,
    required String alertType,
  }) async {
    Response? response;
    final Options options = await _getOptions();
    options.sendTimeout =
        customTimeoutLimit ?? _envController.config.timeoutLimit;
    options.receiveTimeout =
        customTimeoutLimit ?? _envController.config.timeoutLimit;
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
    String encodedData = jsonEncode(
      _parseKeys(
        data: params,
        changeKeys: _lowerCamelCaseToSnakeCase,
      ),
    );
    switch (method) {
      case 'get':
        response = await _dio.get<dynamic>(
          '$_apiBaseUrl$url',
          queryParameters: query,
          options: options,
        );
        break;

      case 'post':
        response = await _dio.post<dynamic>(
          '$_apiBaseUrl$url',
          data: encodedData,
          queryParameters: query,
          options: options,
        );
        break;

      case 'put':
        response = await _dio.put<dynamic>(
          '$_apiBaseUrl$url',
          data: encodedData,
          queryParameters: query,
          options: options,
        );
        break;

      case 'patch':
        response = await _dio.patch<dynamic>(
          '$_apiBaseUrl$url',
          data: encodedData,
          queryParameters: query,
          options: options,
        );
        break;

      case 'delete':
        response = await _dio.delete<dynamic>(
          '$_apiBaseUrl$url',
          data: encodedData,
          queryParameters: query,
          options: options,
        );
        break;

      default:
        if (showAlert) {
          if (alertType == 'dialog') {
            // ignore: unnecessary_null_comparison
            if (Helpers.showErrorDialog != null) {
              await Helpers.showErrorDialog(
                title: 'Error',
                content: ['Invalid request type!'],
                hint:
                    "get, post, put, patch, delete request types are allowed.",
              );
              break;
            }
            _showDialog(
              title: 'Error',
              content: ['Invalid request type!'],
              hint: "get, post, put, patch, delete request types are allowed.",
            );
            break;
          } else {
            // ignore: unnecessary_null_comparison
            if (Helpers.showErrorToast != null) {
              await Helpers.showErrorToast(content: 'Invalid request type!');
              break;
            }
            _showToast(
              content: 'ERR: Invalid request type!',
              color: AppTheme.colors['danger']!,
            );
            break;
          }
        }
    }
    return response;
  }

  static Future<dynamic> _handleResponse(
    Response<dynamic>? response,
    bool showAlert,
    String alertType,
  ) async {
    if (response != null && response.data != null) {
      try {
        final Map<String, dynamic> formatedResponse =
            response.data as Map<String, dynamic>;
        dynamic responseData = formatedResponse['data'];
        if (responseData == null) {
          Console.warning('response doesn\'t contain data key.');
        }
        List<String>? responseMessages;
        if (formatedResponse['messages'] == null) {
          Console.warning('response doesn\'t contain messages key.');
        } else {
          responseMessages = (formatedResponse['messages'] as List<dynamic>)
              .map((e) => e.toString())
              .toList();
        }
        String? responseHint = formatedResponse['hint'] as String?;
        if (responseHint == null) {
          Console.warning('response doesn\'t contain hint key.');
        }
        if (showAlert) {
          if (alertType == 'dialog') {
            // ignore: unnecessary_null_comparison
            if (Helpers.showSuccessDialog != null) {
              await Helpers.showSuccessDialog(
                title: 'Success',
                content: responseMessages,
                hint: responseHint,
              );
            } else {
              _showDialog(
                title: 'Success',
                content: responseMessages,
                hint: responseHint,
              );
            }
          } else {
            // ignore: unnecessary_null_comparison
            if (Helpers.showSuccessToast != null) {
              await Helpers.showSuccessToast(
                content: responseMessages?.join('\n') ?? 'Successful',
              );
            } else {
              _showToast(
                content: responseMessages?.join('\n') ?? 'Successful',
                color: AppTheme.colors['success']!,
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

  static Future<void> _handleTimeoutError(
    DioError error,
    bool showAlert,
    String alertType,
  ) async {
    Console.danger(error.toString());
    if (showAlert) {
      if (alertType == 'dialog') {
        // ignore: unnecessary_null_comparison
        if (Helpers.showErrorDialog != null) {
          await Helpers.showErrorDialog(
            title: 'Error',
            content: ['Check your internet connection!'],
          );
          return;
        }
        _showDialog(
          title: 'Error',
          content: ['Check your internet connection!'],
        );
      } else {
        // ignore: unnecessary_null_comparison
        if (Helpers.showErrorToast != null) {
          await Helpers.showErrorToast(
            content: 'ERR: Check your internet connection!',
          );
          return;
        }
        _showToast(
          content: 'ERR: Check your internet connection!',
          color: AppTheme.colors['success']!,
        );
      }
    }
  }

  static Future<void> _handleResponseError(
    Object error,
    bool showAlert,
    String alertType,
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
          String errorCode = 'unknown';
          List<String> errors = [error.message];
          String? debug;
          if (error.response?.statusCode == 401) {
            errorCode = 'unauthorized';
          }
          if (error.response?.data != null) {
            try {
              Console.danger('${error.response}');
              final Map<String, dynamic> response =
                  error.response?.data as Map<String, dynamic>;
              Console.danger('$response');
              if (response['errors'] != null) {
                errors = (response['errors'] as List<dynamic>)
                    .map((e) => e.toString())
                    .toList();
              }
              if (errors.isEmpty) {
                Console.warning('response doesn\'t contain errors key.');
              }
              debug = response['debug'] as String?;
              if (debug == null) {
                Console.warning('response doesn\'t contain debug key.');
              }
            } catch (e) {
              throw Exception(
                'Unable to parse error response.',
              );
            }
          }
          if (errorCode == 'unauthorized') {
            Console.danger('Error type: unauthorized');
            Helpers.logout();
          }
          if (showAlert) {
            if (alertType == 'dialog') {
              // ignore: unnecessary_null_comparison
              if (Helpers.showErrorDialog != null) {
                await Helpers.showErrorDialog(
                  title: 'Error',
                  content: errors,
                  hint: debug,
                );
                return;
              }
              Console.danger(errors.toString());
              _showDialog(
                title: 'Error',
                content: errors,
                hint: debug,
              );
            } else {
              // ignore: unnecessary_null_comparison
              if (Helpers.showErrorToast != null) {
                await Helpers.showErrorToast(
                  content:
                      errors.isEmpty ? 'Error' : 'ERR: ${errors.join('\n')}',
                );
                return;
              }
              _showToast(
                content: errors.isEmpty ? 'Error' : 'ERR: ${errors.join('\n')}',
                color: AppTheme.colors['success']!,
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

  static void _showToast({
    required String content,
    Color color = Colors.white,
  }) {
    Fluttertoast.showToast(
      msg: content,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: color.withOpacity(0.5),
      textColor: color == AppTheme.colors['white']
          ? AppTheme.colors['black']
          : AppTheme.colors['whiteColor'],
      fontSize: 16.0,
    );
  }

  static _showDialog({
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
              if (content != null && content.isNotEmpty)
                Text(content.join('\n')),
              if (content != null && content.isNotEmpty) verticalMargin12,
              if (hint != null && hint.trim().isNotEmpty) Text(hint),
            ],
          ),
        ),
        actions: <Widget>[
          if (actions == null || actions.isNotEmpty)
            CupertinoButton(
              child: const Text('Ok'),
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
