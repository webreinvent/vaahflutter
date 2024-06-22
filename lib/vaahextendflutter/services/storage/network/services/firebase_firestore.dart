import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'base_service.dart';

class NetworkStorageWithFirestore implements NetworkStorageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentUser;

  @override
  Future<void> create({
    required String collectionName,
    required String key,
    required Map<String, dynamic> value,
  }) async {
    try {
      await _firestore.doc('$collectionName/$key').set(value);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> createMany({
    required String collectionName,
    required Map<String, Map<String, dynamic>> values,
  }) async {
    WriteBatch batch = _firestore.batch();

    values.forEach((key, value) async {
      DocumentReference ref = _firestore.doc('$collectionName/$key');
      batch.set(ref, value);
    });

    try {
      await batch.commit();
    } catch (e) {
      throw ('Batch write failed: $e');
    }
  }

  @override
  Future<Map<String, dynamic>?> read({
    required String collectionName,
    required String key,
  }) async {
    try {
      Map<String, dynamic>? value = {};
      await _firestore.doc('$collectionName/$key').get().then((v) => value = v.data());
      return value;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<Map<String, Map<String, dynamic>?>> readMany({
    required String collectionName,
    List<String> keys = const [],
  }) async {
    Map<String, Map<String, dynamic>?> values = {};
    for (int i = 0; i < keys.length; i++) {
      values[keys[i]] = await read(collectionName: collectionName, key: keys[i]);
    }
    return values;
  }

  @override
  Future<Map<String, Map<String, dynamic>?>> readAll({required String collectionName}) async {
    try {
      final Map<String, Map<String, dynamic>?> result;
      final querySnapshot = await _firestore.collection(collectionName).get();
      result = Map.fromEntries(
        querySnapshot.docs.map(
          (e) => MapEntry(e.id, e.data()),
        ),
      );
      return result;
    } catch (e) {
      throw Exception(e.toString());
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
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> updateMany({
    required String collectionName,
    required Map<String, Map<String, dynamic>> values,
  }) async {
    WriteBatch batch = _firestore.batch();

    values.forEach((key, value) async {
      DocumentReference ref = _firestore.doc('$collectionName/$key');
      batch.update(ref, value);
    });

    try {
      await batch.commit();
    } catch (e) {
      throw ('Batch write failed: $e');
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
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> createOrUpdateMany({
    required String collectionName,
    required Map<String, Map<String, dynamic>> values,
  }) async {
    WriteBatch batch = _firestore.batch();
    try {
      values.forEach((key, value) async {
        DocumentReference ref = _firestore.doc('$collectionName/$key');
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
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> deleteMany({required String collectionName, required List<String> keys}) async {
    WriteBatch batch = _firestore.batch();
    try {
      for (int i = 0; i < keys.length; i++) {
        DocumentReference ref = _firestore.doc('$collectionName/${keys[i]}');
        batch.delete(ref);
      }

      await batch.commit();
    } catch (e) {
      throw ('Batch write failed: $e');
    }
  }

  @override
  Future<void> deleteAll({required collectionName}) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection(collectionName).get();
      for (DocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
