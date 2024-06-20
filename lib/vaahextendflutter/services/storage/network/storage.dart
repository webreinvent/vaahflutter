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

  static Future<void> addCollection(String collectionName, bool isShared) async {
    return _instanceNetwork.addCollection(collectionName, isShared);
  }

  static Future<void> create({
    String collectionName = 'vaah-flutter-collection',
    required String key,
    required String value,
  }) async {
    return _instanceNetwork.create(collectionName: collectionName, key: key, value: value);
  }

  static Future<void> createMany({
    String collectionName = 'vaah-flutter-collection',
    required Map<String, String> values,
  }) async {
    return _instanceNetwork.createMany(collectionName: collectionName, values: values);
  }

  static Future<String?> read({
    String collectionName = 'vaah-flutter-collection',
    required String key,
  }) async {
    return _instanceNetwork.read(collectionName: collectionName, key: key);
  }

  static Future<Map<String, String?>> readMany({
    String collectionName = 'vaah-flutter-collection',
    required List<String> keys,
  }) async {
    return _instanceNetwork.readMany(collectionName: collectionName, keys: keys);
  }

  static Future<Map<String, String?>> readAll({
    String collectionName = 'vaah-flutter-collection',
  }) {
    return _instanceNetwork.readAll(collectionName: collectionName);
  }

  static Future<void> update({
    String collectionName = 'vaah-flutter-collection',
    required String key,
    required String value,
  }) async {
    return _instanceNetwork.update(collectionName: collectionName, key: key, value: value);
  }

  static Future<void> updateMany({
    String collectionName = 'vaah-flutter-collection',
    required Map<String, String> values,
  }) async {
    return _instanceNetwork.updateMany(collectionName: collectionName, values: values);
  }

  static Future<void> createOrUpdate({
    String collectionName = 'vaah-flutter-collection',
    required String key,
    required String value,
  }) async {
    return _instanceNetwork.createOrUpdate(collectionName: collectionName, key: key, value: value);
  }

  static Future<void> createOrUpdateMany({
    String collectionName = 'vaah-flutter-collection',
    required Map<String, String> values,
  }) async {
    return _instanceNetwork.createOrUpdateMany(collectionName: collectionName, values: values);
  }

  static Future<void> delete({
    String collectionName = 'vaah-flutter-collection',
    required String key,
  }) async {
    return _instanceNetwork.delete(collectionName: collectionName, key: key);
  }

  static Future<void> deleteMany({
    String collectionName = 'vaah-flutter-collection',
    required List<String> keys,
  }) async {
    return _instanceNetwork.deleteMany(collectionName: collectionName, keys: keys);
  }

  static Future<void> deleteAll({
    String collectionName = 'vaah-flutter-collection',
  }) async {
    return _instanceNetwork.deleteAll(collectionName: collectionName);
  }
}
