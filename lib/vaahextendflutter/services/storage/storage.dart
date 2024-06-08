import '../../env.dart';
import 'local/flutter_secure_storage/flutter_secure_storage_impl.dart';
import 'local/hive/hive_storage_impl.dart';

abstract class Storage {
  static final EnvironmentConfig _envConfig = EnvironmentConfig.getEnvConfig();

  /// Creates a new Local Storage [HiveStorageImpl] or [FlutterSecureStorageImpl].
  ///
  /// The argument [name] is used to open Hive box with that name.
  ///
  /// If you don't provide [name], 'default' will be used.
  factory Storage.createLocal({String? name}) {
    switch (_envConfig.localStorageType) {
      case LocalStorageType.hive:
        return name == null ? HiveStorageImpl() : HiveStorageImpl(name: name);
      case LocalStorageType.flutterSecureStorage:
        return FlutterSecureStorageImpl();
      default:
        return NoOpStorage();
    }
  }

  /// Initializes the [Storage].
  /// In the case of [HiveStorageImpl], it creates a [Directory] using the path_provide package,
  /// initializes hive at that directory and opens a box with name [name] provided during [Storage]
  /// creation.
  /// It's not required in the case of [FlutterSecureStorageImpl].
  ///
  /// Example:
  /// ```dart
  /// storage.init();
  /// ```
  Future<void> init() async {}

  /// Creates or updates new item in the [Storage].
  ///
  /// To save or update a single key-value pair pass [key] as String, and the [value] as String, the
  /// String could be a JSON String or a simple text according to your requirement.
  /// If the key is already present in the [Storage] it's vlaue will be overwritten.
  ///
  /// Example:
  /// ```dart
  /// await storage.save(key: 'key', value: 'value');
  /// ```
  Future<void> save({required String key, required String value});

  /// Creates new items in the [Storage].
  /// If you want to save multiple entries pass the [values] as a Map<String, String>, then it will
  /// save all the key-value pairs in the [values] map.
  /// If any key from the [values] is already present in the [Storage] it's value will be
  /// overwritten.
  ///
  /// Example:
  /// ```dart
  /// await storage.saveMany(values: {
  ///     'key1': 'Value1',
  ///     'key2': 'Value2',
  ///     'key3': 'Value3',
  ///     'key4': 'Value4',
  ///     'key5': 'Value5',
  ///     //...
  ///   },
  /// );
  /// ```
  Future<void> saveMany({required Map<String, String> values});

  /// Reads the value of the item at [key] from the [Storage] and returns the value.
  ///
  /// Read a single value by passing [key] as String, it will return the value as String?.
  ///
  /// Example:
  /// ```dart
  /// await storage.read(key: 'key');
  /// ```
  Future<String?> read({required String key});

  /// Reads multiple values, pass the List of [keys] as argument. It will return the value as
  /// Map<String, String?>.
  ///
  /// Example:
  /// ```dart
  /// await storage.readAll(keys: [
  ///     'key1',
  ///     'key2',
  ///     //...
  ///   ],
  /// );
  /// ```
  Future<Map<String, String?>> readMany({required List<String> keys});

  /// It will return all the values from that [Storage] as Map<String, String?>.
  Future<Map<String, String?>> readAll();

  /// Deletes an item at [key].
  ///
  /// Example:
  /// ```dart
  /// await storage.delete(key: 'key');
  /// ```
  Future<void> delete({required String key});

  /// Deletes item at a key present in [keys], from that [Storage].
  ///
  /// Example:
  /// ```dart
  /// await storage.deleteAll(keys: [
  ///     'key1',
  ///     'key2',
  ///     //...
  ///   ],
  /// );
  /// ```
  Future<void> deleteMany({List<String> keys = const []});

  /// Deletes all the values from that [Storage]
  Future<void> deleteAll();
}

/// A placeholder storage class when [LocalStorageType.none] is selected in env.dart.
class NoOpStorage implements Storage {
  @override
  Future<void> init() async {}

  @override
  Future<void> save({required String key, required String value}) async {}

  @override
  Future<void> saveMany({required Map<String, String> values}) async {}

  @override
  Future<String?> read({required String key}) async {
    return null;
  }

  @override
  Future<Map<String, String?>> readMany({required List<String> keys}) async {
    return {};
  }

  @override
  Future<Map<String, String?>> readAll() async {
    return {};
  }

  @override
  Future<void> delete({required String key}) async {}

  @override
  Future<void> deleteMany({List<String> keys = const []}) async {}

  @override
  Future<void> deleteAll() async {}
}
