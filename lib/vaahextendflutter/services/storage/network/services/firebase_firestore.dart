import 'package:cloud_firestore/cloud_firestore.dart';

import 'base_service.dart';

class NetworkStorageWithFirestore implements NetworkStorageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> create({
    required String collectionName,
    required String key,
    required Map<String, dynamic> value,
  }) async {
    return _firestore.runTransaction((transaction) async {
      final DocumentReference documentReference = _firestore.doc('$collectionName/$key');
      final DocumentSnapshot documentSnapshot = await transaction.get(documentReference);
      if (!documentSnapshot.exists) {
        transaction.set(documentReference, value);
      } else {
        throw ('Document with ID "$key" already exists.');
      }
    }).catchError((e) {
      throw (e.toString());
    });
  }

  @override
  Future<void> createMany({
    required String collectionName,
    required Map<String, Map<String, dynamic>> values,
  }) async {
    return _firestore.runTransaction((transaction) async {
      bool allDocumentsNew = true;

      for (String docId in values.keys) {
        final DocumentReference documentReference =
            _firestore.collection(collectionName).doc(docId);
        final DocumentSnapshot documentSnapshot = await transaction.get(documentReference);

        if (documentSnapshot.exists) {
          allDocumentsNew = false;
          throw ('Document with ID "$docId" already exists.');
        }
      }

      if (allDocumentsNew) {
        for (String docId in values.keys) {
          DocumentReference documentReference = _firestore.collection(collectionName).doc(docId);
          transaction.set(documentReference, values[docId]!);
        }
      } else {
        throw ('One or more documents already exist. Aborting transaction.');
      }
    }).catchError((e) {
      throw (e.toString());
    });
  }

  @override
  Future<Map<String, dynamic>?> read({
    required String collectionName,
    required String key,
  }) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _firestore.doc('$collectionName/$key').get();
      return documentSnapshot.data();
    } catch (e) {
      throw (e.toString());
    }
  }

  @override
  Future<Map<String, Map<String, dynamic>?>> readMany({
    required String collectionName,
    required List<String> keys,
  }) async {
    final Map<String, Map<String, dynamic>?> values = {};
    for (int i = 0; i < keys.length; i++) {
      values[keys[i]] = await read(collectionName: collectionName, key: keys[i]);
    }
    return values;
  }

  @override
  Future<Map<String, Map<String, dynamic>?>> readAll({required String collectionName}) async {
    try {
      final querySnapshot = await _firestore.collection(collectionName).get();
      final Map<String, Map<String, dynamic>?> result = Map.fromEntries(
        querySnapshot.docs.map(
          (entry) => MapEntry(entry.id, entry.data()),
        ),
      );
      return result;
    } catch (e) {
      throw (e.toString());
    }
  }

  @override
  Future<void> update({
    required String collectionName,
    required String key,
    required Map<String, dynamic> value,
  }) async {
    try {
      await _firestore.doc('$collectionName/$key').update(value);
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        throw FirebaseException(
          plugin: e.plugin,
          stackTrace: e.stackTrace,
          code: e.code,
          message: 'Update Failed: Document with ID "$key" does not exists. ${e.message}',
        );
      }
      throw ('Update Failed: ${e.toString()}');
    } catch (e) {
      throw ('Something went wrong: ${e.toString()}');
    }
  }

  @override
  Future<void> updateMany({
    required String collectionName,
    required Map<String, Map<String, dynamic>> values,
  }) async {
    try {
      final WriteBatch batch = _firestore.batch();
      values.forEach((key, value) async {
        final DocumentReference<Map<String, dynamic>> ref = _firestore.doc('$collectionName/$key');
        batch.update(ref, value);
      });
      await batch.commit();
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        throw FirebaseException(
          plugin: e.plugin,
          stackTrace: e.stackTrace,
          code: e.code,
          message: 'Update Failed: ${e.message}',
        );
      }
      throw ('Update Failed: ${e.toString()}');
    } catch (e) {
      throw ('Something went wrong: ${e.toString()}');
    }
  }

  @override
  Future<void> createOrUpdate({
    required String collectionName,
    required String key,
    required Map<String, dynamic> value,
  }) async {
    try {
      await _firestore.doc('$collectionName/$key').set(value, SetOptions(merge: true));
    } catch (e) {
      throw (e.toString());
    }
  }

  @override
  Future<void> createOrUpdateMany({
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
    } catch (e) {
      throw ('Batch write failed: $e');
    }
  }

  @override
  Future<void> delete({required String collectionName, required String key}) async {
    try {
      await _firestore.doc('$collectionName/$key').delete();
    } catch (e) {
      throw (e.toString());
    }
  }

  @override
  Future<void> deleteMany({required String collectionName, required List<String> keys}) async {
    try {
      final WriteBatch batch = _firestore.batch();
      for (int i = 0; i < keys.length; i++) {
        final DocumentReference<Map<String, dynamic>> ref =
            _firestore.doc('$collectionName/${keys[i]}');
        batch.delete(ref);
      }

      await batch.commit();
    } catch (e) {
      throw ('Delete failed: $e');
    }
  }

  @override
  Future<void> deleteAll({required collectionName}) async {
    try {
      final WriteBatch batch = _firestore.batch();
      final QuerySnapshot querySnapshot = await _firestore.collection(collectionName).get();
      for (DocumentSnapshot doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      batch.commit();
    } catch (e) {
      throw (e.toString());
    }
  }
}
