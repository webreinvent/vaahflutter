import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/notification.dart';
import 'base_service.dart';

class InternalNotificationsWithFirebase implements InternalNotificationsService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final StreamController<int> _pendingNotificationsCountStreamController =
      StreamController<int>.broadcast();

  @override
  late final Stream<int> pendingNotificationsCountStream;

  final StreamController<List<InternalNotification>> _notificationsStreamController =
      StreamController<List<InternalNotification>>.broadcast();

  @override
  late final Stream<List<InternalNotification>> notificationsStream;

  List<InternalNotification> _notifications = [];

  @override
  List<InternalNotification> get notifications => _notifications;

  // collection ids
  final String _notificationsCollection = 'notifications';
  final String _notificationsDataCollection = 'notification_data';

  late final String userId;

  StreamSubscription? _firebaseNotificationStream;

  @override
  Future<void> init() async {
    pendingNotificationsCountStream = _pendingNotificationsCountStreamController.stream;
    notificationsStream = _notificationsStreamController.stream;

    // Write your logic here to get user id
    userId = 'test';

    final bool hasSubscribed =
        (await _firebaseFirestore.collection(_notificationsCollection).doc(userId).get())
            .data()?['has_subscribed'];

    if (hasSubscribed) {
      _firebaseNotificationStream = _firebaseFirestore
          .collection(_notificationsCollection)
          .doc(userId)
          .collection(_notificationsDataCollection)
          .snapshots()
          .listen(_notificationsUpdated);
    }
  }

  @override
  Future<void> dispose() async {
    _firebaseNotificationStream?.cancel();
    _pendingNotificationsCountStreamController.close();
    _notificationsStreamController.close();
  }

  @override
  Future<void> subscribe() async {
    await _firebaseFirestore
        .collection(_notificationsCollection)
        .doc(userId)
        .set({'has_subscribed': true});

    _firebaseNotificationStream?.cancel(); // To be safe we cancel old subscription if there is any
    _firebaseNotificationStream = _firebaseFirestore
        .collection(_notificationsCollection)
        .doc(userId)
        .collection(_notificationsDataCollection)
        .snapshots()
        .listen(_notificationsUpdated);
  }

  @override
  Future<void> unsubscribe() async {
    await _firebaseFirestore
        .collection(_notificationsCollection)
        .doc(userId)
        .set({'has_subscribed': false});
    _firebaseNotificationStream?.cancel();
  }

  @override
  Future<void> push(List<String> userIds, InternalNotification notification) async {
    for (final id in userIds) {
      await _firebaseFirestore
          .collection(_notificationsCollection)
          .doc(id)
          .collection(_notificationsDataCollection)
          .add(notification.toJson());
    }
  }

  void _notificationsUpdated(QuerySnapshot<Map<String, dynamic>> event) {
    int count = 0;
    final List<InternalNotification> updatedNotifications = [];
    for (final doc in event.docs) {
      final InternalNotification notification = InternalNotification.fromJson(doc.data());
      if (!notification.opened) count++;
      updatedNotifications.add(notification);
    }
    _pendingNotificationsCountStreamController.add(count);
    _notificationsStreamController.add(updatedNotifications);
    _notifications = updatedNotifications;
  }
}
