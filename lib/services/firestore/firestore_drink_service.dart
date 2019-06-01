import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:water_reminder_app/models/drink.dart';
import 'package:water_reminder_app/services/firestore/firestore_constants.dart';

class FirestoreDrinkService {
  /// Gets all the drinks of the day the date is provided
  static Future<Stream<QuerySnapshot>> getDrinksStream(DateTime date) async {
    final firebaseUser = await FirebaseAuth.instance.currentUser();

    final morningDate = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final nightDate = DateTime(date.year, date.month, date.day + 1, 0, 0, 0);

    final drinksCollectionStream = Firestore.instance
        .collection(FirestoreConstants.userCollection)
        .document(firebaseUser.uid)
        .collection(FirestoreConstants.drinkCollection)
        .where('date', isGreaterThan: morningDate)
        .where('date', isLessThan: nightDate)
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

  static Future<void> removeDrink(Drink drink) async {
    final firebaseUser = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection(FirestoreConstants.userCollection)
        .document(firebaseUser.uid)
        .collection(FirestoreConstants.drinkCollection)
        .document(drink.id)
        .delete();
  }
}
