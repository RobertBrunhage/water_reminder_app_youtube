import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder_app/src/global_blocs/drink_bloc.dart';

class CupsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 18,
      crossAxisSpacing: 18,
      childAspectRatio: 0.85,
      padding: const EdgeInsets.all(12),
      children: <Widget>[
        CupAmountButton(amount: 100),
        CupAmountButton(amount: 200),
        CupAmountButton(amount: 300),
        CupAmountButton(amount: 400),
        CupAmountButton(amount: 500),
        CupAmountButton(amount: 0),
      ],
    );
  }
}

class CupAmountButton extends StatelessWidget {
  const CupAmountButton({
    Key key,
    this.amount = 0,
  }) : super(key: key);

  final int amount;

  @override
  Widget build(BuildContext context) {
    final drinkBloc = Provider.of<DrinkBloc>(context);
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () {
                if (amount == 0) {
                  setCustomAmount(drinkBloc);
                } else {
                  setAmount(drinkBloc);
                }
              },
              child: StreamBuilder<int>(
                stream: drinkBloc.outSelectedAmount,
                initialData: 1,
                builder: (context, snapshot) {
                  final selectedAmount = snapshot.data;
                  return Placeholder(color: selectedAmount == amount ? Colors.blue : Colors.black);
                },
              ),
            ),
          ),
          SizedBox(height: 4),
          if (amount != 0) Text('$amount ml') else Text('Custom'),
        ],
      ),
    );
  }

  void setCustomAmount(DrinkBloc drinkBloc) {}

  void setAmount(DrinkBloc drinkBloc) {
    drinkBloc.setDrinkAmount = amount;
  }
}
