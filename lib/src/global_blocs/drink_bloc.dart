import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:water_reminder_app/models/drink.dart';
import 'package:water_reminder_app/services/firestore/firestore_drink_service.dart';
import 'package:water_reminder_app/src/global_blocs/bloc_base.dart';

class DrinkBloc implements BlocBase {
  // Should contain a list of drink objects
  // Stream that out the the UI

  StreamSubscription _drinkStreamSubscription;
  List<Drink> _drinksToday = List();
  int _selectedDrinkAmount = 200;

  final _drinkController = BehaviorSubject<List<Drink>>();
  Function(List<Drink>) get _inDrinks => _drinkController.sink.add;
  Stream<List<Drink>> get outDrinks => _drinkController.stream;

  Stream<int> get outDrinksAmount => outDrinks.map((drinks) {
        int totalValue = 0;
        for (Drink drink in drinks) {
          totalValue += drink.amount;
        }
        return totalValue;
      });

  /// Pull request of put in the comments of how I can transform this with functional code
  /*Stream<int> get outDrinksAmount {
    return outDrinks.map((drinks) => drinks.reduce((a, b) => a.amount + b.amount));
  }*/

  Future<void> init() async {
    final drinkStream = await FirestoreDrinkService.getDrinksStream(DateTime.now());
    _drinkStreamSubscription = drinkStream.listen((querySnapshot) {
      _drinksToday = querySnapshot.documents.map((doc) => Drink.fromDb(doc.data, doc.documentID)).toList();
      _inDrinks(_drinksToday);
    });
  }

  Future<void> drinkWater() async {
    final drink = Drink(DateTime.now(), _selectedDrinkAmount);
    FirestoreDrinkService.drinkWater(drink);
  }

  Future<void> removeDrink(Drink drink) async {
    FirestoreDrinkService.removeDrink(drink);
  }

  @override
  void dispose() {
    _drinkController.close();
    _drinkStreamSubscription.cancel();
  }
}
