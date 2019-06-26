import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder_app/src/global_blocs/auth/auth.dart';
import 'package:water_reminder_app/src/widgets/buttons/anonymous_sign_in_button.dart';
import 'package:water_reminder_app/src/widgets/buttons/google_sign_in_button.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final auth = Provider.of<Auth>(context);

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
                  GoogleSignInButton(
                    onPressed: auth.signInWithGoogle,
                  ),
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

  Widget appIcon() {
    return Image.asset(
      'assets/sign_in_icon.png',
      width: 125,
      height: 125,
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
