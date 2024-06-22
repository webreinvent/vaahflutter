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

  static Future<void> create({
    String collectionName = _vaahFlutterCollection,
    required String key,
    required Map<String, dynamic> value,
  }) async {
    return _instanceNetwork.create(collectionName: collectionName, key: key, value: value);
  }

  static Future<void> createMany({
    String collectionName = _vaahFlutterCollection,
    required Map<String, Map<String, dynamic>> values,
  }) async {
    return _instanceNetwork.createMany(collectionName: collectionName, values: values);
  }

  static Future<Map<String, dynamic>?> read({
    String collectionName = _vaahFlutterCollection,
    required String key,
  }) async {
    return _instanceNetwork.read(collectionName: collectionName, key: key);
  }

  static Future<Map<String, Map<String, dynamic>?>> readMany({
    String collectionName = _vaahFlutterCollection,
    required List<String> keys,
  }) async {
    return _instanceNetwork.readMany(collectionName: collectionName, keys: keys);
  }

  static Future<Map<String, Map<String, dynamic>?>> readAll({required String collectionName}) {
    return _instanceNetwork.readAll(collectionName: collectionName);
  }

  static Future<void> update({
    required String collectionName,
    required String key,
    required Map<String, dynamic> value,
  }) async {
    return _instanceNetwork.update(collectionName: collectionName, key: key, value: value);
  }

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
