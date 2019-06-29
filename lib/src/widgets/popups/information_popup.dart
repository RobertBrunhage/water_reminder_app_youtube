import 'package:flutter/material.dart';
import 'package:water_reminder_app/src/widgets/buttons/custom_wide_flat_button.dart';

class InformationPopup extends StatelessWidget {
  const InformationPopup({
    Key key,
    this.title,
    this.description,
  }) : super(key: key);

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 18, left: 12, right: 12),
            child: Column(
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(context).textTheme.title.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                ),
                smallSpace,
                SizedBox(
                  height: 150,
                  child: SingleChildScrollView(
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle.copyWith(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          largeSpace,
          CustomWideFlatButton(
            text: 'Ok',
            onPressed: () => Navigator.of(context).pop(),
            backgroundColor: Theme.of(context).accentColor,
            foregroundColor: Colors.blue.shade900,
          ),
        ],
      ),
    );
  }

  Widget get largeSpace => SizedBox(height: 24);
  Widget get smallSpace => SizedBox(height: 12);
}
