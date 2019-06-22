import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder_app/src/global_blocs/drink_bloc.dart';
import 'package:water_reminder_app/src/global_blocs/user_bloc.dart';
import 'package:water_reminder_app/src/utils/asset_util.dart';

class CircleButton extends StatefulWidget {
  const CircleButton({
    Key key,
  }) : super(key: key);

  @override
  _CircleButtonState createState() => _CircleButtonState();
}

class _CircleButtonState extends State<CircleButton> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation _curvedAnimation;

  AnimationController _fadeInController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _fadeInController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _curvedAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    final drinkBloc = Provider.of<DrinkBloc>(context);

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
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          ProgressCircle(
            animationController: _animationController,
            curvedAnimation: _curvedAnimation,
          ),
          DrinkGlassWithAmount(
            fadeInController: _fadeInController,
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    _fadeInController.dispose();
  }
}

class DrinkGlassWithAmount extends StatelessWidget {
  const DrinkGlassWithAmount({
    Key key,
    @required this.fadeInController,
  }) : super(key: key);

  final AnimationController fadeInController;

  @override
  Widget build(BuildContext context) {
    final drinkBloc = Provider.of<DrinkBloc>(context);
    return StreamBuilder<int>(
      stream: drinkBloc.outSelectedAmount,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final selectedAmount = snapshot.data;
          fadeInController.forward();
          return AnimatedBuilder(
            animation: fadeInController,
            builder: (context, child) {
              return Opacity(
                opacity: fadeInController.value,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      AssetUtil.assetImage(selectedAmount),
                      height: 50,
                      width: 50,
                    ),
                    SizedBox(height: 4),
                    Text('Drink ${selectedAmount}ml'),
                  ],
                ),
              );
            },
          );
        }
        return SizedBox();
      },
    );
  }
}

class ProgressCircle extends StatelessWidget {
  const ProgressCircle({
    Key key,
    @required AnimationController animationController,
    @required Animation curvedAnimation,
  })  : _animationController = animationController,
        _curvedAnimation = curvedAnimation,
        super(key: key);

  final AnimationController _animationController;
  final Animation _curvedAnimation;

  @override
  Widget build(BuildContext context) {
    final drinkBloc = Provider.of<DrinkBloc>(context);
    final userbloc = Provider.of<UserBloc>(context);
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
              double percent = waterConsumed / totalWater;
              _animationController.animateTo(percent);
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
    );
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
