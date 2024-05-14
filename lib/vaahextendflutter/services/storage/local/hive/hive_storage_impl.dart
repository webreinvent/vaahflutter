import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../storage.dart';

/// A class implementing Storage interface using Hive as storage backend.
class HiveStorageImpl implements Storage {
  final String name;
  HiveCipher? encryptionCypher;
  Box? box;
  HiveStorageImpl({
    required this.name,
    this.encryptionCypher,
  });

  @override
  Future<void> init() async {
    final Directory appDocDirectory = await getApplicationDocumentsDirectory();
    await Directory('${appDocDirectory.path}/dir')
        .create(recursive: true)
        .then((Directory directory) async {
      Hive.init(directory.path);
    });
    box = await Hive.openBox(
      name,
      encryptionCipher: encryptionCypher,
    );
  }

  @override
  Future<void> create({dynamic key, dynamic value}) async {
    if (box != null) {
      if (value is Map<String, String>) {
        box!.putAll(value);
      } else if ((value is List<String>) && (key is List<String>)) {
        for (int i = 0; i < key.length; i++) {
          box!.put(key[i], value[i]);
        }
      } else if (key is String && value is String) {
        if (!box!.containsKey(key)) {
          box!.put(key, value);
        } else {
          box!.put(key, value);
        }
      } else {
        throw ArgumentError(
            'key must be String or List<String>, data must be String, List<String>, or Map<String, String>');
      }
    } else {
      throw Exception('Box is null, not initiized.');
    }
  }

  @override
  Future<dynamic> update({dynamic key, dynamic value}) {
    create(key: key, value: value);
    return read(key: key);
  }

  @override
  Future<dynamic> read({dynamic key}) async {
    dynamic value;
    if (box != null) {
      if (key is List<String>) {
        value = List<dynamic>.empty(growable: true);
        for (int i = 0; i < key.length; i++) {
          value.add((box!.get(key[i])));
        }
        return value;
      } else if (key is String) {
        if (box!.containsKey(key)) {
          value = await box!.get(key);
          return value;
        }
      } else if (key == null) {
        value = box!.toMap();
        return value;
      } else {
        throw ArgumentError('key must be of type String or List<String>');
      }
    } else {
      throw Exception('Box is null, not initiized.');
    }
    return value;
  }

  @override
  void delete({dynamic key}) async {
    if (box != null) {
      if (key is List<String>) {
        box!.deleteAll(key);
      } else if (key is String) {
        if (box!.containsKey(key)) {
          await box!.delete(key);
        }
      } else if (key == null) {
        await box!.clear();
      } else {
        throw ArgumentError('key must be of type String or List<String>');
      }
    } else {
      throw Exception('Box is null, not initiized.');
    }
  }
}
