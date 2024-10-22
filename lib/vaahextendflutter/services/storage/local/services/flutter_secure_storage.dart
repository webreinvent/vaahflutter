import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../storage_error.dart';
import '../../storage_response.dart';
import 'base_service.dart';

/// A class implementing LocalStorageService interface using FLutter Secure Storage as storage
/// backend.
class LocalStorageWithFlutterSecureStorage implements LocalStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  StorageResponse add(String name) {
    return StorageResponse(errors: [
      StorageError(
        message: 'FlutterSecureStorage does not support multiple collections.',
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
    final bool hasKey = await _storage.containsKey(key: key);
    if (hasKey) {
      return StorageResponse(
        errors: [
          StorageError(
            message: 'Key "$key" already exists.',
            failedKey: key,
            stackTrace: StackTrace.current,
          ),
        ],
      );
    }
    try {
      await _storage.write(key: key, value: value);
      return StorageResponse(
        data: value,
        message: 'Entry created with key: "$key"',
      );
    } catch (e) {
      return StorageResponse(
        errors: [
          StorageError(
            message: 'Failed to create entry at key: "$key": $e',
            failedKey: key,
            stackTrace: StackTrace.current,
          ),
        ],
      );
    }
  }

  @override
  Future<StorageResponse> createMany({
    String collectionName = '',
    required Map<String, String> values,
  }) async {
    int remainingEntries = values.length;
    final List<StorageError> errors = [];
    final List<String> success = [];
    for (final String key in values.keys) {
      final StorageResponse result = await create(
        collectionName: collectionName,
        key: key,
        value: values[key]!,
      );
      if (result.hasData) {
        remainingEntries--;
        success.add(result.data);
      }
      errors.add(result.errors!.first);
    }
    if (errors.isEmpty) {
      return StorageResponse(
        data: success,
        message: 'All entries created successfully.',
      );
    } else if (remainingEntries == values.length) {
      return StorageResponse(errors: errors);
    }
    return StorageResponse(
      data: success,
      message: '${values.length - remainingEntries}/${values.length} entries created.',
      errors: errors,
    );
  }

  @override
  Future<StorageResponse> read({String collectionName = '', required String key}) async {
    final bool hasKey = await _storage.containsKey(key: key);
    if (!hasKey) {
      return StorageResponse(
        errors: [
          StorageError(
            message: 'Key "$key" does not exist.',
            failedKey: key,
            stackTrace: StackTrace.current,
          ),
        ],
      );
    }
    try {
      final String? result = await _storage.read(key: key);
      return StorageResponse(
        data: result,
        message: 'Read successful: Entry with key: "$key".',
      );
    } catch (e) {
      return StorageResponse(
        errors: [
          StorageError(
            message: 'Failed to read entry at key: "$key": $e',
            failedKey: key,
            stackTrace: StackTrace.current,
          ),
        ],
      );
    }
  }

  @override
  Future<StorageResponse> readMany({
    String collectionName = '',
    required List<String> keys,
  }) async {
    if (keys.isNotEmpty) {
      int remainingKeys = keys.length;
      final List<StorageError> errors = [];
      final Map<String, String?> data = {};
      for (final String key in keys) {
        final StorageResponse result = await read(
          collectionName: collectionName,
          key: key,
        );
        if (result.hasData) {
          data[key] = result.data;
          remainingKeys--;
        }
        errors.add(result.errors!.first);
      }
      if (errors.isEmpty) {
        return StorageResponse(data: data, message: 'Read successful.');
      } else if (remainingKeys == keys.length) {
        return StorageResponse(errors: errors);
      }
      return StorageResponse(
        data: data,
        message: 'Read ${keys.length - remainingKeys}/${keys.length}',
        errors: errors,
      );
    }
    return StorageResponse(
      errors: [
        StorageError(
          message: 'No keys provided',
          stackTrace: StackTrace.current,
        ),
      ],
    );
  }

  @override
  Future<StorageResponse> readAll({String collectionName = ''}) async {
    try {
      final Map<String, String> result = await _storage.readAll();
      return StorageResponse(data: result, message: 'Read successful.');
    } catch (e) {
      return StorageResponse(
        errors: [
          StorageError(
            message: 'Failed to read entries: $e',
            failedKey: '',
            stackTrace: StackTrace.current,
          ),
        ],
      );
    }
  }

  @override
  Future<StorageResponse> update({
    String collectionName = '',
    required String key,
    required String value,
  }) async {
    final bool hasKey = await _storage.containsKey(key: key);
    if (!hasKey) {
      return StorageResponse(
        errors: [
          StorageError(
            message: 'Key "$key" does not exist.',
            failedKey: key,
            stackTrace: StackTrace.current,
          ),
        ],
      );
    }
    try {
      await _storage.write(key: key, value: value);
      return StorageResponse(
        data: value,
        message: 'Entry updated at key: $key',
      );
    } catch (e) {
      return StorageResponse(
        errors: [
          StorageError(
            failedKey: key,
            message: 'Error while updating the entry: $e',
            stackTrace: StackTrace.current,
          ),
        ],
      );
    }
  }

  @override
  Future<StorageResponse> updateMany({
    String collectionName = '',
    required Map<String, String> values,
  }) async {
    int remainigEntries = values.length;
    final List<StorageError> errors = [];
    final List<String> success = [];
    for (final String key in values.keys) {
      final StorageResponse result = await update(
        collectionName: collectionName,
        key: key,
        value: values[key]!,
      );
      if (result.hasData) {
        remainigEntries--;
        success.add(result.data);
      }
      errors.add(result.errors!.first);
    }
    if (errors.isEmpty) {
      return StorageResponse(
        data: success,
        message: 'Updated all given entries.',
      );
    } else if (remainigEntries == values.length) {
      return StorageResponse(errors: errors);
    }
    return StorageResponse(
      data: success,
      message: 'Updated ${values.length - remainigEntries}/${values.length} entries.',
      errors: errors,
    );
  }

  @override
  Future<StorageResponse> createOrUpdate({
    String collectionName = '',
    required String key,
    required String value,
  }) async {
    final bool hasKey = await _storage.containsKey(key: key);
    if (!hasKey) {
      return create(key: key, value: value);
    }
    return update(key: key, value: value);
  }

  @override
  Future<StorageResponse> createOrUpdateMany({
    String collectionName = '',
    required Map<String, String> values,
  }) async {
    int remainigEntries = values.length;
    final List<StorageError> errors = [];
    final List<String> success = [];
    for (final String key in values.keys) {
      final StorageResponse result = await createOrUpdate(
        collectionName: collectionName,
        key: key,
        value: values[key]!,
      );
      if (result.hasData) {
        remainigEntries--;
        success.add(result.data);
      }
      errors.add(result.errors!.first);
    }
    if (errors.isEmpty) {
      return StorageResponse(data: success, message: 'Set all given entries.');
    } else if (remainigEntries == values.length) {
      return StorageResponse(errors: errors);
    }
    return StorageResponse(
      data: success,
      message: 'Set ${values.length - remainigEntries}/${values.length} entries.',
      errors: errors,
    );
  }

  @override
  Future<StorageResponse> delete({String collectionName = '', required String key}) async {
    final bool hasKey = await _storage.containsKey(key: key);
    if (!hasKey) {
      return StorageResponse(
        errors: [
          StorageError(
            message: 'Key "$key" does not exist.',
            failedKey: key,
            stackTrace: StackTrace.current,
          ),
        ],
      );
    }
    try {
      await _storage.delete(key: key);
      return StorageResponse(
        message: 'Deleted value at key: $key',
        isSuccess: true,
      );
    } catch (e) {
      return StorageResponse(
        errors: [
          StorageError(
            failedKey: key,
            message: 'Error while deleting the entry at key: "$key": $e',
            stackTrace: StackTrace.current,
          ),
        ],
      );
    }
  }

  @override
  Future<StorageResponse> deleteMany({
    String collectionName = '',
    List<String> keys = const [],
  }) async {
    if (keys.isNotEmpty) {
      int remainingKeys = keys.length;
      final List<StorageError> errors = [];
      for (final String key in keys) {
        final StorageResponse result = await delete(
          collectionName: collectionName,
          key: key,
        );
        if (result.hasData) {
          remainingKeys--;
        }
        errors.add(result.errors!.first);
      }
      if (errors.isEmpty) {
        return StorageResponse(
          message: 'Deleted multiple entries with associated keys: $keys',
          isSuccess: true,
        );
      } else if (remainingKeys == keys.length) {
        return StorageResponse(errors: errors);
      }
      return StorageResponse(
        message: 'Deleted ${keys.length - remainingKeys}/${keys.length}',
        errors: errors,
        isSuccess: true,
      );
    }
    return StorageResponse(
      errors: [
        StorageError(
          message: 'No keys provided',
          stackTrace: StackTrace.current,
        ),
      ],
    );
  }

  @override
  Future<StorageResponse> deleteAll({String collectionName = ''}) async {
    try {
      await _storage.deleteAll();
      return const StorageResponse(
        message: 'Deleted all entries.',
        isSuccess: true,
      );
    } catch (e) {
      return StorageResponse(errors: [
        StorageError(
          message: 'Delete failed: ${e.toString()}',
          stackTrace: StackTrace.current,
        )
      ]);
    }
  }
}
