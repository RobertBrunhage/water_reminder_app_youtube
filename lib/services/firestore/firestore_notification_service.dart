import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:water_reminder_app/services/firestore/firestore_constants.dart';
import 'package:water_reminder_app/src/view_models/notification_data.dart';

class FirestoreNotificationService {
  static Future<Stream<QuerySnapshot>> getAllNotifications() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser();

    final notificationCollectionStream = Firestore.instance
        .collection(FirestoreConstants.userCollection)
        .document(firebaseUser.uid)
        .collection(FirestoreConstants.notificationCollection)
        .snapshots();
    return notificationCollectionStream;
  }

  static Future<void> addNotification(NotificationData notification) async {
    final firebaseUser = await FirebaseAuth.instance.currentUser();

    Firestore.instance
        .collection(FirestoreConstants.userCollection)
        .document(firebaseUser.uid)
        .collection(FirestoreConstants.notificationCollection)
        .add(notification.toJson());
  }

  static Future<void> removeNotification(NotificationData notification) async {
    final firebaseUser = await FirebaseAuth.instance.currentUser();

    Firestore.instance
        .collection(FirestoreConstants.userCollection)
        .document(firebaseUser.uid)
        .collection(FirestoreConstants.notificationCollection)
        .document(notification.id)
        .delete();
  }
}
