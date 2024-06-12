import 'base_service.dart';

/// A placeholder storage class when [LocalStorageType.none] is selected in env.dart.
class NoOpStorage implements LocalStorageService {
  @override
  Future<void> init() async {}

  @override
  Future<void> create({required String key, required String value}) async {}

  @override
  Future<void> createMany({required Map<String, String> values}) async {}

  @override
  Future<String?> read({required String key}) async {
    return null;
  }

  @override
  Future<Map<String, String?>> readMany({required List<String> keys}) async {
    return {};
  }

  @override
  Future<Map<String, String?>> readAll() async {
    return {};
  }

  @override
  Future<void> update({required String key, required String value}) async {}

  @override
  Future<void> updateMany({required Map<String, String> values}) async {}

  @override
  Future<void> createOrUpdate({required String key, required String value}) async {}

  @override
  Future<void> createOrUpdateMany({required Map<String, String> values}) async {}

  @override
  Future<void> delete({required String key}) async {}

  @override
  Future<void> deleteMany({List<String> keys = const []}) async {}

  @override
  Future<void> deleteAll() async {}
}
