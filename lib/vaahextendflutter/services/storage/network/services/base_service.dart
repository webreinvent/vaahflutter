import '../../storage_response.dart';

abstract class NetworkStorageService {
  Future<StorageResponse> create({
    required String collectionName,
    required String key,
    required Map<String, dynamic> value,
  });

  Future<StorageResponse> createMany({
    required String collectionName,
    required Map<String, Map<String, dynamic>> values,
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
    required Map<String, dynamic> value,
  });

  Future<StorageResponse> updateMany({
    required String collectionName,
    required Map<String, Map<String, dynamic>> values,
  });

  Future<StorageResponse> createOrUpdate({
    required String collectionName,
    required String key,
    required Map<String, dynamic> value,
  });

  Future<StorageResponse> createOrUpdateMany({
    required String collectionName,
    required Map<String, Map<String, dynamic>> values,
  });

  Future<StorageResponse> delete({required String collectionName, required String key});

  Future<StorageResponse> deleteMany({required String collectionName, required List<String> keys});

  Future<StorageResponse> deleteAll({required String collectionName});
}
