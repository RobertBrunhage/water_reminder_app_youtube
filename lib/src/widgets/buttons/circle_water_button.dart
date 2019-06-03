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
  Animation _curvedAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _curvedAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    final drinkBloc = Provider.of<DrinkBloc>(context);
    final userbloc = Provider.of<UserBloc>(context);

    return MaterialButton(
      onPressed: () => drinkBloc.drinkWater(),
      height: 150,
      minWidth: 150,
      color: Colors.white,
      elevation: 8,
      highlightElevation: 2,
      padding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
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
                _animationController.animateTo(waterConsumed / totalWater);
                return AnimatedBuilder(
                  animation: _curvedAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      foregroundPainter: CircleProgressPainter(
                        completeColor: Colors.blue,
                        lineColor: Colors.grey,
                        completePercent: _curvedAnimation.value,
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
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
