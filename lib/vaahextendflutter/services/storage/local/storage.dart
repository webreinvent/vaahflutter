import '../../../env/env.dart';
import '../../../env/storage.dart';
import '../storage_response.dart';
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
  static const defaultCollectionName = 'vaah-flutter-box';

  /// Adds a new collection (which is basically a Hive Box) with [collectionName] in [LocalStorage].
  /// In the case of [LocalStorageWithHive], it opens a box with name [collectionName] provided.
  ///
  /// It's not required in the case of [LocalStorageWithFlutterSecureStorage].
  ///
  /// Returns an instance of [StorageResponse].
  ///
  /// Check [StorageResponse] and [StorageError]
  ///
  /// Example:
  /// ```dart
  /// LocalStorage.add('posts');
  /// //used only with Hive
  ///
  /// if(response.isSuccess){
  ///   response.hasData; // true
  ///   response.hasError; // false
  ///   response.message; // message for successful creation
  ///   response.data; // name of collection created successfully
  ///   response.errors; // null
  /// } else if(!response.isPartialSuccess && !response.isSuccess){ // complete failure
  ///     response.hasData; // false
  ///     response.hasError; // true
  ///     response.message; // ''
  ///     response.data; // null
  ///     response.errors; // List<StorageError>
  /// }
  ///
  /// ```
  static StorageResponse add(String collectionName) {
    return _instanceLocal.add(collectionName);
  }

  /// Creates a new item in the [collectionName].
  ///
  /// To create a single key-value pair, pass the [key] and the [value] as String.
  ///
  /// Returns an instance of [StorageResponse].
  ///
  /// Check [StorageResponse] and [StorageError]
  ///
  /// Example:
  ///
  /// * Hive
  /// ```dart
  /// final response = await LocalStorage.create(
  ///   collectionName: 'posts',
  ///   key: 'key',
  ///   value: 'value',
  /// );
  /// ```
  /// * Flutter Secure Storage
  /// ```dart
  /// final response = await LocalStorage.create(key: 'key', value: 'value');
  /// ```
  /// * Usage
  /// ```dart
  /// if(response.isSuccess){
  ///   response.hasData; // true
  ///   response.hasError; // false
  ///   response.message; // message for successful creation
  ///   response.data; // key of entry that was created successfully
  ///   response.errors; // null
  /// } else if(!response.isPartialSuccess && !response.isSuccess){ // complete failure
  ///     response.hasData; // false
  ///     response.hasError; // true
  ///     response.message; // ''
  ///     response.data; // null
  ///     response.errors; // List<StorageError>
  /// }
  ///
  /// ```
  static Future<StorageResponse> create({
    String collectionName = defaultCollectionName,
    required String key,
    required String value,
  }) {
    return _instanceLocal.create(collectionName: collectionName, key: key, value: value);
  }

  /// Creates new items in the [collectionName].
  /// If you want to create multiple entries, pass the [values] as Map<String, String>, then it will
  /// create all the key-value pairs from the [values] map.
  ///
  /// Returns an instance of [StorageResponse].
  ///
  /// Check [StorageResponse] and [StorageError]
  ///
  /// Try [LocalStorage.createOrUpdateMany], [LocalStorage.updateMany].
  ///
  /// Example:
  ///
  /// * Hive
  /// ```dart
  /// final response = await LocalStorage.createMany(
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
  /// * Flutter Secure Storage
  /// ```dart
  /// final response = await LocalStorage.createMany(values: {
  ///     'key1': 'Value1',
  ///     'key2': 'Value2',
  ///     'key3': 'Value3',
  ///     'key4': 'Value4',
  ///     'key5': 'Value5',
  ///     //...
  ///   },
  /// );
  ///
  /// if(response.isSuccess){
  ///   response.hasData; // true
  ///   response.hasError; // false
  ///   response.message; // message for successful creation
  ///   response.data; // keys of the entries that were created successfully
  ///   response.errors; // null
  /// } else if(response.isPartialSuccess){
  ///     response.hasData; // true
  ///     response.hasError; // true
  ///     response.message; // message for partial creation
  ///     response.data; // keys of the entries that were created successfully
  ///     response.errors; // List<StorageError>
  /// } else { // complete failure
  ///     response.hasData; // false
  ///     response.hasError; // true
  ///     response.message; // ''
  ///     response.data; // null
  ///     response.errors; // List<StorageError>
  /// }
  ///
  /// ```
  static Future<StorageResponse> createMany({
    String collectionName = defaultCollectionName,
    required Map<String, String> values,
  }) {
    return _instanceLocal.createMany(collectionName: collectionName, values: values);
  }

  /// Reads the value of the item at [key].
  ///
  /// Read a single value by passing [key] as String, it will return the value as
  /// String you can read it by using [StorageResponse.data].
  ///
  /// Returns an instance of [StorageResponse].
  ///
  /// Check [StorageResponse] and [StorageError]
  ///
  /// Example:
  ///
  /// ```dart
  /// final response = await LocalStorage.read(collectionName: 'posts', key: 'key');
  /// // Do not provide the collectionName in case of Flutter Secure Storage.
  ///
  /// if(response.isSuccess){
  ///   response.hasData; // true
  ///   response.hasError; // false
  ///   response.message; // message for successful read
  ///   response.data; // entry that is read successfully: String
  ///   response.errors; // null
  /// } else if(!response.isPartialSuccess && !response.isSuccess){ // complete failure
  ///     response.hasData; // false
  ///     response.hasError; // true
  ///     response.message; // ''
  ///     response.data; // null
  ///     response.errors; // List<StorageError>
  /// }
  /// ```
  static Future<StorageResponse> read({
    String collectionName = defaultCollectionName,
    required String key,
  }) {
    return _instanceLocal.read(collectionName: collectionName, key: key);
  }

  /// Reads multiple values from [collectionName], pass the List of [keys]. It will return the
  /// value as Map<String, String> you can read it by using [StorageResponse.data].
  ///
  /// Returns an instance of [StorageResponse].
  ///
  /// Check [StorageResponse] and [StorageError].
  ///
  /// Example:
  /// ```dart
  /// final response = await LocalStorage.readMany(
  ///   collectionName: 'posts',
  ///   keys: [
  ///     'key1',
  ///     'key2',
  ///     //...
  ///   ],
  /// ); // Do not provide the collectionName in case of Flutter Secure Storage.
  ///
  /// if(response.isSuccess){
  ///   response.hasData; // true
  ///   response.hasError; // false
  ///   response.message; // message for successful read
  ///   response.data; // Entries that are read successfully: Map<String, String>
  ///   response.errors; // null
  /// } else if(response.isPartialSuccess){
  ///     response.hasData; // true
  ///     response.hasError; // true
  ///     response.message; // message for partial read
  ///     response.data; // entries that are read successfully: Map<String, String>
  ///     response.errors; // List<StorageError>
  /// } else { // complete failure
  ///     response.hasData; // false
  ///     response.hasError; // true
  ///     response.message; // ''
  ///     response.data; // null
  ///     response.errors; // List<StorageError>
  /// }
  /// ```
  static Future<StorageResponse> readMany({
    String collectionName = defaultCollectionName,
    required List<String> keys,
  }) {
    return _instanceLocal.readMany(collectionName: collectionName, keys: keys);
  }

  /// Returns all the values from the [collectionName] as Map<String, String> you can
  /// read it by using [StorageResponse.data].
  ///
  /// Returns an instance of [StorageResponse].
  ///
  /// Check [StorageResponse] and [StorageError].
  ///
  /// Exapmle:
  /// ```dart
  /// final response = await LocalStorage.readAll(collectionName: 'posts');
  /// // Do not provide the collectionName in case of Flutter Secure Storage.
  ///
  /// if(response.isSuccess){
  ///   response.hasData; // true
  ///   response.hasError; // false
  ///   response.message; // message for successful read
  ///   response.data; // all entries available in that collection: Map<String, String>
  ///   response.errors; // null
  /// } else if(!response.isPartialSuccess && !response.isSuccess){ // complete failure
  ///     response.hasData; // false
  ///     response.hasError; // true
  ///     response.message; // ''
  ///     response.data; // null
  ///     response.errors; // List<StorageError>
  /// }
  ///
  /// ```
  static Future<StorageResponse> readAll({String collectionName = defaultCollectionName}) {
    return _instanceLocal.readAll(collectionName: collectionName);
  }

  /// Updates an item in the [collectionName].
  ///
  /// To update a single key-value pair, pass the [key] and the [value].
  ///
  /// Returns an instance of [StorageResponse].
  ///
  /// Check [StorageResponse] and [StorageError].
  ///
  /// Try [LocalStorage.createOrUpdate], [LocalStorage.create].
  ///
  /// Example:
  /// ```dart
  /// await LocalStorage.update(collectionName: 'posts', key: 'key', value: 'value');
  /// // Do not provide the collectionName in case of Flutter Secure Storage.
  ///
  /// if(response.isSuccess){
  ///   response.hasData; // true
  ///   response.hasError; // false
  ///   response.message; // message for successful update
  ///   response.data; // key of the entry that was updated successfully.
  ///   response.errors; // null
  /// } else if(!response.isPartialSuccess && !response.isSuccess){ // complete failure
  ///     response.hasData; // false
  ///     response.hasError; // true
  ///     response.message; // ''
  ///     response.data; // null
  ///     response.errors; // List<StorageError>
  /// }
  ///
  /// ```
  static Future<StorageResponse> update({
    String collectionName = defaultCollectionName,
    required String key,
    required String value,
  }) {
    return _instanceLocal.update(collectionName: collectionName, key: key, value: value);
  }

  /// Updates items in the [collectionName].
  /// If you want to update multiple entries, pass the [values] as Map<String, String>, then it will
  /// update all the key-value pairs in the [values] map.
  ///
  /// Returns an instance of [StorageResponse].
  ///
  /// Check [StorageResponse] and [StorageError].
  ///
  /// Try [LocalStorage.createOrUpdateMany], [LocalStorage.createMany].
  ///
  /// Example:
  /// ```dart
  /// final response = await LocalStorage.updateMany(
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
  ///
  /// if(response.isSuccess){
  ///   response.hasData; // true
  ///   response.hasError; // false
  ///   response.message; // message for successful update
  ///   response.data; // keys of the entries that were updated successfully
  ///   response.errors; // null
  /// } else if(response.isPartialSuccess){
  ///     response.hasData; // true
  ///     response.hasError; // true
  ///     response.message; // message for partial update
  ///     response.data; // keys of the entries that were updated successfully
  ///     response.errors; // List<StorageError>
  /// } else { // complete failure
  ///     response.hasData; // false
  ///     response.hasError; // true
  ///     response.message; // ''
  ///     response.data; // null
  ///     response.errors; // List<StorageError>
  /// }
  ///
  /// ```
  static Future<StorageResponse> updateMany({
    String collectionName = defaultCollectionName,
    required Map<String, String> values,
  }) {
    return _instanceLocal.updateMany(collectionName: collectionName, values: values);
  }

  /// Creates or updates an item in the [collectionName].
  ///
  /// To create or update a single key-value pair, pass the [key] and the [value]. If the [key] is
  /// present it's value will be updated otherwise a new entry will be created.
  ///
  /// Returns an instance of [StorageResponse].
  ///
  /// Check [StorageResponse] and [StorageError].
  ///
  /// Example:
  /// ```dart
  /// final response = await LocalStorage.createOrUpdate(collectionName:'posts', key: 'key', value: 'value');
  /// // Do not provide the collectionName in case of Flutter Secure Storage.
  ///
  /// if(response.isSuccess){
  ///   response.hasData; // true
  ///   response.hasError; // false
  ///   response.message; // message for successful creation or update
  ///   response.data; // key of the entry that was created or updated successfully
  ///   response.errors; // null
  /// } else if(!response.isPartialSuccess && !response.isSuccess){ // complete failure
  ///     response.hasData; // false
  ///     response.hasError; // true
  ///     response.message; // ''
  ///     response.data; // null
  ///     response.errors; // List<StorageError>
  /// }
  ///
  /// ```
  static Future<StorageResponse> createOrUpdate({
    String collectionName = defaultCollectionName,
    required String key,
    required String value,
  }) {
    return _instanceLocal.createOrUpdate(collectionName: collectionName, key: key, value: value);
  }

  /// Creates or updates multiple items in the [collectionName].
  /// If you want to create or update multiple entries, pass the [values] as a Map<String, String>,
  /// then it will create all the key-value pairs from the [values] map. If any key from the
  /// [values.keys] exits it's value will be updated otherwise a new entry will be created.
  ///
  /// Returns an instance of [StorageResponse].
  ///
  /// Example:
  /// ```dart
  /// final response = await LocalStorage.createOrUpdateMany(
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
  ///
  /// if(response.isSuccess){
  ///   response.hasData; // true
  ///   response.hasError; // false
  ///   response.message; // message for successful create or update
  ///   response.data; // keys of the entries that were created or updated successfully
  ///   response.errors; // null
  /// } else if(response.isPartialSuccess){
  ///     response.hasData; // true
  ///     response.hasError; // true
  ///     response.message; // message for partial create or update
  ///     response.data; // keys of the entries that were created or updated successfully
  ///     response.errors; // List<StorageError>
  /// } else { // complete failure
  ///     response.hasData; // false
  ///     response.hasError; // true
  ///     response.message; // ''
  ///     response.data; // null
  ///     response.errors; // List<StorageError>
  /// }
  ///
  /// ```
  static Future<StorageResponse> createOrUpdateMany({
    String collectionName = defaultCollectionName,
    required Map<String, String> values,
  }) {
    return _instanceLocal.createOrUpdateMany(collectionName: collectionName, values: values);
  }

  /// Deletes an item at [key] from [collectionName].
  ///
  /// Returns an instance of [StorageResponse].
  ///
  /// Check [StorageResponse] and [StorageError].
  ///
  /// Example:
  /// ```dart
  /// final response = await LocalStorage.delete(collectionName:'posts', key: 'key');
  /// // Do not provide the collectionName in case of Flutter Secure Storage.
  ///
  /// if(response.isSuccess){
  ///   response.hasData; // true
  ///   response.hasError; // false
  ///   response.message; // message for successful delete
  ///   response.data; // key of the entry that was deleted successfully
  ///   response.errors; // null
  /// } else if(!response.isPartialSuccess && !response.isSuccess){ // complete failure
  ///     response.hasData; // false
  ///     response.hasError; // true
  ///     response.message; // ''
  ///     response.data; // null
  ///     response.errors; // List<StorageError>
  /// }
  ///
  /// ```
  static Future<StorageResponse> delete({
    String collectionName = defaultCollectionName,
    required String key,
  }) {
    return _instanceLocal.delete(collectionName: collectionName, key: key);
  }

  /// Deletes entry at a key present in [keys], from [collectionName] in [LocalStorage].
  ///
  /// Returns an instance of [StorageResponse].
  ///
  /// Check [StorageResponse] and [StorageError].
  ///
  ///
  /// Example:
  /// ```dart
  /// final response = await LocalStorage.deleteMany(
  ///   collectionName:'posts',
  ///   keys: [
  ///     'key1',
  ///     'key2',
  ///     //...
  ///   ],
  /// );
  /// // Do not provide the collectionName in case of Flutter Secure Storage.
  ///
  /// if(response.isSuccess){
  ///   response.hasData; // true
  ///   response.hasError; // false
  ///   response.message; // message for successful update
  ///   response.data; // keys of the entries that were deleted successfully
  ///   response.errors; // null
  /// } else if(response.isPartialSuccess){
  ///     response.hasData; // true
  ///     response.hasError; // true
  ///     response.message; // message for partial update
  ///     response.data; // keys of the entries that were deleted successfully
  ///     response.errors; // List<StorageError>
  /// } else { // complete failure
  ///     response.hasData; // false
  ///     response.hasError; // true
  ///     response.message; // ''
  ///     response.data; // null
  ///     response.errors; // List<StorageError>
  /// }
  ///
  /// ```
  static Future<StorageResponse> deleteMany({
    String collectionName = defaultCollectionName,
    List<String> keys = const [],
  }) {
    return _instanceLocal.deleteMany(collectionName: collectionName, keys: keys);
  }

  /// Deletes all the entries from [collectionName] in [LocalStorage].
  ///
  /// Returns an instance of [StorageResponse].
  ///
  /// Check [StorageResponse] and [StorageError].
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
  ///
  /// if(response.isSuccess){
  ///   response.hasData; // false
  ///   response.hasError; // false
  ///   response.message; // message for successful delete
  ///   response.data; // null
  ///   response.errors; // null
  /// } else if(!response.isPartialSuccess && !response.isSuccess){ // complete failure
  ///     response.hasData; // false
  ///     response.hasError; // true
  ///     response.message; // ''
  ///     response.data; // null
  ///     response.errors; // List<StorageError>
  /// }
  ///
  /// ```
  static Future<StorageResponse> deleteAll({String collectionName = defaultCollectionName}) {
    return _instanceLocal.deleteAll(collectionName: collectionName);
  }
}
