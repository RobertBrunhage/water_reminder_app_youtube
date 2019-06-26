import 'package:rxdart/rxdart.dart';
import 'package:water_reminder_app/models/notification_data.dart';
import 'package:water_reminder_app/plugins/notification_plugin.dart';
import 'package:water_reminder_app/services/firestore/firestore_notification_service.dart';
import 'package:water_reminder_app/src/global_blocs/bloc_base.dart';

class NotificationBloc implements BlocBase {
  List<NotificationData> _notifications = List();
  NotificationPlugin _notificationPlugin = NotificationPlugin();

  final _notificationsController = BehaviorSubject<List<NotificationData>>();
  Function(List<NotificationData>) get _inNotifications => _notificationsController.sink.add;
  Stream<List<NotificationData>> get outNotifications => _notificationsController.stream;

  Future<void> init() async {
    final notificationStream = await FirestoreNotificationService.getAllNotifications();
    notificationStream.listen((querySnapshot) {
      _notifications = querySnapshot.documents.map((doc) => NotificationData.fromDb(doc.data, doc.documentID)).toList();
      startNotifications(_notifications);
      _inNotifications(_notifications);
    });
  }

  Future<void> cancelNotifications() async {
    await _notificationPlugin.cancelAllNotifications();
  }

  Future<void> startNotifications(List<NotificationData> notifications) async {
    await _notificationPlugin.scheduleAllNotifications(notifications);
  }

  Future<void> addNotification(NotificationData notification) async {
    int id = 0;
    for (var i = 0; i < 100; i++) {
      bool exists = _checkIfIdExists(_notifications, i);
      if (!exists) {
        id = i;
        break;
      }
    }
    notification.notificationId = id;
    await FirestoreNotificationService.addNotification(notification);
  }

  Future<void> removeNotification(NotificationData notification) async {
    await FirestoreNotificationService.removeNotification(notification);
  }

  bool _checkIfIdExists(List<NotificationData> notifications, int id) {
    for (final notification in notifications) {
      if (notification.notificationId == id) {
        return true;
      }
    }
    return false;
  }

  @override
  void dispose() {
    _notificationsController.close();
  }
}
