import 'base_storage.dart';

/// A placeholder storage class when [LocalStorageType.none] is selected in env.dart.
class LocalNoOpStorage implements LocalStorageService {
  static Future<LocalNoOpStorage> init() async {
    return LocalNoOpStorage();
  }

  @override
  Future<void> addCollection({
    required String collectionName,
  }) async {
    return;
  }

  @override
  Future<void> create({
    String collectionName = '',
    required String key,
    required dynamic value,
  }) async {
    return;
  }

  @override
  Future<void> createMany({
    String collectionName = '',
    required Map<String, dynamic> values,
  }) async {
    return;
  }

  @override
  Future<String?> read({
    String collectionName = '',
    required String key,
  }) async {
    return null;
  }

  @override
  Future<Map<String, String>> readMany({
    String collectionName = '',
    required List<String> keys,
  }) async {
    return {};
  }

  @override
  Future<Map<String, String>> readAll({
    String collectionName = '',
    int start = 1,
    int itemsPerPage = 10,
  }) async {
    return {};
  }

  @override
  Future<void> update({
    String collectionName = '',
    required String key,
    required dynamic value,
  }) async {
    return;
  }

  @override
  Future<void> updateMany({
    String collectionName = '',
    required Map<String, dynamic> values,
  }) async {
    return;
  }

  @override
  Future<void> createOrUpdate({
    String collectionName = '',
    required String key,
    required dynamic value,
  }) async {
    return;
  }

  @override
  Future<void> createOrUpdateMany({
    String collectionName = '',
    required Map<String, dynamic> values,
  }) async {
    return;
  }

  @override
  Future<void> delete({
    String collectionName = '',
    required String key,
  }) async {
    return;
  }

  @override
  Future<void> deleteMany({
    String collectionName = '',
    List<String> keys = const [],
  }) async {
    return;
  }

  @override
  Future<void> deleteAll({String collectionName = ''}) async {
    return;
  }
}
