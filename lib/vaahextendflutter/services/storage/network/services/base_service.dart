abstract class NetworkStorageService {
  Future<void> addCollection(String collectionName, bool isShared);

  Future<void> create({required String collectionName, required String key, required String value});

  Future<void> createMany({required String collectionName, required Map<String, String> values});

  Future<String?> read({required String collectionName, required String key});

  Future<Map<String, String?>> readMany({
    required String collectionName,
    List<String> keys = const [],
  });
  Future<void> delete({required String collectionName, required String key});
}
