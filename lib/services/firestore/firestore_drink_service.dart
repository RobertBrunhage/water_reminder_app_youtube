import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:water_reminder_app/models/drink.dart';
import 'package:water_reminder_app/services/firestore/firestore_constants.dart';

class FirestoreDrinkService {
  static Future<Stream<QuerySnapshot>> getDrinksStream(DateTime date) async {
    final firebaseUser = await FirebaseAuth.instance.currentUser();
    final drinksCollectionStream = Firestore.instance
        .collection(FirestoreConstants.userCollection)
        .document(firebaseUser.uid)
        .collection(FirestoreConstants.drinkCollection)
        .snapshots();
    return drinksCollectionStream;
  }

  static Future<void> drinkWater(Drink drink) async {
    final firebaseUser = await FirebaseAuth.instance.currentUser();
    final drinksCollection = Firestore.instance
        .collection(FirestoreConstants.userCollection)
        .document(firebaseUser.uid)
        .collection(FirestoreConstants.drinkCollection);

    drinksCollection.add(drink.toJson());
  }
}
