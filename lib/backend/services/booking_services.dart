import 'dart:convert';

import 'package:cookmate/backend/model/booking.dart';
import 'package:cookmate/backend/model/chef_package.dart';
import 'package:cookmate/core/helper.dart';
import 'package:cookmate/core/static.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BookingServices {
  static Future<Booking?> createBooking(BuildContext context, String chefId, String eventType, String date,
      String timeInterval, int noOfPeople, List<ChefPackage> packages) async {
    try{
      final url = Uri.https(StaticClass.serverBaseURL, '${StaticClass.serverApiURL}/booking');
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
          'Authorization': StaticClass.jsonWebToken!,
        },
        body: jsonEncode({
          "chefId" : chefId,
          "eventType" : eventType,
          "date" : date,
          "timeInterval" : timeInterval,
          "noOfPeople" : noOfPeople,
          "packages" : packages.map((e) => {'id': e.id, 'dishes': e.dishes}).toList()
        })
      );
      if (response.statusCode.toString().contains('20')){
        final data = jsonDecode(response.body);
        final booking = Booking.fromJSON(data['booking']);
        return booking;
      }else {
        final data = jsonDecode(response.body);
        if (context.mounted){
          Helper.showError(context, data['error']);
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode){
        print("Error creating booking: ${e.toString()}");
      }
      if (context.mounted){
        Helper.showError(context, "Internal error");
      }
      return null;
    }
  }

  static Future<List<Booking>?> getBookings(BuildContext context, String userType) async {
    try{
      final uri = Uri.https(StaticClass.serverBaseURL, '${StaticClass.serverApiURL}/booking');
      final response = await http.get(uri,
        headers: {
        "Content-Type": "application/json",
        'Accept': 'application/json',
        'Authorization': StaticClass.jsonWebToken!,
        },
      );
      if (response.statusCode.toString().contains('20')){
        final data = jsonDecode(response.body);
        final bookings = (data['bookings'] as List).map((e) => Booking.fromJSON(e)).toList();
        return bookings;
      }else {
        final data = jsonDecode(response.body);
        if (context.mounted){
          Helper.showError(context, data['error']);
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode){
        print("Error creating booking: ${e.toString()}");
      }
      if (context.mounted){
        Helper.showError(context, "Internal error");
      }
      return null;
    }
  }
}