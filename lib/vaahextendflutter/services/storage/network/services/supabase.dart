import 'package:supabase_flutter/supabase_flutter.dart';

import 'base_service.dart';

class NetworkStorageWithSupabase implements NetworkStorageService {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<void> create({
    required String collectionName,
    required String key,
    required Map<String, dynamic> value,
  }) async {
    try {
      // add [key] as primary key
      value['key'] = key;
      await _supabase.from(collectionName).insert(value);
    } on PostgrestException catch (e) {
      // the code '23505 is for error while inserting existing row.
      if (e.code == '23505') {
        throw ('Row with provide key "$key" already exist: ${e.message}');
      } else {
        rethrow;
      }
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> createMany({
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
    } on PostgrestException catch (e) {
      // the code '23505 is for error while inserting existing row.
      if (e.code == '23505') {
        throw ('One or more rows with provide keys(foreign) already exist: ${e.message}');
      } else {
        rethrow;
      }
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> read({required String collectionName, required String key}) async {
    try {
      final data = await _supabase.from(collectionName).select().eq('key', key).single();
      data.remove('key');
      return data;
    } on PostgrestException catch (e) {
      // the code 'PGRST116' is for error while reading not-existent row.
      if (e.code == 'PGRST116') {
        return null;
      } else {
        rethrow;
      }
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<Map<String, Map<String, dynamic>?>> readMany({
    required String collectionName,
    required List<String> keys,
  }) async {
    final Map<String, Map<String, dynamic>?> values = {};
    for (int i = 0; i < keys.length; i++) {
      values[keys[i]] = await read(collectionName: collectionName, key: keys[i]);
    }
    return values;
  }

  @override
  Future<Map<String, Map<String, dynamic>?>> readAll({required String collectionName}) async {
    try {
      final List<Map<String, dynamic>> listResult = await _supabase.from(collectionName).select();
      final Map<String, Map<String, dynamic>> values = {};
      for (Map<String, dynamic> entry in listResult) {
        final String key = entry['key'];
        Map<String, dynamic> value = Map<String, dynamic>.from(entry);
        value.remove('key');
        values[key] = value;
      }
      return values;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> update({
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
        throw ('Update Failed: The row "$key" does not exists.');
      }
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> updateMany({
    required String collectionName,
    required Map<String, Map<String, dynamic>> values,
  }) async {
    values.forEach((key, value) async {
      await update(collectionName: collectionName, key: key, value: value);
    });
  }

  @override
  Future<void> createOrUpdate({
    required String collectionName,
    required String key,
    required Map<String, dynamic> value,
  }) async {
    try {
      // add [key] as primary key.
      value['key'] = key;

      await _supabase.from(collectionName).upsert(value);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> createOrUpdateMany({
    required String collectionName,
    required Map<String, Map<String, dynamic>> values,
  }) async {
    values.forEach((key, value) async {
      await createOrUpdate(collectionName: collectionName, key: key, value: value);
    });
  }

  @override
  Future<void> delete({required String collectionName, required String key}) async {
    try {
      await _supabase.from(collectionName).delete().eq('key', key);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> deleteMany({required String collectionName, required List<String> keys}) async {
    try {
      await _supabase.from(collectionName).delete().inFilter('key', keys);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAll({required String collectionName}) async {
    try {
      // assuming no row have key = ''
      await _supabase.from(collectionName).delete().neq('key', '');
    } catch (_) {
      rethrow;
    }
  }
}
