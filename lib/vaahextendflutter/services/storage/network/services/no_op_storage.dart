import 'base_service.dart';

class NoOpNetworkStorage implements NetworkStorageService {
  @override
  Future<void> addCollection(String collectionName, bool isShared) async {}

  @override
  Future<void> create({
    required String collectionName,
    required String key,
    required String value,
  }) async {}

  @override
  Future<void> createMany({
    required String collectionName,
    required Map<String, String> values,
  }) async {}

  @override
  Future<String?> read({required String collectionName, required String key}) async {
    return null;
  }

  @override
  Future<Map<String, String?>> readMany({
    required String collectionName,
    List<String> keys = const [],
  }) async {
    return {};
  }

  @override
  Future<Map<String, String?>> readAll({
    required String collectionName,
  }) async {
    return {};
  }

  @override
  Future<void> update({
    required String collectionName,
    required String key,
    required String value,
  }) async {}

  @override
  Future<void> updateMany({
    required String collectionName,
    required Map<String, String> values,
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
