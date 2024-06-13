import '../../../env.dart';
import 'services/base_service.dart';
import 'services/flutter_secure_storage.dart';
import 'services/hive.dart';
import 'services/no_op_storage.dart';

LocalStorageService get instanceLocal {
  final EnvironmentConfig envConfig = EnvironmentConfig.getEnvConfig();
  switch (envConfig.localStorageType) {
    case LocalStorageType.hive:
      return LocalStorageWithHive();
    case LocalStorageType.flutterSecureStorage:
      return LocalStorageWithFlutterSecureStorage();
    default:
      return NoOpStorage();
  }
}

abstract class LocalStorage {
  static final LocalStorageService _instanceLocal = instanceLocal;

  /// Initializes the [LocalStorage].
  /// In the case of [LocalStorageWithHive], it creates a [Directory] using the path_provide package,
  /// initializes hive at that directory and opens a box with name [name] provided during [LocalStorage]
  /// creation.
  /// It's not required in the case of [LocalStorageWithFlutterSecureStorage].
  ///
  /// Example:
  /// ```dart
  /// Storage.init();
  /// ```
  static Future<void> init() {
    return _instanceLocal.init();
  }

  /// Creates a new item in the [LocalStorage].
  ///
  /// To create a single key-value pair pass the [key] and the [value] as String, the
  /// String could be a JSON String or a simple text according to your requirement.
  /// If the key is already present in the [LocalStorage] it's vlaue will be overwritten.
  ///
  /// Example:
  /// ```dart
  /// await Storage.create(key: 'key', value: 'value');
  /// ```
  static Future<void> create(String name, {required String key, required String value}) {
    return _instanceLocal.create(key: key, value: value);
  }

  /// Creates new items in the [LocalStorage].
  /// If you want to create multiple entries pass the [values] as a Map<String, String>, then it
  /// will create all the key-value pairs from the [values] map.
  /// If any key from the [values] is already present in the [LocalStorage] it's value will be
  /// overwritten.
  ///
  /// Example:
  /// ```dart
  /// await Storage.createMany(values: {
  ///     'key1': 'Value1',
  ///     'key2': 'Value2',
  ///     'key3': 'Value3',
  ///     'key4': 'Value4',
  ///     'key5': 'Value5',
  ///     //...
  ///   },
  /// );
  /// ```
  static Future<void> createMany({required Map<String, String> values}) {
    return _instanceLocal.createMany(values: values);
  }

  /// Reads the value of the item at [key] from the [LocalStorage] and returns the value.
  ///
  /// Read a single value by passing [key] as String, it will return the value as String?.
  ///
  /// Example:
  /// ```dart
  /// await Storage.read(key: 'key');
  /// ```
  static Future<String?> read({required String key}) {
    return _instanceLocal.read(key: key);
  }

  /// Reads multiple values, pass the List of [keys] as argument. It will return the value as
  /// Map<String, String?>.
  ///
  /// Example:
  /// ```dart
  /// await Storage.readMany(keys: [
  ///     'key1',
  ///     'key2',
  ///     //...
  ///   ],
  /// );
  /// ```
  static Future<Map<String, String?>> readMany({required List<String> keys}) {
    return _instanceLocal.readMany(keys: keys);
  }

  /// It will return all the values from that [LocalStorage] as Map<String, String?>.
  static Future<Map<String, String?>> readAll() {
    return _instanceLocal.readAll();
  }

  /// Updates an item in the [LocalStorage].
  ///
  /// To update a single key-value pair pass the [key] and the [value] as String, the
  ///
  /// Example:
  /// ```dart
  /// await Storage.update(key: 'key', value: 'value');
  /// ```
  static Future<void> update({required String key, required String value}) {
    return _instanceLocal.update(key: key, value: value);
  }

  /// Updates items in the [LocalStorage].
  /// If you want to update multiple entries pass the [values] as a Map<String, String>, then it
  /// will update all the key-value pairs in the [values] map.
  ///
  /// Example:
  /// ```dart
  /// await Storage.updateMany(values: {
  ///     'key1': 'Value1',
  ///     'key2': 'Value2',
  ///     'key3': 'Value3',
  ///     'key4': 'Value4',
  ///     'key5': 'Value5',
  ///     //...
  ///   },
  /// );
  /// ```
  static Future<void> updateMany({required Map<String, String> values}) {
    return _instanceLocal.updateMany(values: values);
  }

  /// Creates or updates an item in the [LocalStorage].
  ///
  /// To create or update a single key-value pair pass the [key] and the [value] as String, the
  /// If the [key] is already present in the [LocalStorage] it's value will be overwritten.
  ///
  /// Example:
  /// ```dart
  /// await Storage.createOrUpdate(key: 'key', value: 'value');
  /// ```
  static Future<void> createOrUpdate({required String key, required String value}) {
    return _instanceLocal.createOrUpdate(key: key, value: value);
  }

  /// Creates or updates items in the [LocalStorage].
  /// If you want to create or update multiple entries pass the [values] as a Map<String, String>, then it
  /// will create all the key-value pairs from the [values] map.
  /// If any key from the [values] is already present in the [LocalStorage] it's value will be
  /// overwritten.
  ///
  /// Example:
  /// ```dart
  /// await Storage.createOrUpdateMany(values: {
  ///     'key1': 'Value1',
  ///     'key2': 'Value2',
  ///     'key3': 'Value3',
  ///     'key4': 'Value4',
  ///     'key5': 'Value5',
  ///     //...
  ///   },
  /// );
  /// ```
  static Future<void> createOrUpdateMany({required Map<String, String> values}) {
    return _instanceLocal.createOrUpdateMany(values: values);
  }

  /// Deletes an item at [key].
  ///
  /// Example:
  /// ```dart
  /// await Storage.delete(key: 'key');
  /// ```
  static Future<void> delete({required String key}) {
    return _instanceLocal.delete(key: key);
  }

  /// Deletes item at a key present in [keys], from that [LocalStorage].
  ///
  /// Example:
  /// ```dart
  /// await Storage.deleteMany(keys: [
  ///     'key1',
  ///     'key2',
  ///     //...
  ///   ],
  /// );
  /// ```
  static Future<void> deleteMany({List<String> keys = const []}) {
    return _instanceLocal.deleteMany(keys: keys);
  }

  /// Deletes all the values from that [LocalStorage]
  static Future<void> deleteAll() {
    return _instanceLocal.deleteAll();
  }
}
