import 'base_service.dart';

/// A placeholder storage class when [LocalStorageType.none] is selected in env.dart.
class NoOpStorage implements LocalStorageService {
  @override
  Future<void> add(String name) async {}

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
    String collectionName = '',
    required List<String> keys,
  }) async {
    return {};
  }

  @override
  Future<Map<String, String?>> readAll({String collectionName = ''}) async {
    return {};
  }

  @override
  Future<void> update({
    String collectionName = '',
    required String key,
    required String value,
  }) async {}

  @override
  Future<void> updateMany({
    String collectionName = '',
    required Map<String, String> values,
  }) async {}

  @override
  Future<void> createOrUpdate({
    String collectionName = '',
    required String key,
    required String value,
  }) async {}

  @override
  Future<void> createOrUpdateMany({
    String collectionName = '',
    required Map<String, String> values,
  }) async {}

  @override
  Future<void> delete({String collectionName = '', required String key}) async {}

  @override
  Future<void> deleteMany({String collectionName = '', List<String> keys = const []}) async {}

  @override
  Future<void> deleteAll({String collectionName = ''}) async {}
}
