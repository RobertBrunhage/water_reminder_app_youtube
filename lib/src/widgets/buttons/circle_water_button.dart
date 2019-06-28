import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:water_reminder_app/src/global_blocs/app_bloc.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    final drinkBloc = Provider.of<AppBloc>(context).drinkBloc;

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
    final drinkBloc = Provider.of<AppBloc>(context).drinkBloc;
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
  })  : _animationController = animationController,
        super(key: key);

  final AnimationController _animationController;

  @override
  Widget build(BuildContext context) {
    final drinkBloc = Provider.of<AppBloc>(context).drinkBloc;
    final userbloc = Provider.of<AppBloc>(context).userBloc;
    final observable = Observable.combineLatest2<int, int, double>(userbloc.outMaxWater, drinkBloc.outDrinksAmount, (
      maxWater,
      consumedWater,
    ) {
      return consumedWater / maxWater;
    });

    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        shape: BoxShape.circle,
      ),
      child: StreamBuilder<double>(
        stream: observable,
        initialData: 0,
        builder: (context, snapshot) {
          _animationController.animateTo(snapshot.data);
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
