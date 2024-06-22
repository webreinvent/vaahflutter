import 'base_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NetworkStorageWithSupabase implements NetworkStorageService {
  final supabase = Supabase.instance.client;

  @override
  Future<void> create({
    required String collectionName,
    required String key,
    required Map<String, dynamic> value,
  }) async {
    try {
      value['key'] = key;
      await supabase.from(collectionName).insert(value);
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
        Map<String, dynamic> newMap = Map<String, dynamic>.from(value);
        newMap['key'] = key;
        valuesMapToList.add(newMap);
      });
      await supabase.from(collectionName).insert(valuesMapToList);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>?> read({required String collectionName, required String key}) async {
    try {
      final data = await supabase.from(collectionName).select().eq('key', key);
      Map<String, dynamic> map = data[0];
      map.remove('key');
      return map;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<Map<String, Map<String, dynamic>?>> readMany({
    required String collectionName,
    required List<String> keys,
  }) async {
    Map<String, Map<String, dynamic>?> values = {};
    for (int i = 0; i < keys.length; i++) {
      values[keys[i]] = await read(collectionName: collectionName, key: keys[i]);
    }
    return values;
  }

  @override
  Future<Map<String, Map<String, dynamic>?>> readAll({required String collectionName}) async {
    try {
      final listResult = await supabase.from(collectionName).select();
      Map<String, Map<String, dynamic>> map = {};

      for (Map<String, dynamic> item in listResult) {
        String key = item['key'];

        Map<String, dynamic> value = Map<String, dynamic>.from(item);
        value.remove('key');

        map[key] = value;
      }
      return map;
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
      await supabase.from(collectionName).update(value).eq('key', key);
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
  Future<void> createOrUpdate(
      {required String collectionName, required String key, required Map<String, dynamic> value}) {
    // TODO: implement createOrUpdate
    throw UnimplementedError();
  }

  @override
  Future<void> createOrUpdateMany({
    required String collectionName,
    required Map<String, Map<String, dynamic>> values,
  }) {
    // TODO: implement createOrUpdateMany
    throw UnimplementedError();
  }

  @override
  Future<void> delete({required String collectionName, required String key}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMany({required String collectionName, required List<String> keys}) {
    // TODO: implement deleteAll
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAll({required String collectionName}) {
    // TODO: implement deleteAll
    throw UnimplementedError();
  }
}
