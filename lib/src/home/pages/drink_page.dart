import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder_app/src/global_blocs/user_bloc.dart';

class DrinkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userBloc = Provider.of<UserBloc>(context);
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
                    return Text(
                      '0 / ${maxWater}ml',
                      style: Theme.of(context).textTheme.title,
                    );
                  },
                ),
              ),
              CircleAvatar(
                radius: 84,
              ),
            ],
          ),
        ),

        // placeholder for potential list of when I drank water today
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
