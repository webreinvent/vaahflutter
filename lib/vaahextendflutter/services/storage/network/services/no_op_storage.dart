import 'base_service.dart';

class NoOpNetworkStorage implements NetworkStorageService {
  @override
  Future<void> addCollection(String collectionName, bool isShared) async {}

  @override
  Future<void> create({
    String collectionName = '',
    required String key,
    required String value,
  }) async {}

  @override
  Future<void> createMany({
    String collectionName = '',
    required Map<String, String> values,
  }) async {}

  @override
  Future<String?> read({String collectionName = '', required String key}) async {
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
  Future<void> delete({required String collectionName, required String key}) async {}
}
