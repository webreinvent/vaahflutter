import '../../storage_error.dart';
import '../../storage_response.dart';
import 'base_service.dart';

class NoOpNetworkStorage implements NetworkStorageService {
  @override
  Future<StorageResponse> create({
    required String collectionName,
    required String key,
    required Map<String, dynamic> value,
  }) async {
    return StorageResponse(
      errors: [
        StorageError(
          message: 'Choose a valid Storage from firebase and supabase.',
          failedKey: 'key',
          stackTrace: StackTrace.current,
        )
      ],
    );
  }

  @override
  Future<StorageResponse> createMany({
    required String collectionName,
    required Map<String, Map<String, dynamic>> values,
  }) async {
    return StorageResponse(
      errors: [
        StorageError(
          message: 'Choose a valid Storage from firebase and supabase.',
          failedKey: 'key',
          stackTrace: StackTrace.current,
        )
      ],
    );
  }

  @override
  Future<StorageResponse> read({required String collectionName, required String key}) async {
    return StorageResponse(
      errors: [
        StorageError(
          message: 'Choose a valid Storage from firebase and supabase.',
          failedKey: 'key',
          stackTrace: StackTrace.current,
        )
      ],
    );
  }

  @override
  Future<StorageResponse> readMany({
    required String collectionName,
    required List<String> keys,
  }) async {
    return StorageResponse(
      errors: [
        StorageError(
          message: 'Choose a valid Storage from firebase and supabase.',
          failedKey: 'key',
          stackTrace: StackTrace.current,
        )
      ],
    );
  }

  @override
  Future<StorageResponse> readAll({required String collectionName}) async {
    return StorageResponse(
      errors: [
        StorageError(
          message: 'Choose a valid Storage from firebase and supabase.',
          failedKey: 'key',
          stackTrace: StackTrace.current,
        )
      ],
    );
  }

  @override
  Future<StorageResponse> update({
    required String collectionName,
    required String key,
    required Map<String, dynamic> value,
  }) async {
    return StorageResponse(
      errors: [
        StorageError(
          message: 'Choose a valid Storage from firebase and supabase.',
          failedKey: 'key',
          stackTrace: StackTrace.current,
        )
      ],
    );
  }

  @override
  Future<StorageResponse> updateMany({
    required String collectionName,
    required Map<String, Map<String, dynamic>> values,
  }) async {
    return StorageResponse(
      errors: [
        StorageError(
          message: 'Choose a valid Storage from firebase and supabase.',
          failedKey: 'key',
          stackTrace: StackTrace.current,
        )
      ],
    );
  }

  @override
  Future<StorageResponse> createOrUpdate({
    required String collectionName,
    required String key,
    required Map<String, dynamic> value,
  }) async {
    return StorageResponse(
      errors: [
        StorageError(
          message: 'Choose a valid Storage from firebase and supabase.',
          failedKey: 'key',
          stackTrace: StackTrace.current,
        )
      ],
    );
  }

  @override
  Future<StorageResponse> createOrUpdateMany({
    required String collectionName,
    required Map<String, Map<String, dynamic>> values,
  }) async {
    return StorageResponse(
      errors: [
        StorageError(
          message: 'Choose a valid Storage from firebase and supabase.',
          failedKey: 'key',
          stackTrace: StackTrace.current,
        )
      ],
    );
  }

  @override
  Future<StorageResponse> delete({required String collectionName, required String key}) async {
    return StorageResponse(
      errors: [
        StorageError(
          message: 'Choose a valid Storage from firebase and supabase.',
          failedKey: 'key',
          stackTrace: StackTrace.current,
        )
      ],
    );
  }

  @override
  Future<StorageResponse> deleteMany({
    required String collectionName,
    required List<String> keys,
  }) async {
    return StorageResponse(
      errors: [
        StorageError(
          message: 'Choose a valid Storage from firebase and supabase.',
          failedKey: 'key',
          stackTrace: StackTrace.current,
        )
      ],
    );
  }

  @override
  Future<StorageResponse> deleteAll({required String collectionName}) async {
    return StorageResponse(
      errors: [
        StorageError(
          message: 'Choose a valid Storage from firebase and supabase.',
          failedKey: 'key',
          stackTrace: StackTrace.current,
        )
      ],
    );
  }
}
