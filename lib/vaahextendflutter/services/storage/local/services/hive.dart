import 'package:hive/hive.dart';

import 'base_service.dart';

/// A class implementing LocalStorageService interface using Hive as storage backend.
class LocalStorageWithHive implements LocalStorageService {
  final Map<String, Box> _collections = {};

  @override
  Future<void> add(String collectionName) async {
    assert(!_collections.containsKey(collectionName), 'The Box "$collectionName" already exists');

    _collections[collectionName] = await Hive.openBox(collectionName);
  }

  @override
  Future<void> create({
    String collectionName = 'vaah-flutter-hive-box',
    required String key,
    required String value,
  }) async {
    assert(_collections.containsKey(collectionName), 'The Box "$collectionName" does not exists.');
    assert(_collections[collectionName]!.containsKey(key), 'The key ($key) already exists.');

    await _collections[collectionName]!.put(key, value);
  }

  @override
  Future<void> createMany({
    String collectionName = 'vaah-flutter-hive-box',
    required Map<String, String> values,
  }) async {
    for (String k in values.keys) {
      await create(collectionName: collectionName, key: k, value: values[k]!);
    }
  }

  @override
  Future<String?> read({
    String collectionName = 'vaah-flutter-hive-box',
    required String key,
  }) async {
    assert(_collections.containsKey(collectionName), 'The Box "$collectionName" does not exists.');

    String? result = _collections[collectionName]!.get(key);
    return result;
  }

  @override
  Future<Map<String, String?>> readMany({
    String collectionName = 'vaah-flutter-hive-box',
    required List<String> keys,
  }) async {
    assert(_collections.containsKey(collectionName), 'The Box "$collectionName" does not exists.');

    if (keys.isNotEmpty) {
      Map<String, String?> result = {};
      for (String k in keys) {
        result[k] = await read(collectionName: collectionName, key: k);
      }
      return result;
    } else {
      return {};
    }
  }

  @override
  Future<Map<String, String?>> readAll({String collectionName = 'vaah-flutter-hive-box'}) async {
    assert(_collections.containsKey(collectionName), 'The Box "$collectionName" does not exists.');

    Map<String, String?> result = _collections[collectionName]!
        .toMap()
        .map((key, value) => MapEntry(key.toString(), value?.toString()));
    return result;
  }

  @override
  Future<void> update({
    String collectionName = 'vaah-flutter-hive-box',
    required String key,
    required String value,
  }) async {
    assert(_collections.containsKey(collectionName), 'The Box "$collectionName" does not exists.');
    assert(!_collections[collectionName]!.containsKey(key), 'The key ($key) does not exist.');

    _collections[collectionName]!.put(key, value);
  }

  @override
  Future<void> updateMany({
    String collectionName = 'vaah-flutter-hive-box',
    required Map<String, String> values,
  }) async {
    for (String k in values.keys) {
      await update(collectionName: collectionName, key: k, value: values[k]!);
    }
  }

  @override
  Future<void> createOrUpdate({
    String collectionName = 'vaah-flutter-hive-box',
    required String key,
    required String value,
  }) async {
    assert(_collections.containsKey(collectionName), 'The Box "$collectionName" does not exists.');

    _collections[collectionName]!.put(key, value);
  }

  @override
  Future<void> createOrUpdateMany({
    String collectionName = 'vaah-flutter-hive-box',
    required Map<String, String> values,
  }) async {
    for (String k in values.keys) {
      await createOrUpdate(collectionName: collectionName, key: k, value: values[k]!);
    }
  }

  @override
  Future<void> delete({String collectionName = 'vaah-flutter-hive-box', dynamic key}) async {
    assert(_collections.containsKey(collectionName), 'The Box "$collectionName" does not exists.');

    await _collections[collectionName]!.delete(key);
  }

  @override
  Future<void> deleteMany({
    String collectionName = 'vaah-flutter-hive-box',
    List<String> keys = const [],
  }) async {
    assert(_collections.containsKey(collectionName), 'The Box "$collectionName" does not exists.');

    if (keys.isNotEmpty) {
      _collections[collectionName]!.deleteAll(keys);
    }
  }

  @override
  Future<void> deleteAll({String collectionName = 'vaah-flutter-hive-box'}) async {
    assert(_collections.containsKey(collectionName), 'The Box "$collectionName" does not exists.');

    await _collections[collectionName]!.clear();
  }
}
