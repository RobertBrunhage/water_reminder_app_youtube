class NotificationData {
  static const String idField = 'id';
  static const String notificationIdField = 'notificationId';
  static const String titleField = 'title';
  static const String descriptionField = 'description';
  static const String hourField = 'hour';
  static const String minuteField = 'minute';

  String id;
  int notificationId;
  String title;
  String description;
  int hour;
  int minute;

  NotificationData(this.title, this.description, this.hour, this.minute);

  NotificationData.fromDb(Map<String, dynamic> json, String id) {
    this.id = id;
    this.notificationId = json[notificationIdField];
    this.title = json[titleField];
    this.description = json[descriptionField];
    this.hour = json[hourField];
    this.minute = json[minuteField];
  }

  Map<String, dynamic> toJson() {
    return {
      notificationIdField: this.notificationId,
      titleField: this.title,
      descriptionField: this.description,
      hourField: this.hour,
      minuteField: this.minute,
    };
  }

  @override
  String toString() {
    return 'title: $title, notificationId: $notificationId, hour: $hour, minute: $minute';
  }
}
