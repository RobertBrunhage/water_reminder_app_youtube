import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:water_reminder_app/src/pages/create_notification_page.dart';
import 'package:water_reminder_app/src/utils/notification_plugin.dart';
import 'package:water_reminder_app/src/view_models/notification_data.dart';
import 'package:water_reminder_app/src/widgets/buttons/custom_wide_flat_button.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with SingleTickerProviderStateMixin {
  final NotificationPlugin _notificationPlugin = NotificationPlugin();
  Future<List<PendingNotificationRequest>> notificationFuture;

  AnimationController _fadeInController;

  @override
  void initState() {
    super.initState();
    _fadeInController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    notificationFuture = _notificationPlugin.getScheduledNotifications();
  }

  @override
  void dispose() {
    super.dispose();
    _fadeInController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          FutureBuilder<List<PendingNotificationRequest>>(
            future: notificationFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final notifications = snapshot.data;
                _fadeInController.forward();
                if (notifications.isEmpty)
                  return Expanded(
                    child: Center(
                      child: Image.asset(
                        'assets/no_notification.png',
                        width: 300,
                        height: 300,
                      ),
                    ),
                  );
                return Expanded(
                  child: AnimatedBuilder(
                    animation: _fadeInController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeInController.value,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            return NotificationTile(
                              notification: notification,
                              deleteNotification: dismissNotification,
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              }
              return Expanded(child: SizedBox());
            },
          ),
          CustomWideFlatButton(
            onPressed: navigateToNotificationCreation,
            backgroundColor: Colors.blue.shade300,
            foregroundColor: Colors.blue.shade900,
            isRoundedAtBottom: false,
          ),
        ],
      ),
    );
  }

  Future<void> dismissNotification(int id) async {
    await _notificationPlugin.cancelNotification(id);
    refreshNotification();
  }

  void refreshNotification() {
    setState(() {
      notificationFuture = _notificationPlugin.getScheduledNotifications();
    });
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
      refreshNotification();
    }
  }
}

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    Key key,
    @required this.notification,
    @required this.deleteNotification,
  }) : super(key: key);

  final PendingNotificationRequest notification;
  final Function(int id) deleteNotification;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    notification.title,
                    style: textTheme.title.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  smallHeight,
                  Text(
                    notification.body,
                    style: textTheme.subtitle.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  smallHeight,
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.access_time,
                        size: 28,
                        color: Theme.of(context).accentColor,
                      ),
                      SizedBox(width: 12),
                      Text(
                        '12:42',
                        style: textTheme.headline.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => deleteNotification(notification.id),
              icon: Icon(Icons.delete, size: 32),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox get smallHeight => SizedBox(height: 8);
}
