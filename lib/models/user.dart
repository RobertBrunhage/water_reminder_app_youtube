import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  static const lastLoggedInField = 'lastLoggedIn';
  static const waterPerDayField = 'waterPerDay'; // will be in ml
  static const maxWaterPerDayField = 'maxWaterPerDay';

  User(this.lastLoggedIn, this.maxWaterPerDay);

  User.temp() {
    this.lastLoggedIn = DateTime.now();
    this.maxWaterPerDay = 1;
  }

  User.fromDb(Map<String, dynamic> json) {
    this.maxWaterPerDay = json[maxWaterPerDayField];
    this.lastLoggedIn = json[lastLoggedInField].toDate();
  }

  Map<String, dynamic> toJson() {
    return {
      lastLoggedInField: Timestamp.fromDate(this.lastLoggedIn),
      maxWaterPerDayField: this.maxWaterPerDay,
    };
  }

  DateTime lastLoggedIn;
  int maxWaterPerDay;
}
