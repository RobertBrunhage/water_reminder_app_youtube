import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder_app/src/global_blocs/drink_bloc.dart';
import 'package:water_reminder_app/src/global_blocs/user_bloc.dart';

class WaterTodayLabel extends StatefulWidget {
  const WaterTodayLabel({
    Key key,
  }) : super(key: key);

  @override
  _WaterTodayLabelState createState() => _WaterTodayLabelState();
}

class _WaterTodayLabelState extends State<WaterTodayLabel> with SingleTickerProviderStateMixin {
  AnimationController _fadeInController;

  @override
  void initState() {
    super.initState();
    _fadeInController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _fadeInController.dispose();
    super.dispose();
  }

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
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final waterAmount = snapshot.data;
                _fadeInController.forward();
                return AnimatedBuilder(
                  animation: _fadeInController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeInController.value,
                      child: Text(
                        '$waterAmount / ${maxWater}ml',
                        style: Theme.of(context).textTheme.title,
                      ),
                    );
                  },
                );
              }
              return SizedBox(height: 24);
            },
          );
        },
      ),
    );
  }
}
