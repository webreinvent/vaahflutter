import '../../../env/env.dart';
import '../../../env/storage.dart';
import 'services/base_storage.dart';
import 'services/hive_storage.dart';
import 'services/no_op_storage.dart';

abstract class LocalDatabaseStorage {
  static LocalStorageService? _instanceLocal;

  static Future<LocalStorageService?> init() async {
    final EnvironmentConfig envConfig = EnvironmentConfig.getConfig;
    switch (envConfig.localDatabaseStorageType) {
      case LocalDatabaseStorageType.hive:
        _instanceLocal = await LocalHiveStorage.init();
      default:
        _instanceLocal = await LocalNoOpStorage.init();
    }
    return _instanceLocal;
  }

  static const defaultCollectionName = 'vaah-flutter-box';

  Future<void> addCollection({
    required String collectionName,
  }) async {
    await _instanceLocal?.addCollection(collectionName: collectionName);
    return;
  }

  static Future<void> create({
    String collectionName = defaultCollectionName,
    required String key,
    required String value,
  }) async {
    await _instanceLocal?.create(collectionName: collectionName, key: key, value: value);
    return;
  }

  static Future<void> createMany({
    String collectionName = defaultCollectionName,
    required Map<String, String> values,
  }) async {
    await _instanceLocal?.createMany(collectionName: collectionName, values: values);
    return;
  }

  static Future<void> read({
    String collectionName = defaultCollectionName,
    required String key,
  }) async {
    await _instanceLocal?.read(collectionName: collectionName, key: key);
    return;
  }

  static Future<Map<String, String>> readMany({
    String collectionName = defaultCollectionName,
    required List<String> keys,
  }) async {
    return await _instanceLocal?.readMany(collectionName: collectionName, keys: keys) ?? {};
  }

  static Future<Map<String, String>> readAll({
    String collectionName = defaultCollectionName,
  }) async {
    return await _instanceLocal?.readAll(collectionName: collectionName) ?? {};
  }

  static Future<void> update({
    String collectionName = defaultCollectionName,
    required String key,
    required String value,
  }) async {
    await _instanceLocal?.update(collectionName: collectionName, key: key, value: value);
    return;
  }

  static Future<void> updateMany({
    String collectionName = defaultCollectionName,
    required Map<String, String> values,
  }) async {
    await _instanceLocal?.updateMany(collectionName: collectionName, values: values);
    return;
  }

  static Future<void> createOrUpdate({
    String collectionName = defaultCollectionName,
    required String key,
    required String value,
  }) async {
    await _instanceLocal?.createOrUpdate(collectionName: collectionName, key: key, value: value);
    return;
  }

  static Future<void> createOrUpdateMany({
    String collectionName = defaultCollectionName,
    required Map<String, String> values,
  }) async {
    await _instanceLocal?.createOrUpdateMany(collectionName: collectionName, values: values);
    return;
  }

  static Future<void> delete({
    String collectionName = defaultCollectionName,
    required String key,
  }) async {
    await _instanceLocal?.delete(collectionName: collectionName, key: key);
    return;
  }

  static Future<void> deleteMany({
    String collectionName = defaultCollectionName,
    List<String> keys = const [],
  }) async {
    await _instanceLocal?.deleteMany(collectionName: collectionName, keys: keys);
    return;
  }

  static Future<void> deleteAll({
    String collectionName = defaultCollectionName,
  }) async {
    await _instanceLocal?.deleteAll(collectionName: collectionName);
    return;
  }
}
