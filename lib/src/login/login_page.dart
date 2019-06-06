import 'package:flutter/material.dart';
import 'package:water_reminder_app/src/widgets/buttons/anonymous_sign_in_button.dart';
import 'package:water_reminder_app/src/widgets/buttons/google_sign_in_button.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
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
                  GoogleSignInButton(),
                  AnonymousSignInButton(),
                ],
              ),
            ),
            Text(
              'By creating an account, you are agreeing to our\nTerms of Service and Privacy Policy',
              textAlign: TextAlign.center,
            ),
            smallTextSpace,
          ],
        ),
      ),
    );
  }

  Widget get smallTextSpace => SizedBox(height: 8);

  SizedBox appIcon() {
    return SizedBox(
      height: 125,
      width: 125,
      child: Placeholder(),
    );
  }

  Text title(TextTheme textTheme) {
    return Text(
      'Water reminder',
      style: textTheme.title.copyWith(
        fontSize: 24,
      ),
    );
  }

  Text subTitle(TextTheme textTheme) {
    return Text(
      'We help you drink enough water',
      style: textTheme.subtitle.copyWith(fontWeight: FontWeight.w400),
    );
  }
}
