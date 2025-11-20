import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookmate/core/static.dart';
import 'package:flutter/foundation.dart';

import 'model/booking.dart';

class Book {
  Future<String?> createBooking(Booking booking) async {
    try{
      final map = booking.toMap();
      map[Booking.createdAtField] = FieldValue.serverTimestamp();
      map[Booking.updatedAtField] = FieldValue.serverTimestamp();
      var docRef = await FirebaseFirestore.instance.collection(StaticClass.bookingsCollection).add(map);
      return docRef.id;
    } catch (e){
      if (kDebugMode){
        print("Error while creating booking $e");
      }
      return null;
    }
  }

  Future<bool> updateBooking(String bookingId, {Timestamp? selectedDate, List<String>? dishes, Timestamp? startTime, Timestamp? endTime, String? status, String? eventType}) async{
    try{
      final booking = Booking(
        selectedDate: selectedDate,
        startTime: startTime,
        endTime: endTime,
        dishes: dishes,
        status: status,
        eventType: eventType
      );
      final map = booking.toMap();
      map[Booking.updatedAtField] = FieldValue.serverTimestamp();
      final docRef = FirebaseFirestore.instance.collection(StaticClass.bookingsCollection).doc(bookingId);
      await docRef.update(map);
      return true;
    } catch (e){
      if (kDebugMode){
        print("Error updating booking $e");
      }
      return false;
    }
  }
}