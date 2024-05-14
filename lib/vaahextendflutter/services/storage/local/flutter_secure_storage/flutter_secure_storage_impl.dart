import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../storage.dart';

class FlutterSecureStorageImpl implements Storage {
  final storage = const FlutterSecureStorage();
  @override
  Future<void> init() async {}

  @override
  Future<void> create({dynamic key, dynamic value}) async {
    if ((key is List<String>) && (value is List<String>)) {
      bool isKeyDataLengthEqual = (key.length == value.length);
      if (isKeyDataLengthEqual) {
        for (int i = 0; i < key.length; i++) {
          await storage.write(key: key[i], value: value[i]);
        }
      }
    } else if (key is String && value is String) {
      await storage.write(key: key, value: value);
    } else {
      throw ArgumentError(
          'key must be String or List<String>, data must be String, or List<String>');
    }
  }

  @override
  Future<dynamic> read({dynamic key}) async {
    dynamic result;
    if (key is String) {
      result = await storage.read(key: key);
      return result;
    } else if (key is List<String>) {
      result = List.empty(growable: true);
      for (int i = 0; i < key.length; i++) {
        result.add(await storage.read(key: key[i]));
      }
      return result;
    } else if (key == null) {
      result = await storage.readAll();
      return result;
    } else {
      throw ArgumentError('key must be of type String or List<String>');
    }
  }

  @override
  Future<dynamic> update({dynamic key, dynamic value}) {
    create(key: key, value: value);
    return read(key: key);
  }

  @override
  void delete({dynamic key}) async {
    if (key is String) {
      await storage.delete(key: key);
    } else if (key is List<String>) {
      for (int i = 0; i < key.length; i++) {
        await storage.delete(key: key[i]);
        storage.readAll();
      }
    } else if (key == null) {
      await storage.deleteAll();
    } else {
      throw ArgumentError(
        'key must be of type String or List<String>',
      );
    }
  }
}
