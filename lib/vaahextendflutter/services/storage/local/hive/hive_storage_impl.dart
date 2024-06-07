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

    _box!.put(key, value);
  }

  @override
  Future<void> createAll({required Map<String, String> values}) async {
    assert(_box != null, 'Box is null, not initiized.');

    for (String k in values.keys) {
      await _box!.put(k, values[k]);
    }
  }

  @override
  Future<String?> read({required String key}) async {
    assert(_box != null, 'Box is null, not initiized.');

    String? result = _box!.get(key);
    return result;
  }

  @override
  Future<Map<String, String?>> readAll({List<String> keys = const []}) async {
    assert(_box != null, 'Box is null, not initiized.');

    if (keys.isEmpty) {
      Map<String, String?> result =
          _box!.toMap().map((key, value) => MapEntry(key.toString(), value?.toString()));
      return result;
    } else {
      Map<String, String?> result = {};
      for (String k in keys) {
        if (_box!.containsKey(k)) {
          result[k] = _box!.get(k);
        }
      }
      return result;
    }
  }

  @override
  Future<void> delete({dynamic key}) async {
    assert(_box != null, 'Box is null, not initiized.');

    await _box!.delete(key);
  }

  @override
  Future<void> deleteAll({List<String> keys = const []}) async {
    assert(_box != null, 'Box is null, not initiized.');

    if (keys.isEmpty) {
      await _box!.clear();
    } else {
      _box!.deleteAll(keys);
    }
  }
}
