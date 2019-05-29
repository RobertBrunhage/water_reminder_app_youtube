import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  static const lastLoggedInField = 'lastLoggedIn';
  static const waterPerDayField = 'waterPerDay'; // will be in ml

  User(this.lastLoggedIn, this.waterPerDay);

  User.temp() {
    this.lastLoggedIn = DateTime.now();
    this.waterPerDay = 0;
  }

  User.fromDb(Map<String, dynamic> json) {
    this.waterPerDay = json[waterPerDayField];
    this.lastLoggedIn = json[lastLoggedInField].toDate();
  }

  Map<String, dynamic> toJson() {
    return {
      lastLoggedInField: Timestamp.fromDate(this.lastLoggedIn),
      waterPerDayField: this.waterPerDay,
    };
  }

  DateTime lastLoggedIn;
  int waterPerDay;
}
