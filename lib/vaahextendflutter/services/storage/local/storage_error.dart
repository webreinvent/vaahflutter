class StorageException implements Exception {
  const StorageException({
    this.key,
    required this.throwable,
    required this.stackTrace,
    this.message,
    this.batchErrors = const <String, dynamic>{},
  });

  final String? key;
  final Object throwable;
  final StackTrace stackTrace;
  final String? message;
  final Map<String, dynamic>? batchErrors;
}
