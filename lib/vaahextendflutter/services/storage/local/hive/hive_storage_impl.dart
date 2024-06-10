import 'package:hive/hive.dart';

import '../../storage.dart';

/// A class implementing Storage interface using Hive as storage backend.
class HiveStorageImpl implements Storage {
  final String name;

  Box? _box;

  HiveStorageImpl({this.name = 'vaah_flutter_hive_box'});

  @override
  Future<void> init() async {
    _box = await Hive.openBox(name);
  }

  @override
  Future<void> create({required String key, required String value}) async {
    assert(_box != null, 'Box is null, not initiized.');
    assert(_box!.containsKey(key), 'The key ($key) already exists.');

    _box!.put(key, value);
  }

  @override
  Future<void> createMany({required Map<String, String> values}) async {
    for (String k in values.keys) {
      await create(key: k, value: values[k]!);
    }
  }

  @override
  Future<String?> read({required String key}) async {
    assert(_box != null, 'Box is null, not initiized.');

    String? result = _box!.get(key);
    return result;
  }

  @override
  Future<Map<String, String?>> readMany({required List<String> keys}) async {
    assert(_box != null, 'Box is null, not initiized.');

    if (keys.isNotEmpty) {
      Map<String, String?> result = {};
      for (String k in keys) {
        if (_box!.containsKey(k)) {
          result[k] = _box!.get(k);
        }
      }
      return result;
    } else {
      return {};
    }
  }

  @override
  Future<Map<String, String?>> readAll() async {
    assert(_box != null, 'Box is null, not initiized.');

    Map<String, String?> result =
        _box!.toMap().map((key, value) => MapEntry(key.toString(), value?.toString()));
    return result;
  }

  @override
  Future<void> update({required String key, required String value}) async {
    assert(_box != null, 'Box is null, not initiized.');
    assert(!_box!.containsKey(key), 'The key ($key) does not exist.');

    _box!.put(key, value);
  }

  @override
  Future<void> updateMany({required Map<String, String> values}) async {
    for (String k in values.keys) {
      await update(key: k, value: values[k]!);
    }
  }

  @override
  Future<void> createOrUpdate({required String key, required String value}) async {
    assert(_box != null, 'Box is null, not initiized.');

    _box!.put(key, value);
  }

  @override
  Future<void> createOrUpdateMany({required Map<String, String> values}) async {
    for (String k in values.keys) {
      await createOrUpdate(key: k, value: values[k]!);
    }
  }

  @override
  Future<void> delete({dynamic key}) async {
    assert(_box != null, 'Box is null, not initiized.');

    await _box!.delete(key);
  }

  @override
  Future<void> deleteMany({List<String> keys = const []}) async {
    assert(_box != null, 'Box is null, not initiized.');

    if (keys.isNotEmpty) {
      _box!.deleteAll(keys);
    }
  }

  @override
  Future<void> deleteAll() async {
    assert(_box != null, 'Box is null, not initiized.');

    await _box!.clear();
  }
}
