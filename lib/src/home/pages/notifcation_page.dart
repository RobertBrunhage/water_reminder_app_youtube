import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:water_reminder_app/src/pages/create_notification_page.dart';
import 'package:water_reminder_app/src/utils/notification_plugin.dart';
import 'package:water_reminder_app/src/view_models/notification_data.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationPlugin _notificationPlugin = NotificationPlugin();
  Future<List<PendingNotificationRequest>> notificationFuture;

  @override
  void initState() {
    super.initState();
    notificationFuture = _notificationPlugin.getScheduledNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          FutureBuilder<List<PendingNotificationRequest>>(
            future: notificationFuture,
            initialData: [],
            builder: (context, snapshot) {
              final notifications = snapshot.data;
              return Expanded(
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Text(notification.title);
                  },
                ),
              );
            },
          ),
          FlatButton(
            padding: EdgeInsets.all(0),
            onPressed: navigateToNotificationCreation,
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
          ),
        ],
      ),
    );
  }

  Future<void> navigateToNotificationCreation() async {
    NotificationData notificationData = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateNotificationPage(),
      ),
    );
    if (notificationData != null) {
      final notificationList = await _notificationPlugin.getScheduledNotifications();
      int id = 0;
      for (var i = 0; i < 100; i++) {
        bool exists = _notificationPlugin.checkIfIdExists(notificationList, i);
        if (!exists) {
          id = i;
        }
      }
      await _notificationPlugin.showDailyAtTime(
        notificationData.time,
        id,
        notificationData.title,
        notificationData.description,
      );
      setState(() {
        notificationFuture = _notificationPlugin.getScheduledNotifications();
      });
    }
  }
}
