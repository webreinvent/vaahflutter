class StorageException implements Exception {
  const StorageException({
    required this.key,
    required this.throwable,
    required this.stackTrace,
  });

  final String key;
  final Object throwable;
  final StackTrace stackTrace;
}
