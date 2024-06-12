abstract class LocalStorageService {
  Future<void> init();

  Future<void> create({required String key, required String value});

  Future<void> createMany({required Map<String, String> values});

  Future<String?> read({required String key});

  Future<Map<String, String?>> readMany({required List<String> keys});

  Future<Map<String, String?>> readAll();

  Future<void> update({required String key, required String value});

  Future<void> updateMany({required Map<String, String> values});

  Future<void> createOrUpdate({required String key, required String value});

  Future<void> createOrUpdateMany({required Map<String, String> values});

  Future<void> delete({required String key});

  Future<void> deleteMany({List<String> keys = const []});

  Future<void> deleteAll();
}
