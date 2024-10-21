import '../../../env/env.dart';
import '../../../env/storage.dart';
import '../storage_response.dart';
import '../storage_error.dart';
import 'services/base_service.dart';
import 'services/firebase_firestore.dart';
import 'services/no_op_storage.dart';
import 'services/supabase.dart';

NetworkStorageService get instanceNetwork {
  EnvironmentConfig envConfig = EnvironmentConfig.getConfig;
  switch (envConfig.networkStorageType) {
    case NetworkStorageType.firebase:
      return NetworkStorageWithFirestore();
    case NetworkStorageType.supabase:
      return NetworkStorageWithSupabase();
    default:
      return NoOpNetworkStorage();
  }
}

abstract class NetworkStorage {
  static final NetworkStorageService _instanceNetwork = instanceNetwork;
  static const String _vaahFlutterCollection = 'vaah-flutter-collection';

  /// Creates a new item in the [collectionName].
  ///
  /// To create a single key-value pair, pass the [key] and the [value] as a Map<String, dynamic>.
  ///
  /// Returns an instance of [StorageResponse].
  ///
  /// Check [StorageResponse] and [StorageError]
  ///
  /// Example:
  /// ```dart
  /// final response = await NetworkStorage.create(
  ///   collectionName: 'users-collection',
  ///   key: 'dave', value: {
  ///     'name': 'Dave',
  ///     'age': 30,
  ///     'email': 'x@yz.com',
  ///   },
  /// );
  ///
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
    String collectionName = _vaahFlutterCollection,
    required String key,
    required Map<String, dynamic> value,
  }) async {
    return _instanceNetwork.create(collectionName: collectionName, key: key, value: value);
  }

  /// Creates new items in the [collectionName].
  /// If you want to create multiple entries, pass the [values] as a
  /// Map<String, Map<String, dynamic>>, then it will create all the key-value pairs from the
  /// [values] map.
  ///
  /// Returns an instance of [StorageResponse].
  ///
  /// Check [StorageResponse] and [StorageError]
  ///
  /// Example:
  /// ```dart
  /// final response = await NetworkStorage.createMany(
  ///    collectionName: 'users-collection',
  ///    values: {
  ///      'john': {'name': 'John', 'age': 30, 'email': 'x@yz.com'},
  ///      'rock': {'name': 'Rock', 'age': 30, 'email': 'x@yz.com'},
  ///      'sean': {'name': 'sean', 'age': 30, 'email': 'x@yz.com'},
  ///    },
  ///  );
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
    String collectionName = _vaahFlutterCollection,
    required Map<String, Map<String, dynamic>> values,
  }) async {
    return _instanceNetwork.createMany(collectionName: collectionName, values: values);
  }

  /// Reads the value of the item at [key] and returns the value.
  ///
  /// Read a single value by passing [key] as String, it will return the value as
  /// Map<String, dynamic>? you can read it by using [StorageResponse.data].
  ///
  /// Returns an instance of [StorageResponse].
  ///
  /// Check [StorageResponse] and [StorageError]
  ///
  /// Example:
  /// ```dart
  /// final response = await NetworkStorage.read(collectionName: 'users-collection', key: 'dave');
  ///
  /// if(response.isSuccess){
  ///   response.hasData; // true
  ///   response.hasError; // false
  ///   response.message; // message for successful read
  ///   response.data; // entry that is read successfully: Map<String, dynamic>
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
  static Future<StorageResponse> read({
    String collectionName = _vaahFlutterCollection,
    required String key,
  }) async {
    return _instanceNetwork.read(collectionName: collectionName, key: key);
  }

  /// Reads multiple values from [collectionName], pass the List of [keys]. It will return the
  /// value as Map<String, Map<String, dynamic>?> you can read it by using [StorageResponse.data].
  ///
  /// Returns an instance of [StorageResponse].
  ///
  /// Check [StorageResponse] and [StorageError].
  ///
  /// Example:
  /// ```dart
  /// final response = await NetworkStorage.readMany(
  ///   collectionName: 'users-collection',
  ///   keys: ['dave', 'john', 'sean'],
  /// );
  ///
  /// if(response.isSuccess){
  ///   response.hasData; // true
  ///   response.hasError; // false
  ///   response.message; // message for successful read
  ///   response.data; // Entries that are read successfully: Map<String, Map<String, dynamic>?>
  ///   response.errors; // null
  /// } else if(response.isPartialSuccess){
  ///     response.hasData; // true
  ///     response.hasError; // true
  ///     response.message; // message for partial read
  ///     response.data; // entries that are read successfully: Map<String, Map<String, dynamic>?>
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
  static Future<StorageResponse> readMany({
    String collectionName = _vaahFlutterCollection,
    required List<String> keys,
  }) async {
    return _instanceNetwork.readMany(collectionName: collectionName, keys: keys);
  }

  /// Returns all the values from the [collectionName] as Map<String, Map<String, dynamic>?> you can
  /// read it by using [StorageResponse.data].
  ///
  /// Returns an instance of [StorageResponse].
  ///
  /// Check [StorageResponse] and [StorageError].
  ///
  ///
  /// Example:
  /// ```dart
  /// final response = await NetworkStorage.readAll(collectionName: 'users-collection');
  ///
  /// if(response.isSuccess){
  ///   response.hasData; // true
  ///   response.hasError; // false
  ///   response.message; // message for successful read
  ///   response.data; // all entries available in that collection: Map<String, Map<String, dynamic>?>
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
  static Future<StorageResponse> readAll({required String collectionName}) {
    return _instanceNetwork.readAll(collectionName: collectionName);
  }

  /// Updates an item in the [collectionName].
  ///
  /// To update a single key-value pair, pass the [key] and the [value].
  ///
  /// Returns an instance of [StorageResponse].
  ///
  /// Check [StorageResponse] and [StorageError].
  ///
  /// Example:
  /// ```dart
  /// final response = await NetworkStorage.update(
  ///   collectionName: 'users-collection',
  ///   key: 'sean',
  ///   value: {'name': 'Sean'},
  /// );
  ///
  /// if(response.isSuccess){
  ///   response.hasData; // true
  ///   response.hasError; // false
  ///   response.message; // message for successful update
  ///   response.data; // key of the entry that was updated successfully
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
    required String collectionName,
    required String key,
    required Map<String, dynamic> value,
  }) async {
    return _instanceNetwork.update(collectionName: collectionName, key: key, value: value);
  }

  /// Updates items in the [collectionName].
  /// If you want to update multiple entries, pass the [values] as a
  /// Map<String, Map<String, dynamic>>, then it will update all the key-value pairs in the
  /// [values] map.
  ///
  /// Returns an instance of [StorageResponse].
  ///
  /// Check [StorageResponse] and [StorageError].
  ///
  /// Example:
  /// ```dart
  /// final response = await NetworkStorage.updateMany(
  ///   collectionName: 'users-collection',
  ///   values: {
  ///     'dave': {'name': 'Dave', 'age': 31, 'email': 'x@yz.com'},
  ///     'rock': {'name': 'Rock', 'age': 31, 'email': 'x@yz.com'},
  ///     'sean': {'name': 'Sean', 'age': 31, 'email': 'x@yz.com'},
  ///   },
  /// );
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
    String collectionName = _vaahFlutterCollection,
    required Map<String, Map<String, dynamic>> values,
  }) async {
    return _instanceNetwork.updateMany(collectionName: collectionName, values: values);
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
  /// finla response = await NetworkStorage.createOrUpdate(
  ///    collectionName: 'users-collection',
  ///    key: 'sean',
  ///    value: {'age': 34, 'email': 't@email.com'},
  ///  ); // will get updated if the key 'sean' exists.
  ///
  /// if(response.isSuccess){
  ///   response.hasData; // true
  ///   response.hasError; // false
  ///   response.message; // message for successful creation or update
  ///   response.data; // key of the entry that was created or updated successfully: Map<String, Map<String, dynamic>?>
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
    String collectionName = _vaahFlutterCollection,
    required String key,
    required Map<String, dynamic> value,
  }) async {
    return _instanceNetwork.createOrUpdate(collectionName: collectionName, key: key, value: value);
  }

  /// Creates or updates multiple items in the [collectionName].
  /// If you want to create or update multiple entries, pass the [values] as a
  /// Map<String, Map<String, dynamic>>, then it will create all the key-value pairs from the
  /// [values] map. If any key from the [values.keys] exits it's value will be updated otherwise a
  /// new entry will be created.
  ///
  /// Returns an instance of [StorageResponse].
  ///
  /// Partial success is only possible when you use this method with supabase selected.
  ///
  /// Check [StorageResponse] and [StorageError].
  ///
  /// Example:
  /// ```dart
  ///  final response = await NetworkStorage.createOrUpdateMany(
  ///    collectionName: 'users-collection',
  ///    values: {
  ///      'dave': {'name': 'Dave', 'age': 38, 'email': 'y@xz.com'},
  ///      'sina': {'name': 'Sina', 'age': 32, 'email': 'y@xz.com'},
  ///      'rock': {'name': 'Rock', 'age': 32, 'email': 'y@xz.com'},
  ///      'sean': {'name': 'Sean'},
  ///    },
  ///  );
  ///
  /// if(response.isSuccess){
  ///   response.hasData; // true
  ///   response.hasError; // false
  ///   response.message; // message for successful create or update
  ///   response.data; // keys of the entries that were create or updated successfully
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
    String collectionName = _vaahFlutterCollection,
    required Map<String, Map<String, dynamic>> values,
  }) async {
    return _instanceNetwork.createOrUpdateMany(collectionName: collectionName, values: values);
  }

  /// Deletes an item at [key] from [collectionName].
  ///
  /// Returns an instance of [StorageResponse].
  ///
  /// Check [StorageResponse] and [StorageError].
  ///
  /// Example:
  /// ```dart
  /// final response = await NetworkStorage.delete(collectionName: 'users-collection', key: 'sean');
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
    String collectionName = _vaahFlutterCollection,
    required String key,
  }) async {
    return _instanceNetwork.delete(collectionName: collectionName, key: key);
  }

  /// Deletes items at keys present in [keys], from [collectionName].
  ///
  /// Partial success is not possible.
  ///
  /// Returns an instance of [StorageResponse].
  ///
  /// Check [StorageResponse] and [StorageError].
  ///
  /// Example:
  /// ```dart
  /// await NetworkStorage.deleteMany(
  ///    collectionName: 'users-collection',
  ///     keys: ['dave', 'sean', 'sina'],
  ///  );
  ///
  /// if(response.isSuccess){
  ///   response.hasData; // true
  ///   response.hasError; // false
  ///   response.message; // message for successful delete
  ///   response.data; // keys of the entries that were deleted successfully
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
  static Future<StorageResponse> deleteMany({
    String collectionName = _vaahFlutterCollection,
    required List<String> keys,
  }) async {
    return _instanceNetwork.deleteMany(collectionName: collectionName, keys: keys);
  }

  /// Deletes all the values from [collectionName].
  ///
  /// Example:
  /// ```dart
  /// final response = await NetworkStorage.deleteAll(collectionName: 'users-collection');
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
  /// ```
  static Future<StorageResponse> deleteAll({
    String collectionName = _vaahFlutterCollection,
  }) async {
    return _instanceNetwork.deleteAll(collectionName: collectionName);
  }
}
