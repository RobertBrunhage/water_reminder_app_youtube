import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder_app/src/global_blocs/drink_bloc.dart';
import 'package:water_reminder_app/src/widgets/popups/custom_amount_popup.dart';

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
                  setCustomAmount(drinkBloc, context);
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

  void setCustomAmount(DrinkBloc drinkBloc, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return CustomAmountPopup();
      },
    );
  }

  void setAmount(DrinkBloc drinkBloc) {
    drinkBloc.setDrinkAmount = amount;
  }
}
