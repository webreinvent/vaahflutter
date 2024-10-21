import 'package:supabase_flutter/supabase_flutter.dart';

import '../../storage_error.dart';
import '../../storage_response.dart';
import 'base_service.dart';

class NetworkStorageWithSupabase implements NetworkStorageService {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<StorageResponse> create({
    required String collectionName,
    required String key,
    required Map<String, dynamic> value,
  }) async {
    try {
      // add [key] as primary key
      value['key'] = key;
      await _supabase.from(collectionName).insert(value);
      return StorageResponse(
        data: key,
        message: 'Row inserted at key: $key in $collectionName.',
        isSuccess: true,
      );
    } catch (e) {
      // the code '23505 is for error while inserting existing row.
      if (e is PostgrestException && e.code == '23505') {
        StorageError error = StorageError(
          message: 'Row with provide key "$key" already exist: ${e.message}',
          failedKey: key,
          stackTrace: StackTrace.current,
        );
        return StorageResponse(errors: [error]);
      } else {
        StorageError error = StorageError(
          message: 'Failed to create Row at "$key": $e',
          failedKey: key,
          stackTrace: StackTrace.current,
        );
        return StorageResponse(errors: [error]);
      }
    }
  }

  @override
  Future<StorageResponse> createMany({
    required String collectionName,
    required Map<String, Map<String, dynamic>> values,
  }) async {
    try {
      List<Map<String, dynamic>> valuesMapToList = [];
      values.forEach((key, value) {
        final Map<String, dynamic> entry = Map<String, dynamic>.from(value);
        entry['key'] = key;
        valuesMapToList.add(entry);
      });
      await _supabase.from(collectionName).insert(valuesMapToList);
      return StorageResponse(
        data: values.keys.toList(),
        message: 'Inserted all rows at keys: ${values.keys.toList()}',
        isSuccess: true,
      );
    } catch (e) {
      // the code '23505 is for error while inserting existing row.
      if (e is PostgrestException && e.code == '23505') {
        StorageError error = StorageError(
          message: 'One or more rows with provided keys(primary) already exist: ${e.message}',
          failedKey: '',
          stackTrace: StackTrace.current,
        );
        return StorageResponse(errors: [error]);
      } else {
        StorageError error = StorageError(
          message: 'Failed to create Rows": $e',
          failedKey: '',
          stackTrace: StackTrace.current,
        );
        return StorageResponse(errors: [error]);
      }
    }
  }

  @override
  Future<StorageResponse> read({required String collectionName, required String key}) async {
    try {
      final data = await _supabase.from(collectionName).select().eq('key', key).single();
      data.remove('key');
      return StorageResponse(
        data: data,
        message: 'Read successful: Row with key: $key in table: $collectionName.',
        isSuccess: true,
      );
    } catch (e) {
      // the code 'PGRST116' is for error while reading not-existent row.
      if (e is PostgrestException && e.code == 'PGRST116') {
        StorageError error = StorageError(
          message: 'Row with key: $key does not exists.',
          failedKey: key,
          stackTrace: StackTrace.current,
        );
        return StorageResponse(errors: [error]);
      } else {
        StorageError error = StorageError(
          message: 'Read failed: $e',
          failedKey: key,
          stackTrace: StackTrace.current,
        );
        return StorageResponse(errors: [error]);
      }
    }
  }

  @override
  Future<StorageResponse> readMany({
    required String collectionName,
    required List<String> keys,
  }) async {
    if (keys.isNotEmpty) {
      int remainingKeys = keys.length;
      List<StorageError> errors = [];
      Map<String, Map<String, dynamic>> data = {};
      for (String k in keys) {
        final result = await read(collectionName: collectionName, key: k);
        if (result.isSuccess) {
          data[k] = result.data;
          remainingKeys--;
        } else if (result.hasError) {
          errors.add(result.errors!.first);
        }
      }
      if (errors.isEmpty) {
        return StorageResponse(data: data, message: 'Read successful.', isSuccess: true);
      } else if (remainingKeys == keys.length) {
        return StorageResponse(errors: errors);
      } else {
        return StorageResponse(
          data: data,
          message: 'Read ${keys.length - remainingKeys}/${keys.length}.',
          errors: errors,
          isPartialSuccess: true,
        );
      }
    } else {
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
  }

  @override
  Future<StorageResponse> readAll({required String collectionName}) async {
    try {
      final List<Map<String, dynamic>> listResult = await _supabase.from(collectionName).select();
      final Map<String, Map<String, dynamic>> values = {};
      for (Map<String, dynamic> entry in listResult) {
        final String key = entry['key'];
        Map<String, dynamic> value = Map<String, dynamic>.from(entry);
        value.remove('key');
        values[key] = value;
      }
      return StorageResponse(data: values, message: 'Read all successful.', isSuccess: true);
    } catch (e) {
      return StorageResponse(
        errors: [
          StorageError(
            message: 'Read failed: $e',
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
    required Map<String, dynamic> value,
  }) async {
    try {
      final PostgrestResponse response = await _supabase
          .from(collectionName)
          .update(value)
          .eq('key', key)
          .count(CountOption.exact);
      // response.count == 0 means no row was returned that matches the specified key (rowId).
      if (response.count == 0) {
        StorageError error = StorageError(
          message: 'Update Failed: The row "$key" does not exists.',
          failedKey: key,
          stackTrace: StackTrace.current,
        );
        return StorageResponse(errors: [error]);
      } else {
        return StorageResponse(
          data: key,
          message: 'Updated row at key: $key in table: $collectionName.',
          isSuccess: true,
        );
      }
    } catch (e) {
      return StorageResponse(
        errors: [
          StorageError(
            message: 'Update failed: $e',
            failedKey: key,
            stackTrace: StackTrace.current,
          ),
        ],
      );
    }
  }

  @override
  Future<StorageResponse> updateMany({
    required String collectionName,
    required Map<String, Map<String, dynamic>> values,
  }) async {
    int remainigEntries = values.length;
    List<StorageError> errors = [];
    List<String> success = [];
    for (String k in values.keys) {
      final result = await update(collectionName: collectionName, key: k, value: values[k]!);
      if (result.isSuccess) {
        remainigEntries--;
        success.add(result.data);
      } else if (result.isSuccess) {
        errors.add(result.errors!.first);
      }
    }
    if (errors.isEmpty) {
      return StorageResponse(
        data: success,
        message: 'Updated all given entries.',
        isSuccess: true,
      );
    } else if (remainigEntries == values.length) {
      return StorageResponse(errors: errors);
    } else {
      return StorageResponse(
        data: success,
        message: 'Updated $remainigEntries/${values.length} entries.',
        errors: errors,
        isPartialSuccess: true,
      );
    }
  }

  @override
  Future<StorageResponse> createOrUpdate({
    required String collectionName,
    required String key,
    required Map<String, dynamic> value,
  }) async {
    try {
      // add [key] as primary key.
      value['key'] = key;
      await _supabase.from(collectionName).upsert(value);
      return StorageResponse(
        data: key,
        message: 'Upsert row at key: $key in table: $collectionName.',
        isSuccess: true,
      );
    } catch (e) {
      return StorageResponse(
        errors: [
          StorageError(
            message: 'Upsert failed: $e',
            failedKey: key,
            stackTrace: StackTrace.current,
          ),
        ],
      );
    }
  }

  @override
  Future<StorageResponse> createOrUpdateMany({
    required String collectionName,
    required Map<String, Map<String, dynamic>> values,
  }) async {
    int remainigEntries = values.length;
    List<StorageError> errors = [];
    List<String> success = [];
    for (String k in values.keys) {
      final result =
          await createOrUpdate(collectionName: collectionName, key: k, value: values[k]!);
      if (result.isSuccess) {
        remainigEntries--;
        success.add(result.data);
      } else if (result.hasError) {
        errors.add(result.errors!.first);
      }
    }
    if (errors.isEmpty) {
      return StorageResponse(data: success, message: 'Set all given entries.', isSuccess: true);
    } else if (remainigEntries == values.length) {
      return StorageResponse(errors: errors);
    } else {
      return StorageResponse(
        data: success,
        message: 'Set $remainigEntries/${values.length} entries.',
        errors: errors,
        isPartialSuccess: true,
      );
    }
  }

  @override
  Future<StorageResponse> delete({required String collectionName, required String key}) async {
    try {
      await _supabase.from(collectionName).delete().eq('key', key);
      return StorageResponse(
        data: key,
        message: 'Deleted row at key: $key from table: $collectionName.',
        isSuccess: true,
      );
    } catch (e) {
      return StorageResponse(
        errors: [
          StorageError(
            message: 'Delete failed: $e',
            failedKey: key,
            stackTrace: StackTrace.current,
          ),
        ],
      );
    }
  }

  @override
  Future<StorageResponse> deleteMany({
    required String collectionName,
    required List<String> keys,
  }) async {
    try {
      await _supabase.from(collectionName).delete().inFilter('key', keys);
      return StorageResponse(
        data: keys,
        message: 'Deleted rows at keys: $keys from table: $collectionName.',
        isSuccess: true,
      );
    } catch (e) {
      return StorageResponse(errors: [
        StorageError(
          message: 'Delete failed: $e',
          failedKey: '',
          stackTrace: StackTrace.current,
        )
      ]);
    }
  }

  @override
  Future<StorageResponse> deleteAll({required String collectionName}) async {
    try {
      // assuming no row have key = ''
      await _supabase.from(collectionName).delete().neq('key', '');
      return StorageResponse(
        data: null,
        message: 'Deleted all rows from table: $collectionName.',
        isSuccess: true,
      );
    } catch (e) {
      return StorageResponse(errors: [
        StorageError(
          message: 'Delete failed: $e',
          failedKey: '',
          stackTrace: StackTrace.current,
        )
      ]);
    }
  }
}
