abstract class NetworkStorageService {
  Future<void> addCollection(String collectionName, bool isShared);

  Future<void> create({required String collectionName, required String key, required String value});

  Future<void> createMany({required String collectionName, required Map<String, String> values});

  Future<String?> read({required String collectionName, required String key});

  Future<Map<String, String?>> readMany({
    required String collectionName,
    List<String> keys = const [],
  });

  Future<Map<String, String?>> readAll({required String collectionName});

  Future<void> update({required String collectionName, required String key, required String value});

  Future<void> updateMany({required String collectionName, required Map<String, String> values});

  Future<void> createOrUpdate({
    required String collectionName,
    required String key,
    required String value,
  });

  Future<void> createOrUpdateMany({
    required String collectionName,
    required Map<String, String> values,
  });

  Future<void> delete({required String collectionName, required String key});

  Future<void> deleteMany({required String collectionName, required List<String> keys});

  Future<void> deleteAll({required String collectionName});
}
