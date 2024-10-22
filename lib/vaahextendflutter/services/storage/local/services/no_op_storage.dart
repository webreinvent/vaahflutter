import '../../storage_error.dart';
import '../../storage_response.dart';
import 'base_service.dart';

/// A placeholder storage class when [LocalStorageType.none] is selected in env.dart.
class NoOpStorage implements LocalStorageService {
  @override
  StorageResponse add(String name) {
    return StorageResponse(errors: [
      StorageError(
        message: 'Choose a valid Storage from hive and FlutterSecureStorage',
        failedKey: name,
        stackTrace: StackTrace.current,
      ),
    ]);
  }

  @override
  Future<StorageResponse> create({
    String collectionName = '',
    required String key,
    required String value,
  }) async {
    return StorageResponse(
      errors: [
        StorageError(
          message: 'Choose a valid Storage from hive and FlutterSecureStorage',
          failedKey: key,
          stackTrace: StackTrace.current,
        ),
      ],
    );
  }

  @override
  Future<StorageResponse> createMany({
    String collectionName = '',
    required Map<String, String> values,
  }) async {
    return StorageResponse(
      errors: [
        StorageError(
          message: 'Choose a valid Storage from hive and FlutterSecureStorage',
          failedKey: 'key',
          stackTrace: StackTrace.current,
        ),
      ],
    );
  }

  @override
  Future<StorageResponse> read({String collectionName = '', required String key}) async {
    return StorageResponse(
      errors: [
        StorageError(
          message: 'Choose a valid Storage from hive and FlutterSecureStorage',
          failedKey: 'key',
          stackTrace: StackTrace.current,
        ),
      ],
    );
  }

  @override
  Future<StorageResponse> readMany({
    String collectionName = '',
    required List<String> keys,
  }) async {
    return StorageResponse(
      errors: [
        StorageError(
          message: 'Choose a valid Storage from hive and FlutterSecureStorage',
          failedKey: 'key',
          stackTrace: StackTrace.current,
        ),
      ],
    );
  }

  @override
  Future<StorageResponse> readAll({
    String collectionName = '',
    int start = 1,
    int itemsPerPage = 10,
  }) async {
    return StorageResponse(
      errors: [
        StorageError(
          message: 'Choose a valid Storage from hive and FlutterSecureStorage',
          failedKey: 'key',
          stackTrace: StackTrace.current,
        ),
      ],
    );
  }

  @override
  Future<StorageResponse> update({
    String collectionName = '',
    required String key,
    required String value,
  }) async {
    return StorageResponse(
      errors: [
        StorageError(
          message: 'Choose a valid Storage from hive and FlutterSecureStorage',
          failedKey: '',
          stackTrace: StackTrace.current,
        ),
      ],
    );
  }

  @override
  Future<StorageResponse> updateMany({
    String collectionName = '',
    required Map<String, String> values,
  }) async {
    return StorageResponse(
      errors: [
        StorageError(
          message: 'Choose a valid Storage from hive and FlutterSecureStorage',
          failedKey: '',
          stackTrace: StackTrace.current,
        ),
      ],
    );
  }

  @override
  Future<StorageResponse> createOrUpdate({
    String collectionName = '',
    required String key,
    required String value,
  }) async {
    return StorageResponse(
      errors: [
        StorageError(
          message: 'Choose a valid Storage from hive and FlutterSecureStorage',
          failedKey: '',
          stackTrace: StackTrace.current,
        ),
      ],
    );
  }

  @override
  Future<StorageResponse> createOrUpdateMany({
    String collectionName = '',
    required Map<String, String> values,
  }) async {
    return StorageResponse(
      errors: [
        StorageError(
          message: 'Choose a valid Storage from hive and FlutterSecureStorage',
          failedKey: '',
          stackTrace: StackTrace.current,
        ),
      ],
    );
  }

  @override
  Future<StorageResponse> delete({String collectionName = '', required String key}) async {
    return StorageResponse(
      errors: [
        StorageError(
          message: 'Choose a valid Storage from hive and FlutterSecureStorage',
          failedKey: '',
          stackTrace: StackTrace.current,
        ),
      ],
    );
  }

  @override
  Future<StorageResponse> deleteMany({
    String collectionName = '',
    List<String> keys = const [],
  }) async {
    return StorageResponse(
      errors: [
        StorageError(
          message: 'Choose a valid Storage from hive and FlutterSecureStorage',
          failedKey: '',
          stackTrace: StackTrace.current,
        ),
      ],
    );
  }

  @override
  Future<StorageResponse> deleteAll({String collectionName = ''}) async {
    return StorageResponse(
      errors: [
        StorageError(
          message: 'Choose a valid Storage from hive and FlutterSecureStorage',
          failedKey: '',
          stackTrace: StackTrace.current,
        ),
      ],
    );
  }
}
