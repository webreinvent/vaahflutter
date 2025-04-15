import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../extensions/string_extensions.dart';
import '../models/log.dart';
import 'logging_service.dart';

class FirebaseLoggingService extends LoggingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _currentUserId;

  @override
  Future<Widget> init({required Widget app}) async {
    return app;
  }

  @override
  void logEvent({
    required String message,
    required EventType type,
    Map<String, dynamic>? data,
  }) {
    _firestore.collection('logs').add(
      {
        'userId': _currentUserId,
        'message': message,
        'type': type.name,
        'data': data,
        'timestamp': FieldValue.serverTimestamp(),
      },
    );
  }

  @override
  void logException(
    dynamic throwable, {
    StackTrace? stackTrace,
    Map<String, dynamic>? hint,
  }) {
    _firestore.collection('errors').add(
      {
        'userId': _currentUserId,
        'error': throwable.toString(),
        'stackTrace': stackTrace?.toString(),
        'hint': hint,
        'timestamp': FieldValue.serverTimestamp(),
      },
    );
  }

  @override
  Future<void> logTransaction({
    required Function execute,
    required TransactionDetails details,
  }) async {
    throw UnimplementedError();
  }

  @override
  void setUserInfo({
    String? id,
    String? name,
    String? email,
    Map<String, dynamic>? metaData,
  }) {
    if (id == null) return;

    _currentUserId = id;

    _firestore.collection('user_sessions').doc(id).set(
      {
        'name': name,
        'email': email,
        'metaData': metaData,
        'lastUpdated': FieldValue.serverTimestamp(),
      },
      SetOptions(
        merge: true, // Merge keeps existing fields if re-updating
      ),
    );
  }

  @override
  void unsetUserInfo() async {
    if (_currentUserId.isNullOrEmpty) return;

    _firestore.collection('user_sessions').doc(_currentUserId).delete().catchError(
      (error) {
        logException(error);
      },
    );
  }
}
