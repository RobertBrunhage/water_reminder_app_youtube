import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder_app/models/drink.dart';
import 'package:water_reminder_app/src/global_blocs/drink_bloc.dart';
import 'package:water_reminder_app/src/global_blocs/user_bloc.dart';
import 'package:water_reminder_app/src/widgets/water_entry_tile.dart';

class DrinkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userBloc = Provider.of<UserBloc>(context);
    final drinkBloc = Provider.of<DrinkBloc>(context);
    return Column(
      children: <Widget>[
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: StreamBuilder<int>(
                  stream: userBloc.outMaxWater,
                  initialData: 0,
                  builder: (context, snapshot) {
                    final maxWater = snapshot.data;
                    return StreamBuilder<int>(
                      stream: drinkBloc.outDrinksAmount,
                      initialData: 0,
                      builder: (context, snapshot) {
                        final waterAmount = snapshot.data;
                        return Text(
                          '$waterAmount / ${maxWater}ml',
                          style: Theme.of(context).textTheme.title,
                        );
                      },
                    );
                  },
                ),
              ),
              InkWell(
                onTap: () => drinkBloc.drinkWater(),
                child: CircleAvatar(
                  radius: 84,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: StreamBuilder<List<Drink>>(
            stream: drinkBloc.outDrinks,
            initialData: [],
            builder: (context, snapshot) {
              final drinks = snapshot.data;
              return ListView.builder(
                itemCount: drinks.length,
                itemBuilder: (context, index) {
                  final drink = drinks[index];
                  return WaterEntryTile(drink: drink);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
