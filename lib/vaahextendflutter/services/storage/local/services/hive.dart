import 'package:hive/hive.dart';

import '../../storage_error.dart';
import '../../storage_response.dart';
import 'base_service.dart';

/// A class implementing LocalStorageService interface using Hive as storage backend.
class LocalStorageWithHive implements LocalStorageService {
  final Map<String, Future<Box>> _collections = {
    'vaah-flutter-box': Hive.openBox('vaah-flutter-box'),
  };

  @override
  StorageResponse add(String collectionName) {
    if (!_collections.containsKey(collectionName)) {
      _collections[collectionName] = Hive.openBox(collectionName);
      return StorageResponse(
        data: _collections[collectionName],
        message: 'Collection created with :$collectionName.',
      );
    }
    return StorageResponse(errors: [
      StorageError(
        message: 'Collection $collectionName already exists.',
        failedKey: '',
        stackTrace: StackTrace.current,
      ),
    ]);
  }

  @override
  Future<StorageResponse> create({
    required String collectionName,
    required String key,
    required String value,
  }) async {
    if (!_collections.containsKey(collectionName)) {
      return StorageResponse(
        errors: [
          StorageError(
            message: 'Collection "$collectionName" not found.',
            failedKey: key,
            stackTrace: StackTrace.current,
          ),
        ],
      );
    }
    final Box box = await _collections[collectionName]!;
    if (box.containsKey(key)) {
      return StorageResponse(
        errors: [
          StorageError(
            message: 'Key "$key" already exists in collection "$collectionName".',
            failedKey: key,
            stackTrace: StackTrace.current,
          ),
        ],
      );
    }
    try {
      await box.put(key, value); // main operation
      return StorageResponse(
        data: value,
        message: 'Entry created with key: $key in collection $collectionName.',
      );
    } catch (e) {
      return StorageResponse(
        errors: [
          StorageError(
            message: 'Error while creating entry to the box "$collectionName" at key: $key: $e',
            failedKey: key,
            stackTrace: StackTrace.current,
          ),
        ],
      );
    }
  }

  @override
  Future<StorageResponse> createMany({
    required String collectionName,
    required Map<String, String> values,
  }) async {
    int totalEntries = values.length;
    final List<StorageError> errors = [];
    final List<String> success = [];
    for (final String key in values.keys) {
      final StorageResponse result = await create(
        collectionName: collectionName,
        key: key,
        value: values[key]!,
      );
      if (result.hasData) {
        totalEntries--;
        success.add(result.data);
      }
      errors.add(result.errors!.first);
    }
    if (errors.isEmpty) {
      return StorageResponse(
        data: success,
        message: 'All entries created successfully.',
      );
    } else if (totalEntries == values.length) {
      return StorageResponse(errors: errors);
    }
    return StorageResponse(
      data: success,
      message: '${values.length - totalEntries}/${values.length} entries created.',
      errors: errors,
    );
  }

  @override
  Future<StorageResponse> read({
    required String collectionName,
    required String key,
  }) async {
    if (!_collections.containsKey(collectionName)) {
      return StorageResponse(
        errors: [
          StorageError(
            message: 'Collection "$collectionName" not found.',
            failedKey: key,
            stackTrace: StackTrace.current,
          ),
        ],
      );
    }
    final Box box = await _collections[collectionName]!;
    if (!box.containsKey(key)) {
      return StorageResponse(
        errors: [
          StorageError(
            message: 'Key "$key" does not exist in collection "$collectionName".',
            failedKey: key,
            stackTrace: StackTrace.current,
          ),
        ],
      );
    }
    try {
      final String? result = box.get(key);
      return StorageResponse(
        data: result,
        message: 'Read successful: Entry with key: "$key" in collection: "$collectionName".',
      );
    } catch (e) {
      StorageError error = StorageError(
        message: 'Error while reading data from the box "$collectionName" at key: "$key": $e',
        failedKey: key,
        stackTrace: StackTrace.current,
      );
      return StorageResponse(errors: [error]);
    }
  }

  @override
  Future<StorageResponse> readMany({
    required String collectionName,
    required List<String> keys,
  }) async {
    if (keys.isNotEmpty) {
      int remainingKeys = keys.length;
      final List<StorageError> errors = [];
      final Map<String, String?> success = {};
      for (final String key in keys) {
        final StorageResponse result = await read(collectionName: collectionName, key: key);
        if (result.hasData) {
          success[key] = result.data;
          remainingKeys--;
        }
        errors.add(result.errors!.first);
      }
      if (errors.isEmpty) {
        return StorageResponse(data: success, message: 'Read successful.');
      } else if (remainingKeys == keys.length) {
        return StorageResponse(errors: errors);
      }
      return StorageResponse(
        data: success,
        message: 'Read ${keys.length - remainingKeys}/${keys.length}.',
        errors: errors,
      );
    }
    return StorageResponse(
      errors: [
        StorageError(
          message: 'No keys provided',
          failedKey: '',
          stackTrace: StackTrace.current,
        ),
      ],
    );
  }

  @override
  Future<StorageResponse> readAll({required String collectionName}) async {
    if (!_collections.containsKey(collectionName)) {
      return StorageResponse(
        errors: [
          StorageError(
            message: 'Collection "$collectionName" not found.',
            failedKey: '',
            stackTrace: StackTrace.current,
          ),
        ],
      );
    }
    try {
      final Box box = await _collections[collectionName]!;
      final Map<String, String> result = box.toMap().map(
            (key, value) => MapEntry(
              key.toString(),
              value.toString(),
            ),
          );
      return StorageResponse(
        data: result,
        message: result.isEmpty ? 'No data found' : 'Read all successfull.',
      );
    } catch (e) {
      return StorageResponse(
        errors: [
          StorageError(
            message: 'Error reading all data: $e',
            failedKey: '',
            stackTrace: StackTrace.current,
          ),
        ],
      );
    }
  }

  @override
  Future<StorageResponse> update({
    required String collectionName,
    required String key,
    required String value,
  }) async {
    if (!_collections.containsKey(collectionName)) {
      return StorageResponse(
        errors: [
          StorageError(
            message: 'Collection "$collectionName" not found.',
            failedKey: key,
            stackTrace: StackTrace.current,
          ),
        ],
      );
    }
    final Box box = await _collections[collectionName]!;
    if (!box.containsKey(key)) {
      return StorageResponse(
        errors: [
          StorageError(
            message: 'Key "$key" does not exist in collection "$collectionName"',
            failedKey: key,
            stackTrace: StackTrace.current,
          ),
        ],
      );
    }
    try {
      await box.put(key, value);
      return StorageResponse(data: value, message: 'Entry updated at key: $key');
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
    required String collectionName,
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
      return StorageResponse(data: success, message: 'Updated all given entries.');
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
    required String collectionName,
    required String key,
    required String value,
  }) async {
    if (!_collections.containsKey(collectionName)) {
      return StorageResponse(
        errors: [
          StorageError(
            message: 'Collection "$collectionName" not found.',
            failedKey: key,
            stackTrace: StackTrace.current,
          ),
        ],
      );
    }
    final Box box = await _collections[collectionName]!;
    if (!box.containsKey(key)) {
      return create(collectionName: collectionName, key: key, value: value);
    }
    return update(collectionName: collectionName, key: key, value: value);
  }

  @override
  Future<StorageResponse> createOrUpdateMany({
    required String collectionName,
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
  Future<StorageResponse> delete({required String collectionName, dynamic key}) async {
    if (!_collections.containsKey(collectionName)) {
      return StorageResponse(
        errors: [
          StorageError(
            message: 'Collection "$collectionName" not found.',
            failedKey: key,
            stackTrace: StackTrace.current,
          ),
        ],
      );
    }
    final Box box = await _collections[collectionName]!;
    if (!box.containsKey(key)) {
      return StorageResponse(
        errors: [
          StorageError(
            message: 'Key "$key" does not exist in collection "$collectionName"',
            failedKey: key,
            stackTrace: StackTrace.current,
          ),
        ],
      );
    }
    try {
      await box.delete(key);
      return StorageResponse(message: 'Deleted value at key: $key', isSuccess: true);
    } catch (e) {
      return StorageResponse(
        errors: [
          StorageError(
            failedKey: key,
            message: 'Error while deleting the entry at key: $key: $e',
            stackTrace: StackTrace.current,
          ),
        ],
      );
    }
  }

  @override
  Future<StorageResponse> deleteMany({
    required String collectionName,
    List<String> keys = const [],
  }) async {
    final List<StorageError> errors = [];
    if (!_collections.containsKey(collectionName)) {
      return StorageResponse(
        errors: [
          StorageError(
            message: 'Collection "$collectionName" not found.',
            failedKey: '',
            stackTrace: StackTrace.current,
          ),
        ],
      );
    }
    try {
      final List<String> existingKeys = [];
      final Box box = await _collections[collectionName]!;
      for (int i = 0; i < keys.length; i++) {
        if (!box.containsKey(keys[i])) {
          errors.add(
            StorageError(
              message: 'Key "${keys[i]}" does not exist in collection "$collectionName"',
              failedKey: keys[i],
              stackTrace: StackTrace.current,
            ),
          );
        }
        existingKeys.add(keys[i]);
      }
      if (keys.isNotEmpty) {
        if (existingKeys.isEmpty) {
          return StorageResponse(errors: errors);
        } else if (existingKeys.length == keys.length) {
          await box.deleteAll(existingKeys);
          return StorageResponse(
            message:
                'Deleted multiple entries in collection: $collectionName, associated keys: $keys',
            isSuccess: true,
          );
        }
        await box.deleteAll(existingKeys);
        return StorageResponse(
          data: existingKeys,
          message: 'Deleted ${existingKeys.length}/${keys.length} entries.',
          errors: errors,
        );
      }
      return StorageResponse(
        errors: [
          StorageError(
            message: 'No keys provided',
            failedKey: '',
            stackTrace: StackTrace.current,
          ),
        ],
      );
    } catch (e) {
      return StorageResponse(
        errors: [
          StorageError(
            failedKey: '',
            message: 'Error while deleting the data: $e',
            stackTrace: StackTrace.current,
          ),
        ],
      );
    }
  }

  @override
  Future<StorageResponse> deleteAll({required String collectionName}) async {
    if (!_collections.containsKey(collectionName)) {
      return StorageResponse(
        errors: [
          StorageError(
            message: 'Collection "$collectionName" not found.',
            failedKey: '',
            stackTrace: StackTrace.current,
          ),
        ],
      );
    }
    try {
      final Box box = await _collections[collectionName]!;
      await box.clear();
      return StorageResponse(
        message: 'Deleted all entries from collection: $collectionName',
        isSuccess: true,
      );
    } catch (e) {
      return StorageResponse(
        errors: [
          StorageError(
            failedKey: '',
            message: 'Error while deleting the entries: $e',
            stackTrace: StackTrace.current,
          ),
        ],
      );
    }
  }
}
