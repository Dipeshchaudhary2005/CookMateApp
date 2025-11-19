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
  static const createdAtField = 'createdAt';
  static const updatedAtField = 'updatedAt';

  String? eventType;
  Timestamp? selectedDate;
  Timestamp? startTime;
  Timestamp? endTime;

  List<String>? dishes;

  DocumentReference? customerRef;
  DocumentReference? chefRef;

  String? status;

  Booking ({this.eventType, this.selectedDate, this.startTime, this.endTime, this.dishes, this.customerRef, this.chefRef, this.status});

  Map<String, dynamic> toMap(){
    final map = <String, dynamic>{};
    map.putIfNotNull(eventTypeField, eventType);
    map.putIfNotNull(selectedDateField, selectedDate);
    map.putIfNotNull(startTimeField, startTime);
    map.putIfNotNull(endTimeField, endTime);
    map.putIfNotNull(dishesField, dishes);
    map.putIfNotNull(customerRefField, customerRef);
    map.putIfNotNull(chefRefField, chefRef);
    map.putIfNotNull(statusField, status);

    return map;
  }

  factory Booking.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snap){
    final data = snap.data();
    if (data == null) throw Exception("No data for booking");
    return Booking(
      eventType: data[eventTypeField],
      selectedDate: data[selectedDateField],
      startTime: data[startTimeField],
      endTime: data[endTimeField],
      dishes: data[dishesField],
      customerRef: data[customerRefField],
      chefRef: data[chefRefField],
      status: data[statusField]
    );
  }

}

extension NullableMapEntry on Map<String, dynamic> {
  void putIfNotNull(String key, dynamic value) {
    if (value != null) this[key] = value;
  }
}