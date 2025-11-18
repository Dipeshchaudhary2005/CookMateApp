import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  static const eventTypeField = 'eventType';
  static const selectedDateField = 'selectedDate';
  static const startTimeField = 'startTime';
  static const endTimeField = 'endTime';
  static const dishesField = 'dishes';
  static const customerRefField = 'customerRef';
  static const chefRefField = 'chefRef';
  static const statusField = 'status';

  String eventType;
  DateTime selectedDate;
  Timestamp startTime;
  Timestamp endTime;

  List<String> dishes;

  DocumentReference customerRef;
  DocumentReference chefRef;

  String status;

  Booking (this.eventType, this.selectedDate, this.startTime, this.endTime, this.dishes, this.customerRef, this.chefRef, this.status);
}