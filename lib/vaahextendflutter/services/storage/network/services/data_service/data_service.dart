abstract class DataService {
  Future<Map<String, dynamic>?> call();
  Stream<Map<String, dynamic>>? stream();
}
