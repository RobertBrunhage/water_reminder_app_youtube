import 'package:flutter/material.dart';
import 'package:water_reminder_app/models/drink.dart';

class WaterEntryTile extends StatelessWidget {
  const WaterEntryTile({
    Key key,
    @required this.drink,
  }) : super(key: key);

  final Drink drink;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
      child: ListTile(
        title: Text(drink.amount.toString()),
        subtitle: Text(drink.date.toString().substring(0, 10)),
      ),
    );
  }
}
