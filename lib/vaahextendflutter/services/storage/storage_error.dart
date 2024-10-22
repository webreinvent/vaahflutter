class StorageError {
  final String message;
  final String? failedKey;
  final StackTrace stackTrace;
  StorageError({
    required this.message,
    this.failedKey,
    required this.stackTrace,
  });

  @override
  String toString() =>
      'StorageError{message: $message, failedKey: $failedKey, stacktrace: $stackTrace}';
}
