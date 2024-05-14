import '../../env.dart';
import 'local/flutter_secure_storage/flutter_secure_storage_impl.dart';
import 'local/hive/hive_storage_impl.dart';

abstract class Storage {
  static final EnvironmentConfig _envConfig = EnvironmentConfig.getEnvConfig();

  ///Creates a new Local Storage [HiveStorageImpl] or [FlutterSecureStorageImpl]
  ///
  ///The argument [name] is used to open Hive box with that name.
  ///
  ///If you don't provide [name], 'default' will be used.
  factory Storage.createLocal({String? name}) {
    switch (_envConfig.localStorageType) {
      case LocalStorageType.hive:
        final hive = HiveStorageImpl(name: name ?? 'default');
        hive.init();
        return hive;
      case LocalStorageType.flutterSecureStorage:
        return FlutterSecureStorageImpl();
      default:
        return NullStorage();
    }
  }

  ///This methos is used to initialize the Storage.
  ///Its not required in case of [FlutterSecureStorageImpl].
  ///In case of [HiveStorageImpl] it creates a [Directory] using pat_provide package,
  ///initializes hive at that directory, and opens a box with name [name] provided
  ///during [Storage] creation.
  ///```dart
  /// Storage.createLocal('name')
  /// ```
  Future<void> init();

  ///Creates new item or items in the database.
  ///
  ///It can take String or List<String> as [key], and the [value] can be of type,
  ///String, List of String this String could be a Json String or a simple text accourding to your requirement.
  ///
  ///In case of Hive you can only provide the value as Map<String, String> where Map's key will be used as
  ///[key] and Map's value will be used as [value].
  Future<void> create({dynamic key, dynamic value});

  ///Reads the value of the item with [key] from the database and returns the value according to type of [key]
  ///provided.
  ///
  ///It can take the [key] parameter as String and will return [value] as String.
  ///If the [key] is List of String it will return [value] as List of String.
  ///
  ///When the key is not provided it will return all the values from that [Storage] as Map<[key], [value]>
  Future<dynamic> read({dynamic key});

  ///Updates an item with the [key], and [value].
  ///for data types refer [create].
  Future<dynamic> update({dynamic key, dynamic value});

  ///Deletes an item matching with the [key].
  ///for data types refer [read].
  void delete({dynamic key});
}

///A placeholder storage class when StorageType.none is selected.
class NullStorage implements Storage {
  @override
  void delete({dynamic key}) {}

  @override
  Future<void> init() async {}

  @override
  Future<String?> read({dynamic key}) {
    throw UnimplementedError();
  }

  @override
  Future<String?> update({dynamic key, dynamic value}) {
    throw UnimplementedError();
  }

  @override
  Future<void> create({dynamic key, dynamic value}) {
    throw UnimplementedError();
  }
}
