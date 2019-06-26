import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:water_reminder_app/models/drink.dart';
import 'package:water_reminder_app/services/firestore/firestore_drink_service.dart';
import 'package:water_reminder_app/src/global_blocs/bloc_base.dart';

class DrinkBloc implements BlocBase {
  StreamSubscription _drinkStreamSubscription;
  List<Drink> _drinksToday = List();
  int _selectedDrinkAmount = 200;

  final _drinkController = BehaviorSubject<List<Drink>>();
  Function(List<Drink>) get _inDrinks => _drinkController.sink.add;
  Stream<List<Drink>> get outDrinks => _drinkController.stream;

  final _selectedDrinkAmountController = BehaviorSubject<int>();
  Function(int) get _inSelectedAmount => _selectedDrinkAmountController.sink.add;
  Stream<int> get outSelectedAmount => _selectedDrinkAmountController.stream;

  Stream<int> get outDrinksAmount {
    return outDrinks.map((drinks) => drinks.fold<int>(0, (totalAmount, drink) => totalAmount + drink.amount));
  }

  Future<void> init() async {
    final drinkStream = await FirestoreDrinkService.getDrinksStream(DateTime.now());
    _drinkStreamSubscription = drinkStream.listen((querySnapshot) {
      _drinksToday = querySnapshot.documents.map((doc) => Drink.fromDb(doc.data, doc.documentID)).toList();
      _inDrinks(_drinksToday);
    });

    _inSelectedAmount(_selectedDrinkAmount);
  }

  Future<void> drinkWater() async {
    final drink = Drink(DateTime.now(), _selectedDrinkAmount);
    FirestoreDrinkService.drinkWater(drink);
  }

  Future<void> removeDrink(Drink drink) async {
    FirestoreDrinkService.removeDrink(drink);
  }

  set setDrinkAmount(int amount) {
    _selectedDrinkAmount = amount;
    _inSelectedAmount(_selectedDrinkAmount);
  }

  @override
  void dispose() {
    _drinkController.close();
    _selectedDrinkAmountController.close();
    _drinkStreamSubscription.cancel();
  }
}
