import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder_app/src/global_blocs/drink_bloc.dart';
import 'package:water_reminder_app/src/global_blocs/user_bloc.dart';

class CircleButton extends StatefulWidget {
  const CircleButton({
    Key key,
  }) : super(key: key);

  @override
  _CircleButtonState createState() => _CircleButtonState();
}

class _CircleButtonState extends State<CircleButton> with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
  }

  @override
  Widget build(BuildContext context) {
    final drinkBloc = Provider.of<DrinkBloc>(context);
    final userbloc = Provider.of<UserBloc>(context);
    return Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: StreamBuilder<int>(
          stream: userbloc.outMaxWater,
          initialData: 1,
          builder: (context, snapshot) {
            final totalWater = snapshot.data;
            return StreamBuilder<int>(
              stream: drinkBloc.outDrinksAmount,
              initialData: 0,
              builder: (context, snapshot) {
                final waterConsumed = snapshot.data;
                print(waterConsumed / totalWater);
                _animationController.animateTo(waterConsumed / totalWater);
                return AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return CustomPaint(
                      foregroundPainter: CircleProgressPainter(
                        completeColor: Colors.blue,
                        lineColor: Colors.grey,
                        completePercent: _animationController.value,
                      ),
                    );
                  },
                );
              },
            );
          },
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }
}

class CircleProgressPainter extends CustomPainter {
  CircleProgressPainter({this.lineColor, this.completeColor, this.completePercent});
  final Color lineColor;
  final Color completeColor;
  final double completePercent;
  final double lineWidth = 8;

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth;

    Paint completeLine = Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth;

    Offset center = Offset(size.width / 2, size.height / 2);

    double radius = min(size.width / 2 - (lineWidth / 2), size.height / 2 - (lineWidth / 2));

    canvas.drawCircle(center, radius, line);

    double arcAngle = 2 * pi * (completePercent);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      arcAngle,
      false,
      completeLine,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
