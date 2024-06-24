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
    } catch (e) {
      throw Exception(e.toString());
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
        Map<String, dynamic> entry = Map<String, dynamic>.from(value);
        entry['key'] = key;
        valuesMapToList.add(entry);
      });
      await _supabase.from(collectionName).insert(valuesMapToList);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>?> read({required String collectionName, required String key}) async {
    try {
      final data = await _supabase.from(collectionName).select().eq('key', key);
      final Map<String, dynamic> value = data[0];
      value.remove('key');
      return value;
    } catch (e) {
      throw Exception(e.toString());
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
      final listResult = await _supabase.from(collectionName).select();
      final Map<String, Map<String, dynamic>> values = {};

      for (Map<String, dynamic> entry in listResult) {
        final String key = entry['key'];
        Map<String, dynamic> value = Map<String, dynamic>.from(entry);
        value.remove('key');

        values[key] = value;
      }
      return values;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> update({
    required String collectionName,
    required String key,
    required Map<String, dynamic> value,
  }) async {
    try {
      await _supabase.from(collectionName).update(value).eq('key', key);
    } catch (e) {
      throw Exception(e.toString());
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
    } catch (e) {
      throw Exception(e.toString());
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
    await _supabase.from(collectionName).delete().eq('key', key);
  }

  @override
  Future<void> deleteMany({required String collectionName, required List<String> keys}) async {
    await _supabase.from(collectionName).delete().inFilter('key', keys);
  }

  @override
  Future<void> deleteAll({required String collectionName}) async {
    await _supabase.from(collectionName).delete().neq('key', '');
  }
}
