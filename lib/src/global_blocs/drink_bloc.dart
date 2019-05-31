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

  final _drinkController = BehaviorSubject<List<Drink>>();
  Function(List<Drink>) get _inDrinks => _drinkController.sink.add;
  Stream<List<Drink>> get outDrinks => _drinkController.stream;

  Future<void> init() async {
    final drinkStream = await FirestoreDrinkService.getDrinksStream(DateTime.now());
    _drinkStreamSubscription = drinkStream.listen((querySnapshot) {
      _drinksToday = querySnapshot.documents.map((doc) => Drink.fromDb(doc.data)).toList();
      _inDrinks(_drinksToday);
    });
  }

  @override
  void dispose() {
    _drinkController.close();
    _drinkStreamSubscription.cancel();
  }
}
