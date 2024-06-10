import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../storage.dart';

class FlutterSecureStorageImpl implements Storage {
  final _storage = const FlutterSecureStorage();

  @override
  Future<void> init() async {}

  @override
  Future<void> create({required String key, required String value}) async {
    assert(!(await _storage.containsKey(key: key)), 'The key "$key" already exists.');

    await _storage.write(key: key, value: value);
  }

  @override
  Future<void> createMany({required Map<String, String> values}) async {
    for (String k in values.keys) {
      await create(key: k, value: values[k]!);
    }
  }

  @override
  Future<String?> read({required String key}) async {
    String? result = await _storage.read(key: key);
    return result;
  }

  @override
  Future<Map<String, String?>> readMany({required List<String> keys}) async {
    if (keys.isNotEmpty) {
      Map<String, String?> result = {};
      for (String k in keys) {
        result[k] = await _storage.read(key: k);
      }
      return result;
    } else {
      return {};
    }
  }

  @override
  Future<Map<String, String?>> readAll() async {
    final Map<String, String> result = await _storage.readAll();
    return result;
  }

  @override
  Future<void> update({required String key, required String value}) async {
    assert(await _storage.containsKey(key: key), 'The key "$key" does not exists.');

    await _storage.write(key: key, value: value);
  }

  @override
  Future<void> updateMany({required Map<String, String> values}) async {
    for (String k in values.keys) {
      await update(key: k, value: values[k]!);
    }
  }

  @override
  Future<void> createOrUpdate({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<void> createOrUpdateMany({required Map<String, String> values}) async {
    for (String k in values.keys) {
      await createOrUpdate(key: k, value: values[k]!);
    }
  }

  @override
  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  @override
  Future<void> deleteMany({List<String> keys = const []}) async {
    if (keys.isNotEmpty) {
      for (String k in keys) {
        await _storage.delete(key: k);
      }
    }
  }

  @override
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
