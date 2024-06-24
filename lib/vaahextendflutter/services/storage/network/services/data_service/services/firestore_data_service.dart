import 'package:cloud_firestore/cloud_firestore.dart';

import '../data_service.dart';

class FirestoreDataService implements DataService {
  final String collectionName;
  final String documentId;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirestoreDataService({required this.collectionName, required this.documentId});

  @override
  Future<Map<String, dynamic>?> call() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> document =
          await firestore.doc('$collectionName/$documentId').get();
      return document.data();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Stream<Map<String, dynamic>>? stream() {
    try {
      return firestore.doc('$collectionName/$documentId').snapshots().map((documentSnapshot) {
        return documentSnapshot.data() ?? {};
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
