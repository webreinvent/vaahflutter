import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'base_storage.dart';

/// A class implementing LocalStorageService interface using Hive as storage backend.
class LocalHiveStorage implements LocalStorageService {
  static Future<LocalHiveStorage> init() async {
    final Directory docsDirectory = await getApplicationDocumentsDirectory();
    final String storagePath = '${docsDirectory.path}/vaahflutter';
    final Directory storageDirectory = await Directory(storagePath).create(
      recursive: true,
    );

    Hive.init(storageDirectory.path);
    return LocalHiveStorage();
  }

  final Map<String, Future<Box>> _collections = {
    'vaah-flutter-box': Hive.openBox('vaah-flutter-box'),
  };

  @override
  Future<void> addCollection({
    required String collectionName,
  }) async {
    if (!_collections.containsKey(collectionName)) {
      _collections[collectionName] = Hive.openBox(collectionName);
    }
  }

  @override
  Future<void> create({
    required String collectionName,
    required String key,
    required String value,
  }) async {
    if (!_collections.containsKey(collectionName)) {
      return;
    }
    final Box box = await _collections[collectionName]!;
    if (box.containsKey(key)) {}

    await box.put(key, value);
  }

  @override
  Future<void> createMany({
    required String collectionName,
    required Map<String, String> values,
  }) async {
    final List<String> errors = [];
    final List<String> success = [];
    for (final String key in values.keys) {
      try {
        await create(
          collectionName: collectionName,
          key: key,
          value: values[key]!,
        );
        success.add(key);
      } catch (e, st) {
        errors.add(key);
      }
    }
    return;
  }

  @override
  Future<String?> read({
    required String collectionName,
    required String key,
  }) async {
    if (!_collections.containsKey(collectionName)) {
      throw 'no collection data found';
    }
    final Box box = await _collections[collectionName]!;
    if (!box.containsKey(key)) {
      throw 'no data found';
    }

    return box.get(key);
  }

  @override
  Future<Map<String, String>> readMany({
    required String collectionName,
    required List<String> keys,
  }) async {
    final Map<String, String?> success = {};
    final List<String> errors = [];
    for (final String key in keys) {
      try {
        final String? result = await read(collectionName: collectionName, key: key);
        if (result != null) {
          success[key] = result;
        } else {
          errors.add(key);
        }
      } catch (e, st) {
        errors.add(key);
      }
    }
    return {};
  }

  @override
  Future<Map<String, String>> readAll({required String collectionName}) async {
    if (!_collections.containsKey(collectionName)) {
      throw 'no collection found';
    }
    final Box box = await _collections[collectionName]!;
    return box.toMap().map(
      (key, value) {
        return MapEntry(
          key.toString(),
          value.toString(),
        );
      },
    );
  }

  @override
  Future<void> update({
    required String collectionName,
    required String key,
    required String value,
  }) async {
    if (!_collections.containsKey(collectionName)) {
      throw 'no collection found';
    }
    final Box box = await _collections[collectionName]!;
    if (!box.containsKey(key)) {
      throw 'no key found';
    }
    return await box.put(key, value);
  }

  @override
  Future<void> updateMany({
    required String collectionName,
    required Map<String, String> values,
  }) async {
    final List<String> errors = [];
    final List<String> success = [];
    for (final String key in values.keys) {
      try {
        await update(
          collectionName: collectionName,
          key: key,
          value: values[key]!,
        );
        success.add(key);
      } catch (e, st) {
        errors.add(key);
      }
    }
  }

  @override
  Future<void> createOrUpdate({
    required String collectionName,
    required String key,
    required String value,
  }) async {
    if (!_collections.containsKey(collectionName)) {
      throw 'no collection found';
    }
    final Box box = await _collections[collectionName]!;
    if (!box.containsKey(key)) {
      return create(collectionName: collectionName, key: key, value: value);
    }
    return update(collectionName: collectionName, key: key, value: value);
  }

  @override
  Future<void> createOrUpdateMany({
    required String collectionName,
    required Map<String, String> values,
  }) async {
    final List<String> errors = [];
    final List<String> success = [];
    for (final String key in values.keys) {
      try {
        await createOrUpdate(
          collectionName: collectionName,
          key: key,
          value: values[key]!,
        );
        success.add(key);
      } catch (e, st) {
        errors.add(key);
      }
    }
  }

  @override
  Future<void> delete({required String collectionName, dynamic key}) async {
    if (!_collections.containsKey(collectionName)) {
      throw 'no collection found';
    }
    final Box box = await _collections[collectionName]!;
    if (!box.containsKey(key)) {
      throw 'no key found';
    }
    await box.delete(key);
  }

  @override
  Future<void> deleteMany({
    required String collectionName,
    List<String> keys = const [],
  }) async {
    final List<String> errors = [];
    if (!_collections.containsKey(collectionName)) {
      throw 'no collection found';
    }
    final List<String> nonExistingKeys = [];
    final List<String> existingKeys = [];
    final Box box = await _collections[collectionName]!;
    for (int i = 0; i < keys.length; i++) {
      if (!box.containsKey(keys[i])) {
        errors.add(keys[i]);
        nonExistingKeys.add(keys[i]);
      } else {
        existingKeys.add(keys[i]);
      }
    }
    if (nonExistingKeys.isEmpty) {
      await box.deleteAll(keys);
    } else {
      await box.deleteAll(existingKeys);
      // Notify about errors
    }
  }

  @override
  Future<void> deleteAll({required String collectionName}) async {
    if (!_collections.containsKey(collectionName)) {
      throw 'no collection found';
    }
    final Box box = await _collections[collectionName]!;
    await box.clear();
  }
}
