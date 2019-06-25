import 'package:flutter/material.dart';
import 'package:water_reminder_app/services/firestore/firestore_user_service.dart';
import 'package:water_reminder_app/src/root_page.dart';
import 'package:water_reminder_app/src/widgets/buttons/custom_wide_flat_button.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int selectedAmount = 2500;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 100, width: double.infinity),
            appIcon(),
            smallTextSpace,
            title(textTheme),
            smallTextSpace,
            subTitle(textTheme),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  OutlineButton(
                    padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 16),
                    onPressed: () async {
                      int amount = await showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          return CustomAmountOnboardingPopup();
                        },
                      );
                      setState(() => selectedAmount = amount);
                    },
                    child: Text(
                      '$selectedAmount ml',
                      style: textTheme.title,
                    ),
                  ),
                ],
              ),
            ),
            CustomWideFlatButton(
              backgroundColor: Colors.blue.shade300,
              foregroundColor: Colors.blue.shade900,
              isRoundedAtBottom: false,
              text: 'Start',
              onPressed: () async {
                await FirestoreUserService.updateTotalWater(selectedAmount);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => RootPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget get smallTextSpace => SizedBox(height: 8);

  Widget appIcon() {
    return Image.asset(
      'assets/sign_in_icon.png',
      width: 125,
      height: 125,
    );
  }

  Text title(TextTheme textTheme) {
    return Text(
      'We help you drink water',
      style: textTheme.title.copyWith(
        fontSize: 24,
      ),
    );
  }

  Text subTitle(TextTheme textTheme) {
    return Text(
      'Set your daily water intake goal',
      style: textTheme.subtitle.copyWith(fontWeight: FontWeight.w400),
    );
  }
}

class CustomAmountOnboardingPopup extends StatefulWidget {
  @override
  _CustomAmountOnboardingPopupState createState() => _CustomAmountOnboardingPopupState();
}

class _CustomAmountOnboardingPopupState extends State<CustomAmountOnboardingPopup> {
  final _controller = TextEditingController();
  Icon _errorIcon;

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
                  'Enter your amount',
                  style: Theme.of(context).textTheme.title.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                ),
                smallSpace,
                Text(
                  'change the amount field with your custom amount',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle.copyWith(
                        color: Colors.black,
                      ),
                ),
                largeSpace,
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (value) => setValue(value),
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        suffixIcon: _errorIcon,
                        suffixText: 'ml',
                        fillColor: Colors.grey.shade300,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          largeSpace,
          CustomWideFlatButton(
            text: 'Ok',
            onPressed: () => setValue(_controller.text),
            backgroundColor: Theme.of(context).accentColor,
            foregroundColor: Colors.blue.shade900,
          ),
        ],
      ),
    );
  }

  Widget get largeSpace => SizedBox(height: 24);
  Widget get smallSpace => SizedBox(height: 12);

  void setValue(String amountAsString) {
    Icon error = Icon(Icons.error, color: Colors.red);
    if (amountAsString.isEmpty) {
      setState(() {
        _errorIcon = error;
      });
      return;
    }
    int amount = int.parse(amountAsString);
    if (amount <= 500) {
      setState(() {
        _errorIcon = error;
      });
      return;
    }
    setState(() {
      _errorIcon = null;
    });

    Navigator.of(context).pop(amount);
  }
}
