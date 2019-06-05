import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder_app/src/global_blocs/drink_bloc.dart';

class CustomAmountPopup extends StatefulWidget {
  @override
  _CustomAmountPopupState createState() => _CustomAmountPopupState();
}

class _CustomAmountPopupState extends State<CustomAmountPopup> {
  final _controller = TextEditingController();
  Icon _errorIcon;

  @override
  Widget build(BuildContext context) {
    final drinkBloc = Provider.of<DrinkBloc>(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 18, left: 12, right: 12),
            child: Column(
              children: <Widget>[
                Text(
                  'Enter your amount',
                  style: Theme.of(context).textTheme.title.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                ),
                smallSpace,
                Text(
                  'change the amount field with your custom amount',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle.copyWith(
                        color: Colors.black,
                      ),
                ),
                largeSpace,
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (value) => setValue(value, drinkBloc),
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        suffixIcon: _errorIcon,
                        suffixText: 'ml',
                        fillColor: Colors.grey.shade300,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          largeSpace,
          okButton(drinkBloc, context),
        ],
      ),
    );
  }

  FlatButton okButton(DrinkBloc drinkBloc, BuildContext context) {
    return FlatButton(
      padding: const EdgeInsets.all(0),
      onPressed: () => setValue(_controller.text, drinkBloc),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(5),
        ),
      ),
      color: Theme.of(context).accentColor,
      child: Container(
        alignment: Alignment.center,
        height: 50,
        width: double.infinity,
        child: Text('Ok'),
      ),
    );
  }

  Widget get largeSpace => SizedBox(height: 24);
  Widget get smallSpace => SizedBox(height: 12);

  void setValue(String amountAsString, DrinkBloc drinkBloc) {
    Icon error = Icon(Icons.error, color: Colors.red);
    if (amountAsString.isEmpty) {
      setState(() {
        _errorIcon = error;
      });
      return;
    }
    setState(() {
      _errorIcon = null;
    });

    int amount = int.parse(amountAsString);
    drinkBloc.setDrinkAmount = amount;
    Navigator.of(context).pop();
  }
}
