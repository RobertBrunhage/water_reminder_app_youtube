import 'package:flutter/material.dart';

class CustomWideFlatButton extends StatelessWidget {
  const CustomWideFlatButton({
    Key key,
    @required this.onPressed,
    @required this.backgroundColor,
    @required this.foregroundColor,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(5),
        ),
      ),
      color: Colors.blue.shade300,
      child: Container(
        alignment: Alignment.center,
        height: 50,
        width: double.infinity,
        child: Text(
          'Create',
          style: TextStyle(
            color: Colors.blue.shade900,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
