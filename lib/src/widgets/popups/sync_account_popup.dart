import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder_app/src/global_blocs/auth/auth_bloc.dart';
import 'package:water_reminder_app/src/widgets/buttons/google_sign_in_button.dart';

class SyncAccountPopup extends StatefulWidget {
  @override
  _SyncAccountPopupState createState() => _SyncAccountPopupState();
}

class _SyncAccountPopupState extends State<SyncAccountPopup> {
  String errorMessage;
  Icon errorIcon;

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
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
                  'Sync account',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.title.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                ),
                SizedBox(height: 12),
                if (errorMessage != null)
                  errorMessageBox()
                else
                  Text(
                    'All your current data will be synced\nwith the selected account',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle.copyWith(
                          color: Colors.black,
                        ),
                  ),
                SizedBox(height: 24),
                GoogleSignInButton(
                  onPressed: () => syncWithGoogle(authBloc),
                ),
                SizedBox(height: 14),
              ],
            ),
          ),
          SizedBox(height: 24),
          FlatButton(
            padding: EdgeInsets.all(0),
            onPressed: () => Navigator.of(context).pop(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
            ),
            color: Colors.grey.shade300,
            child: Container(
              alignment: Alignment.center,
              height: 50,
              width: double.infinity,
              child: Text(
                'Not now',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget errorMessageBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.yellow.shade200,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        errorMessage,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.subtitle.copyWith(
              color: Colors.yellow.shade900,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  void syncWithGoogle(AuthBloc authBloc) async {
    try {
      await authBloc.syncWithGoogle();
      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        errorMessage = e.message.toString();
      });
      print(e);
    }
  }
}
