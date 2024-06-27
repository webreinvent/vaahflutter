import 'package:hive/hive.dart';

import 'base_service.dart';

/// A class implementing LocalStorageService interface using Hive as storage backend.
class LocalStorageWithHive implements LocalStorageService {
  final Map<String, Future<Box>> _collections = {
    'vaah-flutter-box': Hive.openBox('vaah-flutter-box'),
  };

  @override
  void add(String collectionName) {
    assert(!_collections.containsKey(collectionName), 'The Box "$collectionName" already exists');

    _collections[collectionName] = Hive.openBox(collectionName);
  }

  @override
  Future<void> create({
    String collectionName = 'vaah-flutter-box',
    required String key,
    required String value,
  }) async {
    assert(_collections.containsKey(collectionName), 'The Box "$collectionName" does not exists.');

    Box box = await _collections[collectionName]!;
    assert(!box.containsKey(key), 'The key "$key" already exists.');

    await box.put(key, value);
  }

  @override
  Future<void> createMany(
      {String collectionName = 'vaah-flutter-box', required Map<String, String> values}) async {
    for (String k in values.keys) {
      await create(collectionName: collectionName, key: k, value: values[k]!);
    }
  }

  @override
  Future<String?> read({String collectionName = 'vaah-flutter-box', required String key}) async {
    assert(_collections.containsKey(collectionName), 'The Box "$collectionName" does not exists.');

    Box box = await _collections[collectionName]!;
    String? result = box.get(key);
    return result;
  }

  @override
  Future<Map<String, String?>> readMany({
    String collectionName = 'vaah-flutter-box',
    required List<String> keys,
  }) async {
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
  Future<Map<String, String?>> readAll({String collectionName = 'vaah-flutter-box'}) async {
    assert(_collections.containsKey(collectionName), 'The Box "$collectionName" does not exists.');

    Box box = await _collections[collectionName]!;
    Map<String, String?> result = box.toMap().map(
          (key, value) => MapEntry(
            key.toString(),
            value?.toString(),
          ),
        );
    return result;
  }

  @override
  Future<void> update({
    String collectionName = 'vaah-flutter-box',
    required String key,
    required String value,
  }) async {
    assert(_collections.containsKey(collectionName), 'The Box "$collectionName" does not exists.');

    Box box = await _collections[collectionName]!;
    assert(box.containsKey(key), 'The key "$key" does not exist.');

    box.put(key, value);
  }

  @override
  Future<void> updateMany({
    String collectionName = 'vaah-flutter-box',
    required Map<String, String> values,
  }) async {
    for (String k in values.keys) {
      await update(collectionName: collectionName, key: k, value: values[k]!);
    }
  }

  @override
  Future<void> createOrUpdate({
    String collectionName = 'vaah-flutter-box',
    required String key,
    required String value,
  }) async {
    assert(_collections.containsKey(collectionName), 'The Box "$collectionName" does not exists.');

    Box box = await _collections[collectionName]!;
    box.put(key, value);
  }

  @override
  Future<void> createOrUpdateMany({
    String collectionName = 'vaah-flutter-box',
    required Map<String, String> values,
  }) async {
    for (String k in values.keys) {
      await createOrUpdate(collectionName: collectionName, key: k, value: values[k]!);
    }
  }

  @override
  Future<void> delete({String collectionName = 'vaah-flutter-box', dynamic key}) async {
    assert(_collections.containsKey(collectionName), 'The Box "$collectionName" does not exists.');

    Box box = await _collections[collectionName]!;
    await box.delete(key);
  }

  @override
  Future<void> deleteMany({
    String collectionName = 'vaah-flutter-box',
    List<String> keys = const [],
  }) async {
    assert(_collections.containsKey(collectionName), 'The Box "$collectionName" does not exists.');

    Box box = await _collections[collectionName]!;
    if (keys.isNotEmpty) {
      await box.deleteAll(keys);
    }
  }

  @override
  Future<void> deleteAll({String collectionName = 'vaah-flutter-box'}) async {
    assert(_collections.containsKey(collectionName), 'The Box "$collectionName" does not exists.');

    Box box = await _collections[collectionName]!;
    await box.clear();
  }
}
