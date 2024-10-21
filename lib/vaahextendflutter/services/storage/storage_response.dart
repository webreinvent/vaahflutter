import 'storage_error.dart';

/// A class to handle all the responses from the Local and Network Storages.
///
/// * [data] will hold data accordingly.
///
/// * [message] will hold message according to the status, empty in case of complete failure.
///
/// * [errors] will hold the [StorageError]s.
///
/// * [hasData] true when [data] != null.
///
/// * [hasError] true when [errors] != null.
///
/// * [isSuccess] will be true on success.
///
/// * [isPartialSuccess] will be true on partial success.
///
/// * Both [isSuccess] and [isPartialSuccess] will be false on
/// complete failure.
///
class StorageResponse {
  final dynamic _data;
  final String _message;
  final List<StorageError>? _errors;
  final bool _isSuccess;
  final bool _isPartialSuccess;
  const StorageResponse({
    dynamic data,
    String message = '',
    List<StorageError>? errors,
    bool isSuccess = false,
    bool isPartialSuccess = false,
  })  : _data = data,
        _message = message,
        _errors = errors,
        _isSuccess = isSuccess,
        _isPartialSuccess = isPartialSuccess;

  dynamic get data => _data;
  String get message => _message;
  List<StorageError>? get errors => _errors;
  bool get hasData => data != null;
  bool get hasError => errors != null;
  bool get isSuccess => _isSuccess;
  bool get isPartialSuccess => _isPartialSuccess;

  @override
  String toString() {
    if (_isSuccess) {
      return 'Success(data: $_data, message: $_message)';
    } else if (_isPartialSuccess) {
      return 'PartialSuccess(successData: $_data, successMessage: $_message, errors: $_errors)';
    } else {
      return 'Failure(errors: $_errors)';
    }
  }
}
