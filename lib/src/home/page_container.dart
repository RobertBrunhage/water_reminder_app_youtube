import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder_app/models/user.dart';
import 'package:water_reminder_app/src/enums/enums.dart';
import 'package:water_reminder_app/src/global_blocs/auth/auth_bloc.dart';
import 'package:water_reminder_app/src/home/pages/cups_page.dart';
import 'package:water_reminder_app/src/home/pages/drink_page.dart';
import 'package:water_reminder_app/src/home/pages/notifcation_page.dart';
import 'package:water_reminder_app/src/widgets/popups/sync_account_popup.dart';

class PageContainer extends StatefulWidget {
  const PageContainer({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  _PageContainerState createState() => _PageContainerState();
}

class _PageContainerState extends State<PageContainer> {
  int _currentIndex = 1;
  final List<Widget> _children = [
    CupsPage(),
    DrinkPage(),
    NotificationPage(),
  ];
  AuthBloc authBloc;
  bool isAnonymous = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    authBloc = Provider.of<AuthBloc>(context);
    final firebaseUser = await authBloc.currentUser();
    setState(() {
      isAnonymous = firebaseUser.isAnonymous;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Water Reminder'),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (value) => onMenuSelection(value, authBloc),
            itemBuilder: (context) {
              return [
                const PopupMenuItem<PopupMenuChoices>(
                  value: PopupMenuChoices.signOut,
                  child: Text('sign out'),
                ),
                if (isAnonymous)
                  const PopupMenuItem<PopupMenuChoices>(
                    value: PopupMenuChoices.syncPopup,
                    child: Text('sync account'),
                  ),
              ];
            },
          ),
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).accentColor,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_drink),
            title: Text('Cups'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            title: Text('Notification'),
          ),
        ],
      ),
    );
  }

  void onMenuSelection(PopupMenuChoices value, AuthBloc authBloc) async {
    switch (value) {
      case PopupMenuChoices.signOut:
        authBloc.signOut();
        break;
      case PopupMenuChoices.syncPopup:
        await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return SyncAccountPopup();
          },
        );
        final firebaseUser = await authBloc.currentUser();
        setState(() {
          isAnonymous = firebaseUser.isAnonymous;
        });
        break;
      default:
    }
  }
}
