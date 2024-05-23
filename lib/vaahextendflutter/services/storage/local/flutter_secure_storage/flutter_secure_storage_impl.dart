import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../storage.dart';

class FlutterSecureStorageImpl implements Storage {
  final _storage = const FlutterSecureStorage();

  @override
  Future<void> init() async {}

  @override
  Future<void> create({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<void> createAll({required Map<String, String> values}) async {
    for (String k in values.keys) {
      await _storage.write(key: k, value: values[k]);
    }
  }

  @override
  Future<String?> read({required String key}) async {
    String? result = await _storage.read(key: key);
    return result;
  }

  @override
  Future<Map<String, String?>> readAll({List<String> keys = const []}) async {
    if (keys.isEmpty) {
      final Map<String, String> result = await _storage.readAll();
      return result;
    } else {
      Map<String, String?> result = {};
      for (String k in keys) {
        result[k] = await _storage.read(key: k);
      }
      return result;
    }
  }

  @override
  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  @override
  Future<void> deleteAll({List<String> keys = const []}) async {
    if (keys.isEmpty) {
      await _storage.deleteAll();
    } else {
      for (String k in keys) {
        await _storage.delete(key: k);
      }
    }
  }
}
