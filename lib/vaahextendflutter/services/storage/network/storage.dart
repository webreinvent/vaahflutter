import '../../../env.dart';
import 'services/base_service.dart';
import 'services/firebase_firestore.dart';
import 'services/no_op_storage.dart';
import 'services/supabase.dart';

NetworkStorageService get instanceNetwork {
  EnvironmentConfig envConfig = EnvironmentConfig.getEnvConfig();
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
  /// Throws if the [key] is already present.
  /// Also throws if table [collectionName] does not exist in supabase.
  ///
  /// Example:
  /// ```dart
  /// await NetworkStorage.create(
  ///   collectionName: 'users-collection',
  ///   key: 'dave', value: {
  ///     'name': 'Dave',
  ///     'age': 30,
  ///     'email': 'x@yz.com',
  ///   },
  /// );
  /// ```
  static Future<void> create({
    String collectionName = _vaahFlutterCollection,
    required String key,
    required Map<String, dynamic> value,
  }) async {
    return _instanceNetwork.create(collectionName: collectionName, key: key, value: value);
  }

  /// Creates new items in the [collectionName] of [NetworkStorage].
  /// If you want to create multiple entries, pass the [values] as a Map<String, Map<String, dynamic>>,
  /// then it will create all the key-value pairs from the [values] map.
  ///
  /// Throws if any key from [values.keys] is already present.
  /// Also throws if table [collectionName] does not exist in supabase.
  ///
  /// Example:
  /// ```dart
  /// await NetworkStorage.createMany(
  ///    collectionName: 'users-collection',
  ///    values: {
  ///      'john': {'name': 'John', 'age': 30, 'email': 'x@yz.com'},
  ///      'rock': {'name': 'Rock', 'age': 30, 'email': 'x@yz.com'},
  ///      'sean': {'name': 'sean', 'age': 30, 'email': 'x@yz.com'},
  ///    },
  ///  );
  /// ```
  static Future<void> createMany({
    String collectionName = _vaahFlutterCollection,
    required Map<String, Map<String, dynamic>> values,
  }) async {
    return _instanceNetwork.createMany(collectionName: collectionName, values: values);
  }

  /// Reads the value of the item at [key] from the [NetworkStorage] and returns the value.
  ///
  /// Read a single value by passing [key] as String, it will return the value as
  /// Map<String, dynamic>?.
  ///
  /// Throws if [key] does not exist.
  /// Also throws if table [collectionName] does not exist is supabase.
  ///
  /// Example:
  /// ```dart
  /// final data = await NetworkStorage.read(collectionName: 'users-collection', key: 'dave');
  /// ```
  static Future<Map<String, dynamic>?> read({
    String collectionName = _vaahFlutterCollection,
    required String key,
  }) async {
    return _instanceNetwork.read(collectionName: collectionName, key: key);
  }

  /// Reads multiple values from [collectionName], pass the List of [keys] as an argument. It will
  /// return the value as Map<String, Map<String, dynamic>?>.
  ///
  /// Example:
  /// ```dart
  /// await NetworkStorage.readMany(
  ///   collectionName: 'users-collection',
  ///   keys: ['dave', 'john', 'sean'],
  /// );
  /// ```
  static Future<Map<String, Map<String, dynamic>?>> readMany({
    String collectionName = _vaahFlutterCollection,
    required List<String> keys,
  }) async {
    return _instanceNetwork.readMany(collectionName: collectionName, keys: keys);
  }

  /// Returns all the values from the [collectionName] as Map<String, Map<String, dynamic>?>.
  ///
  /// Example:
  /// ```dart
  /// await NetworkStorage.readAll(collectionName: 'users-collection');
  /// ```
  static Future<Map<String, Map<String, dynamic>?>> readAll({required String collectionName}) {
    return _instanceNetwork.readAll(collectionName: collectionName);
  }

  /// Updates an item in the [collectionName].
  ///
  /// To update a single key-value pair, pass the [key] and the [value].
  ///
  /// Throws if [key] does not exist.
  /// Also throws if table [collectionName] does not exist in supabase.
  ///
  /// Example:
  /// ```dart
  /// await NetworkStorage.update(
  ///   collectionName: 'users-collection',
  ///   key: 'sean',
  ///   value: {'name': 'Sean'},
  /// );
  /// ```
  static Future<void> update({
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
  /// Throws if [key] does not exist.
  /// Also throws if table [collectionName] does not exist in supabase.
  ///
  /// Example:
  /// ```dart
  /// await NetworkStorage.updateMany(
  ///   collectionName: 'users-collection',
  ///   values: {
  ///     'dave': {'name': 'Dave', 'age': 31, 'email': 'x@yz.com'},
  ///     'rock': {'name': 'Rock', 'age': 31, 'email': 'x@yz.com'},
  ///     'sean': {'name': 'Sean', 'age': 31, 'email': 'x@yz.com'},
  ///   },
  /// );
  /// ```
  static Future<void> updateMany({
    String collectionName = _vaahFlutterCollection,
    required Map<String, Map<String, dynamic>> values,
  }) async {
    return _instanceNetwork.updateMany(collectionName: collectionName, values: values);
  }

  static Future<void> createOrUpdate({
    String collectionName = _vaahFlutterCollection,
    required String key,
    required Map<String, dynamic> value,
  }) async {
    return _instanceNetwork.createOrUpdate(collectionName: collectionName, key: key, value: value);
  }

  static Future<void> createOrUpdateMany({
    String collectionName = _vaahFlutterCollection,
    required Map<String, Map<String, dynamic>> values,
  }) async {
    return _instanceNetwork.createOrUpdateMany(collectionName: collectionName, values: values);
  }

  static Future<void> delete({
    String collectionName = _vaahFlutterCollection,
    required String key,
  }) async {
    return _instanceNetwork.delete(collectionName: collectionName, key: key);
  }

  static Future<void> deleteMany({
    String collectionName = _vaahFlutterCollection,
    required List<String> keys,
  }) async {
    return _instanceNetwork.deleteMany(collectionName: collectionName, keys: keys);
  }

  static Future<void> deleteAll({
    String collectionName = _vaahFlutterCollection,
  }) async {
    return _instanceNetwork.deleteAll(collectionName: collectionName);
  }
}
