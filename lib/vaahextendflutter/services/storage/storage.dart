import '../../env.dart';
import 'local/flutter_secure_storage/flutter_secure_storage_impl.dart';
import 'local/hive/hive_storage_impl.dart';

abstract class Storage {
  static final EnvironmentConfig _envConfig = EnvironmentConfig.getEnvConfig();

  ///Creates a new Local Storage [HiveStorageImpl] or [FlutterSecureStorageImpl]
  ///
  ///The argument [name] is used to open Hive box with that name.
  ///
  ///If you don't provide [name], 'default' will be used.
  factory Storage.createLocal({String name = 'default'}) {
    switch (_envConfig.localStorageType) {
      case LocalStorageType.hive:
        final hive = HiveStorageImpl(name: name);
        hive.init();
        return hive;
      case LocalStorageType.flutterSecureStorage:
        return FlutterSecureStorageImpl();
      default:
        return NullStorage();
    }
  }

  ///Initializes the [Storage].
  ///In the case of [HiveStorageImpl], it creates a [Directory] using the path_provide package,
  ///initializes hive at that directory and opens a box with name [name] provided during [Storage]
  ///creation.
  ///It's not required in the case of [FlutterSecureStorageImpl].
  /// example:
  ///```dart
  /// Storage.createLocal('name')
  /// ```
  Future<void> init();

  ///Creates or updates new item in the [Storage].
  ///
  ///To save or update a single key-value pair pass [key] as String, and the [value] as String, the
  ///String could be a JSON String or a simple text according to your requirement.
  ///If the key is already present in the [Storage] it's vlaue will be overwritten.
  ///```dart
  ///await storage.create(key: 'key', value: 'value');
  /// ```
  Future<void> create({required String key, required String value});

  ///Creates new items in the [Storage].
  ///If you want to save multiple entries pass the [values] as a Map<String, String>, then it will
  ///save all the key-value pairs in the [values] map.
  ///If any key from the [values] is already present in the [Storage] it's value will be overwritten.
  ///```dart
  ///await storage.createAll(values: {
  ///   'key1': 'Value1',
  ///   'key2': 'Value2',
  ///   'key3': 'Value3',
  ///   'key4': 'Value4',
  ///   'key5': 'Value5',
  ///   //...
  ///   },
  /// );
  /// ```
  Future<void> createAll({required Map<String, String> values});

  ///Reads the value of the item at [key] from the [Storage] and returns the value.
  ///
  ///Read a single value by passing [key] as String, it will return the value as String?.
  ///```dart
  ///await storage.read(key: 'key');
  ///```
  Future<String?> read({required String key});

  ///Reads multiple values, pass the List of [keys] as argument. It will return the value as
  ///Map<String, String?>.
  ///
  ///When the keys is not passed it will return all the values from that [Storage] as
  ///Map<String, String?>
  ///```dart
  ///await storage.readAll(keys: [
  ///   'key1',
  ///   'key2',
  ///   //...
  ///  ],
  ///);
  ///```
  Future<Map<String, String?>> readAll({List<String> keys = const []});

  ///Deletes an item at [key].
  ///```dart
  ///await storage.delete(key: 'key');
  ///```
  Future<void> delete({required String key});

  ///Deletes item at a key present in [keys], if keys is not passed all the values will be deleted
  ///from that [Storage].
  ///```dart
  ///await storage.deleteAll(keys: [
  ///   'key1',
  ///   'key2',
  ///   //...
  ///  ],
  ///);
  ///```
  Future<void> deleteAll({List<String> keys = const []});
}

///A placeholder storage class when [LocalStorageType.none] is selected in env.dart.
class NullStorage implements Storage {
  @override
  Future<void> init() async {}

  @override
  Future<void> create({required String key, required String value}) {
    throw UnimplementedError();
  }

  @override
  Future<void> createAll({required Map<String, String> values}) {
    throw UnimplementedError();
  }

  @override
  Future<String?> read({required String key}) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, String?>> readAll({List<String> keys = const []}) {
    throw UnimplementedError();
  }

  @override
  Future<void> delete({required String key}) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAll({List<String> keys = const []}) {
    throw UnimplementedError();
  }
}
