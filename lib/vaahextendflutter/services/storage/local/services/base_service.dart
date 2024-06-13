abstract class LocalStorageService {
  Future<void> add(String collectionName);

  Future<void> create({String collectionName, required String key, required String value});

  Future<void> createMany({String collectionName, required Map<String, String> values});

  Future<String?> read({String collectionName, required String key});

  Future<Map<String, String?>> readMany({String collectionName, required List<String> keys});

  Future<Map<String, String?>> readAll({String collectionName});

  Future<void> update({String collectionName, required String key, required String value});

  Future<void> updateMany({String collectionName, required Map<String, String> values});

  Future<void> createOrUpdate({String collectionName, required String key, required String value});

  Future<void> createOrUpdateMany({String collectionName, required Map<String, String> values});

  Future<void> delete({String collectionName, required String key});

  Future<void> deleteMany({String collectionName, List<String> keys = const []});

  Future<void> deleteAll({String collectionName});
}
