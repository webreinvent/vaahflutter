import 'base_service.dart';

class NoOpNetworkStorage implements NetworkStorageService {
  @override
  Future<void> addCollection(String collectionName, bool isShared) async {}

  @override
  Future<void> create({
    required String collectionName,
    required String key,
    required Map<String, dynamic> value,
  }) async {}

  @override
  Future<void> createMany({
    required String collectionName,
    required Map<String, Map<String, dynamic>> values,
  }) async {}

  @override
  Future<Map<String, dynamic>?> read({required String collectionName, required String key}) async {
    return null;
  }

  @override
  Future<Map<String, Map<String, dynamic>?>> readMany({
    required String collectionName,
    required List<String> keys,
  }) async {
    return {};
  }

  @override
  Future<Map<String, Map<String, dynamic>?>> readAll({
    required String collectionName,
  }) async {
    return {};
  }

  @override
  Future<void> update({
    required String collectionName,
    required String key,
    required Map<String, dynamic> value,
  }) async {}

  @override
  Future<void> updateMany({
    required String collectionName,
    required Map<String, Map<String, dynamic>> values,
  }) async {}

  @override
  Future<void> createOrUpdate({
    required String collectionName,
    required String key,
    required String value,
  }) async {}

  @override
  Future<void> createOrUpdateMany({
    required String collectionName,
    required Map<String, String> values,
  }) async {}
  @override
  Future<void> delete({required String collectionName, required String key}) async {}

  @override
  Future<void> deleteMany({required String collectionName, required List<String> keys}) async {}

  @override
  Future<void> deleteAll({required String collectionName}) async {}
}
