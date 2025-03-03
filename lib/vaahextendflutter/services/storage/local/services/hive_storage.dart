import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vaahflutter/vaahextendflutter/services/storage/local/storage_error.dart';

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

  Future<Box> _getBox(String collectionName) async {
    if (!_collections.containsKey(collectionName)) {
      throw Exception('no-collection-found: $collectionName');
    }
    return await _collections[collectionName]!;
  }

  @override
  Future<void> create({
    required String collectionName,
    required String key,
    required dynamic value,
  }) async {
    final Box box = await _getBox(collectionName);
    if (box.containsKey(key)) {
      throw Exception('key-already-exists: $key');
    }
    await box.put(key, value);
  }

  @override
  Future<void> createMany({
    required String collectionName,
    required Map<String, dynamic> values,
  }) async {
    final List<String> errors = [];
    final List<String> success = [];

    final Box box = await _getBox(collectionName);
    try {
      for (final String key in values.keys) {
        if (box.containsKey(key)) {
          errors.add(key);
          throw 'key-already-exists';
        } else {
          success.add(key);
        }
      }
    } catch (e, st) {
      throw StorageException(
        throwable: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<String?> read({
    required String collectionName,
    required String key,
  }) async {
    final Box box = await _getBox(collectionName);
    if (!box.containsKey(key)) {
      return null;
    }
    return box.get(key);
  }

  @override
  Future<Map<String, dynamic>> readMany({
    required String collectionName,
    required List<String> keys,
  }) async {
    Map<String, dynamic> result = {};

    final Box box = await _getBox(collectionName);

    for (final key in keys) {
      if (box.containsKey(key)) {
        result[key] = box.get(key);
      }
    }

    return result;
  }

  @override
  Future<Map<String, String>> readAll({required String collectionName}) async {
    final Box box = await _getBox(collectionName);

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
    required dynamic value,
  }) async {
    final Box box = await _getBox(collectionName);
    if (!box.containsKey(key)) {
      throw Exception('no-key-found: $key');
    }

    return await box.put(key, value);
  }

  @override
  Future<void> updateMany({
    required String collectionName,
    required Map<String, dynamic> values,
  }) async {
    final List<String> errors = [];
    final List<String> success = [];

    final Box box = await _getBox(collectionName);
    try {
      await box.putAll(values);
      success.addAll(values.keys);
    } catch (e, st) {
      errors.addAll(values.keys);
      throw StorageException(throwable: e, stackTrace: st);
    }
  }

  @override
  Future<void> createOrUpdate({
    required String collectionName,
    required String key,
    required dynamic value,
  }) async {
    final Box box = await _getBox(collectionName);
    await box.put(key, value);
  }

  @override
  Future<void> createOrUpdateMany({
    required String collectionName,
    required Map<String, dynamic> values,
  }) async {
    final Box box = await _getBox(collectionName);
    await box.putAll(values);
  }

  @override
  Future<void> delete({required String collectionName, String? key}) async {
    final Box box = await _getBox(collectionName);
    if (!box.containsKey(key)) {
      throw 'no-key-found';
    }
    await box.delete(key);
  }

  @override
  Future<void> deleteMany({
    required String collectionName,
    List<String> keys = const [],
  }) async {
    final List<String> errors = [];
    final List<String> nonExistingKeys = [];
    final List<String> existingKeys = [];

    final Box box = await _getBox(collectionName);
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
    final Box box = await _getBox(collectionName);
    await box.clear();
  }
}
