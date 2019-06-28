import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder_app/src/global_blocs/app_bloc.dart';
import 'package:water_reminder_app/src/global_blocs/drink_bloc.dart';
import 'package:water_reminder_app/src/utils/asset_util.dart';
import 'package:water_reminder_app/src/widgets/popups/custom_amount_popup.dart';

class CupAmountButton extends StatelessWidget {
  const CupAmountButton({
    Key key,
    this.amount = 0,
  }) : super(key: key);

  final int amount;

  @override
  Widget build(BuildContext context) {
    final drinkBloc = Provider.of<AppBloc>(context).drinkBloc;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
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
                return CupImage(
                  amount: amount,
                  isSelected: selectedAmount == amount,
                );
              },
            ),
          ),
          SizedBox(height: 8),
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

class CupImage extends StatelessWidget {
  const CupImage({
    Key key,
    @required this.amount,
    @required this.isSelected,
    this.width = 50,
    this.height = 50,
  }) : super(key: key);

  final int amount;
  final bool isSelected;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AssetUtil.assetImage(amount),
      width: isSelected ? width + 10 : width,
      height: isSelected ? height + 10 : height,
    );
  }
}
