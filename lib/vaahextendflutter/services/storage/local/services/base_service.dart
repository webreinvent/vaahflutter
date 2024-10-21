import '../../storage_response.dart';

abstract class LocalStorageService {
  StorageResponse add(String collectionName);

  Future<StorageResponse> create({
    required String collectionName,
    required String key,
    required String value,
  });

  Future<StorageResponse> createMany({
    required String collectionName,
    required Map<String, String> values,
  });

  Future<StorageResponse> read({required String collectionName, required String key});

  Future<StorageResponse> readMany({
    required String collectionName,
    required List<String> keys,
  });

  Future<StorageResponse> readAll({required String collectionName});

  Future<StorageResponse> update({
    required String collectionName,
    required String key,
    required String value,
  });

  Future<StorageResponse> updateMany({
    required String collectionName,
    required Map<String, String> values,
  });

  Future<StorageResponse> createOrUpdate({
    required String collectionName,
    required String key,
    required String value,
  });

  Future<StorageResponse> createOrUpdateMany({
    required String collectionName,
    required Map<String, String> values,
  });

  Future<StorageResponse> delete({required String collectionName, required String key});

  Future<StorageResponse> deleteMany({
    required String collectionName,
    List<String> keys = const [],
  });

  Future<StorageResponse> deleteAll({required String collectionName});
}
