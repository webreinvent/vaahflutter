import 'dart:core';

class BaseResponse<T> {
  BaseResponse(
    Map<String, dynamic>? fullJson, {
    String? dataKey,
    String errorKey = 'error',
  }) {
    parsing(fullJson, dataKey: dataKey, errorKey: errorKey);
  }

  T? data;
  late bool success;
  late String error;
  late String message;

  // Abstract json to data
  T? jsonToData(dynamic dataJson) {
    return null;
  }

  // Abstract data to json
  dynamic dataToJson(T? data) {
    return null;
  }

  // Parsing data to object
  // dataKey = null mean parse from root
  dynamic parsing(
    Map<String, dynamic>? fullJson, {
    String? dataKey,
    String errorKey = 'error',
  }) {
    if (fullJson != null) {
      final dynamic dataJson =
          dataKey != null ? fullJson[dataKey] : fullJson['data'];
      data = dataJson != null ? jsonToData(dataJson) : null;
      success = fullJson['success'] as bool;
      error = fullJson[errorKey] as String;
      message = fullJson['message'] as String;
    }
  }

  // Data to json
  Map<String, dynamic> toJson() => <String, dynamic>{
        'data': data != null ? dataToJson(data) : null,
        'success': success,
        'message': message,
        'error': error,
      };

  @override
  String toString() {
    return 'BaseResponse{data: $data, success:$success, message: $message, error: $error}';
  }
}
