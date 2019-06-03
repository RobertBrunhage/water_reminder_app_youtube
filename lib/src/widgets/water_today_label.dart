import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder_app/src/global_blocs/drink_bloc.dart';
import 'package:water_reminder_app/src/global_blocs/user_bloc.dart';

class WaterTodayLabel extends StatelessWidget {
  const WaterTodayLabel({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userBloc = Provider.of<UserBloc>(context);
    final drinkBloc = Provider.of<DrinkBloc>(context);
    return Padding(
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
    );
  }
}
