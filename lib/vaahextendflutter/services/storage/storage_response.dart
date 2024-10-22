import 'storage_error.dart';

/// A class to handle all the responses from the Local and Network Storages.
///
/// * [data] will hold data accordingly.
///
/// * [message] will hold message according to the status, null in case of complete failure.
///
/// * [errors] will hold the [StorageError]s.
///
/// * [hasData] true when [data] != null.
///
/// * [hasError] true when [errors] != null.
///
/// * [isSuccess] will be true on success.
///
class StorageResponse {
  final dynamic data;
  final String? message;
  final List<StorageError>? errors;
  final bool _isSuccess;

  const StorageResponse({
    this.data,
    this.message,
    this.errors,
    bool isSuccess = false,
  }) : _isSuccess = isSuccess;

  bool get hasData => data != null;
  bool get hasError => errors != null;
  bool get isSuccess {
    return hasData || _isSuccess;
  }

  @override
  String toString() {
    if (hasData && hasError) {
      return 'PartialSuccess(successData: $data, successMessage: $message, errors: $errors)';
    } else if (isSuccess) {
      return 'Success(data: $data, message: $message)';
    } else {
      return 'Failure(errors: $errors)';
    }
  }
}
