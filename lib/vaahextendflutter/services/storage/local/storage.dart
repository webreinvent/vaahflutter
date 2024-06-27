import '../../../env/env.dart';
import '../../../env/storage.dart';
import 'services/base_service.dart';
import 'services/flutter_secure_storage.dart';
import 'services/hive.dart';
import 'services/no_op_storage.dart';

LocalStorageService get instanceLocal {
  final EnvironmentConfig envConfig = EnvironmentConfig.getConfig;
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

  /// Adds a new collection (which is basically a Hive Box) with [collectionName] in [LocalStorage].
  /// In the case of [LocalStorageWithHive], it opens a box with name [collectionName] provided.
  ///
  /// It's not required in the case of [LocalStorageWithFlutterSecureStorage].
  ///
  /// Throws an assertion error if [collectionName] exists already or empty [collectionName : ''].
  ///
  /// Example:
  /// ```dart
  /// LocalStorage.add('posts');
  /// //used only with Hive
  /// ```
  static void add(String collectionName) {
    return _instanceLocal.add(collectionName);
  }

  /// Creates a new item in the [collectionName] of [LocalStorage].
  ///
  /// To create a single key-value pair pass the [key] and the [value] as String, the
  /// String could be a JSON String or a simple text according to your requirement.
  ///
  /// Throws an assertion error if the key is already present in the [LocalStorage] or
  /// [collectionName] is not added.
  ///
  /// Try [LocalStorage.createOrUpdate], [LocalStorage.update].
  ///
  /// Example:
  ///
  /// Hive
  /// ```dart
  /// await LocalStorage.create(collectionName: 'posts',key: 'key', value: 'value');
  /// ```
  /// Flutter Secure Storage
  /// ```dart
  /// await LocalStorage.create(key: 'key', value: 'value');
  /// ```
  static Future<void> create({
    String collectionName = 'vaah-flutter-box',
    required String key,
    required String value,
  }) {
    return _instanceLocal.create(collectionName: collectionName, key: key, value: value);
  }

  /// Creates new items in the[collectionName] of [LocalStorage].
  /// If you want to create multiple entries pass the [values] as a Map<String, String>, then it
  /// will create all the key-value pairs from the [values] map.
  ///
  /// Throws an assertion error if the key is already present in the [LocalStorage] or
  /// [collectionName] is not added.
  ///
  /// Try [LocalStorage.createOrUpdateMany], [LocalStorage.updateMany].
  ///
  /// Example:
  ///
  /// Hive
  /// ```dart
  /// await LocalStorage.createMany(
  ///   collectionName: 'posts',
  ///   values: {
  ///       'key1': 'Value1',
  ///       'key2': 'Value2',
  ///       'key3': 'Value3',
  ///       'key4': 'Value4',
  ///       'key5': 'Value5',
  ///       //...
  ///   },
  /// );
  /// ```
  /// Flutter Secure Storage
  /// ```dart
  /// await LocalStorage.createMany(values: {
  ///     'key1': 'Value1',
  ///     'key2': 'Value2',
  ///     'key3': 'Value3',
  ///     'key4': 'Value4',
  ///     'key5': 'Value5',
  ///     //...
  ///   },
  /// );
  /// ```
  static Future<void> createMany({
    String collectionName = 'vaah-flutter-box',
    required Map<String, String> values,
  }) {
    return _instanceLocal.createMany(collectionName: collectionName, values: values);
  }

  /// Reads the value of the item at [key] from the [LocalStorage] and returns the value.
  ///
  /// Read a single value by passing [key] as String, it will return the value as String?.
  ///
  /// Throws an assertion error if [key] already exists or [collectionName] is not added.
  ///
  /// Try [LocalStorage.createOrUpdateMany], [LocalStorage.updateMany].
  ///
  /// Example:
  /// ```dart
  /// await LocalStorage.read(collectionName: 'posts', key: 'key');
  /// // Do not provide the collectionName in case of Flutter Secure Storage.
  /// ```
  static Future<String?> read({String collectionName = 'vaah-flutter-box', required String key}) {
    return _instanceLocal.read(collectionName: collectionName, key: key);
  }

  /// Reads multiple values from [collectionName], pass the List of [keys] as argument. It will
  /// return the value as Map<String, String?>.
  ///
  /// Example:
  /// ```dart
  /// await LocalStorage.readMany(
  ///   collectionName: 'posts',
  ///   keys: [
  ///     'key1',
  ///     'key2',
  ///     //...
  ///   ],
  /// );
  /// // Do not provide the collectionName in case of Flutter Secure Storage.
  /// ```
  static Future<Map<String, String?>> readMany({
    String collectionName = 'vaah-flutter-box',
    required List<String> keys,
  }) {
    return _instanceLocal.readMany(collectionName: collectionName, keys: keys);
  }

  /// It will return all the values from that collection [collectionName] of [LocalStorage] as
  /// Map<String, String?>.
  ///
  /// Exapmle:
  /// ```dart
  /// await LocalStorage.readAll(collectionName: 'posts');
  /// // Do not provide the collectionName in case of Flutter Secure Storage.
  /// ```
  static Future<Map<String, String?>> readAll({String collectionName = 'vaah-flutter-box'}) {
    return _instanceLocal.readAll(collectionName: collectionName);
  }

  /// Updates an item in [collectionName] of the [LocalStorage].
  ///
  /// To update a single key-value pair pass the [key] and the [value] as String.
  ///
  /// Throws asserstion error if [key] does not exists or [collectionName] is not added.
  ///
  /// Try [LocalStorage.createOrUpdate], [LocalStorage.create].
  ///
  /// Example:
  /// ```dart
  /// await LocalStorage.update(collectionName: 'posts', key: 'key', value: 'value');
  /// // Do not provide the collectionName in case of Flutter Secure Storage.
  /// ```
  static Future<void> update({
    String collectionName = 'vaah-flutter-box',
    required String key,
    required String value,
  }) {
    return _instanceLocal.update(collectionName: collectionName, key: key, value: value);
  }

  /// Updates items in [collectionName] of [LocalStorage].
  /// If you want to update multiple entries pass the [values] as a Map<String, String>, then it
  /// will update all the key-value pairs in the [values] map.
  ///
  /// Throws asserstion error if [key] does not exists or [collectionName] is not added.
  ///
  /// Try [LocalStorage.createOrUpdateMany], [LocalStorage.createMany].
  ///
  /// Example:
  /// ```dart
  /// await LocalStorage.updateMany(
  ///   collectionName: 'posts',
  ///   values: {
  ///     'key1': 'Value1',
  ///     'key2': 'Value2',
  ///     'key3': 'Value3',
  ///     'key4': 'Value4',
  ///     'key5': 'Value5',
  ///     //...
  ///   },
  /// );
  /// // Do not provide the collectionName in case of Flutter Secure Storage.
  /// ```
  static Future<void> updateMany({
    String collectionName = 'vaah-flutter-box',
    required Map<String, String> values,
  }) {
    return _instanceLocal.updateMany(collectionName: collectionName, values: values);
  }

  /// Creates or updates an item in [collectionName] of [LocalStorage].
  ///
  /// To create or update a single key-value pair pass the [key] and the [value] as String.
  ///
  /// Example:
  /// ```dart
  /// await LocalStorage.createOrUpdate(collectionName:'posts', key: 'key', value: 'value');
  /// // Do not provide the collectionName in case of Flutter Secure Storage.
  /// ```
  static Future<void> createOrUpdate({
    String collectionName = 'vaah-flutter-box',
    required String key,
    required String value,
  }) {
    return _instanceLocal.createOrUpdate(collectionName: collectionName, key: key, value: value);
  }

  /// Creates or updates items in [collectionName] of [LocalStorage].
  /// If you want to create or update multiple entries pass the [values] as a Map<String, String>, then it
  /// will create all the key-value pairs from the [values] map.
  /// If any key from the [values] is already present in the [collectionName] of [LocalStorage] it's value will be
  /// overwritten.
  ///
  /// Example:
  /// ```dart
  /// await LocalStorage.createOrUpdateMany(
  ///   collectionName:'posts',
  ///   values: {
  ///     'key1': 'Value1',
  ///     'key2': 'Value2',
  ///     'key3': 'Value3',
  ///     'key4': 'Value4',
  ///     'key5': 'Value5',
  ///     //...
  ///   },
  /// );
  /// // Do not provide the collectionName in case of Flutter Secure Storage.
  /// ```
  static Future<void> createOrUpdateMany({
    String collectionName = 'vaah-flutter-box',
    required Map<String, String> values,
  }) {
    return _instanceLocal.createOrUpdateMany(collectionName: collectionName, values: values);
  }

  /// Deletes an item at [key] from [collectionName] in [LocalStorage].
  ///
  /// Example:
  /// ```dart
  /// await LocalStorage.delete(collectionName:'posts', key: 'key');
  /// // Do not provide the collectionName in case of Flutter Secure Storage.
  /// ```
  static Future<void> delete({
    String collectionName = 'vaah-flutter-box',
    required String key,
  }) {
    return _instanceLocal.delete(collectionName: collectionName, key: key);
  }

  /// Deletes item at a key present in [keys], from [collectionName] in [LocalStorage].
  ///
  /// Example:
  /// ```dart
  /// await LocalStorage.deleteMany(
  ///   collectionName:'posts',
  ///   keys: [
  ///     'key1',
  ///     'key2',
  ///     //...
  ///   ],
  /// );
  /// // Do not provide the collectionName in case of Flutter Secure Storage.
  /// ```
  static Future<void> deleteMany({
    String collectionName = 'vaah-flutter-box',
    List<String> keys = const [],
  }) {
    return _instanceLocal.deleteMany(collectionName: collectionName, keys: keys);
  }

  /// Deletes all the values from [collectionName] in [LocalStorage].
  ///
  /// Example:
  /// ```dart
  /// await LocalStorage.deleteMany(
  ///   collectionName:'posts',
  ///   keys: [
  ///     'key1',
  ///     'key2',
  ///     //...
  ///   ],
  /// );
  /// // Do not provide the collectionName in case of Flutter Secure Storage.
  /// ```
  static Future<void> deleteAll({String collectionName = 'vaah-flutter-box'}) {
    return _instanceLocal.deleteAll(collectionName: collectionName);
  }
}
