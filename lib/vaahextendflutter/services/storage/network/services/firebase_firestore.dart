import 'package:cloud_firestore/cloud_firestore.dart';

import '../../storage_error.dart';
import '../../storage_response.dart';
import 'base_service.dart';

class NetworkStorageWithFirestore implements NetworkStorageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<StorageResponse> create({
    required String collectionName,
    required String key,
    required Map<String, dynamic> value,
  }) async {
    return _firestore.runTransaction((transaction) async {
      final DocumentReference documentReference = _firestore.doc('$collectionName/$key');
      final DocumentSnapshot documentSnapshot = await transaction.get(documentReference);
      if (!documentSnapshot.exists) {
        transaction.set(documentReference, value);
        return StorageResponse(
          data: key,
          message: 'Entry created with key: $key in collection $collectionName.',
          isSuccess: true,
        );
      } else {
        StorageError error = StorageError(
          message: 'The key "$key" already exists.',
          failedKey: key,
          stackTrace: StackTrace.current,
        );
        return StorageResponse(
          errors: [error],
        );
      }
    }).catchError((e) {
      StorageError error = StorageError(
        message: 'Error while creating entry to the "$collectionName" at key: $key: $e',
        failedKey: key,
        stackTrace: StackTrace.current,
      );
      return StorageResponse(errors: [error]);
    });
  }

  @override
  Future<StorageResponse> createMany({
    required String collectionName,
    required Map<String, Map<String, dynamic>> values,
  }) async {
    int totalEntries = values.length;
    List<StorageError> errors = [];
    List<String> success = [];

    return _firestore.runTransaction((transaction) async {
      for (String docId in values.keys) {
        final DocumentReference documentReference =
            _firestore.collection(collectionName).doc(docId);
        final DocumentSnapshot documentSnapshot = await transaction.get(documentReference);
        if (documentSnapshot.exists) {
          errors.add(
            StorageError(
              message: 'The key "$docId" already exists.',
              failedKey: docId,
              stackTrace: StackTrace.current,
            ),
          );
        } else {
          totalEntries--;
          success.add(docId);
        }
      }
      if (errors.isEmpty) {
        for (String docId in success) {
          DocumentReference documentReference = _firestore.collection(collectionName).doc(docId);
          transaction.set(documentReference, values[docId]!);
        }
        return StorageResponse(
          data: success,
          message: 'All entries created successfully.',
          isSuccess: true,
        );
      } else if (totalEntries == values.length) {
        return StorageResponse(errors: errors);
      } else {
        for (String docId in success) {
          DocumentReference documentReference = _firestore.collection(collectionName).doc(docId);
          transaction.set(documentReference, values[docId]!);
        }
        return StorageResponse(
          data: success,
          message: '${values.length - totalEntries}/${values.length} entries created.',
          errors: errors,
          isPartialSuccess: true,
        );
      }
    }).catchError((e) {
      StorageError error = StorageError(
        message: 'Error while creating entries: $e',
        failedKey: '',
        stackTrace: StackTrace.current,
      );
      return StorageResponse(errors: [error]);
    });
  }

  @override
  Future<StorageResponse> read({required String collectionName, required String key}) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _firestore.doc('$collectionName/$key').get();
      final data = documentSnapshot.data();
      if (data != null) {
        return StorageResponse(
          data: data,
          message: 'Read successful: Entry with key: $key in collection: $collectionName.',
          isSuccess: true,
        );
      } else {
        StorageError error = StorageError(
          message: 'The key "$key" does not exist.',
          failedKey: key,
          stackTrace: StackTrace.current,
        );
        return StorageResponse(errors: [error]);
      }
    } catch (e) {
      StorageError error = StorageError(
        message: 'Error while reading data: $e',
        failedKey: key,
        stackTrace: StackTrace.current,
      );
      return StorageResponse(errors: [error]);
    }
  }

  @override
  Future<StorageResponse> readMany({
    required String collectionName,
    required List<String> keys,
  }) async {
    if (keys.isNotEmpty) {
      int remainingKeys = keys.length;
      List<StorageError> errors = [];
      Map<String, Map<String, dynamic>?> data = {};
      for (String k in keys) {
        final result = await read(collectionName: collectionName, key: k);
        if (result.isSuccess) {
          data[k] = result.data;
          remainingKeys--;
        } else if (result.hasError) {
          errors.add(result.errors!.first);
        }
      }
      if (errors.isEmpty) {
        return StorageResponse(data: data, message: 'Read successful.', isSuccess: true);
      } else if (remainingKeys == keys.length) {
        return StorageResponse(errors: errors);
      } else {
        return StorageResponse(
          data: data,
          message: 'Read ${keys.length - remainingKeys}/${keys.length}.',
          errors: errors,
          isPartialSuccess: true,
        );
      }
    } else {
      return StorageResponse(
        errors: [
          StorageError(
            message: 'No keys provided',
            failedKey: '',
            stackTrace: StackTrace.current,
          ),
        ],
      );
    }
  }

  @override
  Future<StorageResponse> readAll({required String collectionName}) async {
    try {
      final querySnapshot = await _firestore.collection(collectionName).get();
      final Map<String, Map<String, dynamic>?> result = Map.fromEntries(
        querySnapshot.docs.map(
          (entry) => MapEntry(entry.id, entry.data()),
        ),
      );
      return StorageResponse(
        data: result,
        message: result.isEmpty ? 'No data found' : 'Read all successfull.',
        isSuccess: true,
      );
    } catch (e) {
      StorageError error = StorageError(
        message: 'Error reading all data: $e',
        failedKey: '',
        stackTrace: StackTrace.current,
      );
      return StorageResponse(errors: [error]);
    }
  }

  @override
  Future<StorageResponse> update({
    required String collectionName,
    required String key,
    required Map<String, dynamic> value,
  }) async {
    try {
      await _firestore.doc('$collectionName/$key').update(value);
      return StorageResponse(data: key, message: 'Entry updated at key: $key', isSuccess: true);
    } catch (e) {
      if (e is FirebaseException && e.code == 'not-found') {
        StorageError error = StorageError(
          message:
              'Update Failed: The key "$key" does not exists in "$collectionName": ${e.message}',
          failedKey: key,
          stackTrace: StackTrace.current,
        );
        return StorageResponse(
          errors: [error],
        );
      }
      StorageError error = StorageError(
        message: 'Update Failed: $e',
        failedKey: key,
        stackTrace: StackTrace.current,
      );
      return StorageResponse(
        errors: [error],
      );
    }
  }

  @override
  Future<StorageResponse> updateMany({
    required String collectionName,
    required Map<String, Map<String, dynamic>> values,
  }) async {
    int remainigEntries = values.length;
    List<StorageError> errors = [];
    List<String> success = [];
    for (String k in values.keys) {
      final result = await update(collectionName: collectionName, key: k, value: values[k]!);
      if (result.isSuccess) {
        remainigEntries--;
        success.add(result.data);
      } else if (result.hasError) {
        errors.add(result.errors!.first);
      }
    }
    if (errors.isEmpty) {
      return StorageResponse(data: success, message: 'Updated all given entries.', isSuccess: true);
    } else if (remainigEntries == values.length) {
      return StorageResponse(errors: errors);
    } else {
      return StorageResponse(
        data: success,
        message: 'Updated ${values.length - remainigEntries}/${values.length} entries.',
        errors: errors,
        isPartialSuccess: true,
      );
    }
  }

  @override
  Future<StorageResponse> createOrUpdate({
    required String collectionName,
    required String key,
    required Map<String, dynamic> value,
  }) async {
    try {
      await _firestore.doc('$collectionName/$key').set(value, SetOptions(merge: true));
      return StorageResponse(data: key, message: 'Set entry at key; $key', isSuccess: true);
    } catch (e) {
      StorageError error = StorageError(
        message: 'Write failed: $e',
        failedKey: key,
        stackTrace: StackTrace.current,
      );
      return StorageResponse(errors: [error]);
    }
  }

  @override
  Future<StorageResponse> createOrUpdateMany({
    required String collectionName,
    required Map<String, Map<String, dynamic>> values,
  }) async {
    try {
      final WriteBatch batch = _firestore.batch();
      values.forEach((key, value) async {
        final DocumentReference<Map<String, dynamic>> ref = _firestore.doc('$collectionName/$key');
        batch.set(ref, value, SetOptions(merge: true));
      });
      await batch.commit();
      return StorageResponse(
        data: values.keys.toList(),
        message: 'Write multiple entries successful: ${values.keys.toList()}',
        isSuccess: true,
      );
    } catch (e) {
      StorageError error = StorageError(
        message: 'Batch write failed: $e',
        failedKey: '',
        stackTrace: StackTrace.current,
      );
      return StorageResponse(errors: [error]);
    }
  }

  @override
  Future<StorageResponse> delete({required String collectionName, required String key}) async {
    try {
      await _firestore.doc('$collectionName/$key').delete();
      return StorageResponse(data: key, message: 'Entry at key: $key deleted.', isSuccess: true);
    } catch (e) {
      StorageError error = StorageError(
        message: 'Delete failed: $e',
        failedKey: key,
        stackTrace: StackTrace.current,
      );
      return StorageResponse(errors: [error]);
    }
  }

  @override
  Future<StorageResponse> deleteMany({
    required String collectionName,
    required List<String> keys,
  }) async {
    try {
      final WriteBatch batch = _firestore.batch();
      for (int i = 0; i < keys.length; i++) {
        final DocumentReference<Map<String, dynamic>> ref =
            _firestore.doc('$collectionName/${keys[i]}');
        batch.delete(ref);
      }

      await batch.commit();
      return StorageResponse(
        data: keys,
        message: 'Deleted entries at keys: $keys, in collection: $collectionName',
        isSuccess: true,
      );
    } catch (e) {
      StorageError error = StorageError(
        message: 'Delete failed: $e',
        failedKey: '',
        stackTrace: StackTrace.current,
      );
      return StorageResponse(errors: [error]);
    }
  }

  @override
  Future<StorageResponse> deleteAll({required collectionName}) async {
    try {
      final WriteBatch batch = _firestore.batch();
      final QuerySnapshot querySnapshot = await _firestore.collection(collectionName).get();
      for (DocumentSnapshot doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      batch.commit();
      return StorageResponse(
        data: null,
        message: 'Deltet all entries from $collectionName.',
        isSuccess: true,
      );
    } catch (e) {
      StorageError error = StorageError(
        message: 'Delete failed: $e',
        failedKey: '',
        stackTrace: StackTrace.current,
      );
      return StorageResponse(errors: [error]);
    }
  }
}
