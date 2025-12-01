import 'dart:convert';

import 'package:cookmate/backend/model/booking.dart';
import 'package:cookmate/core/helper.dart';
import 'package:cookmate/core/static.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BookingServices {
  static Future<Booking?> createBooking(BuildContext context) async {
    try{
      final url = Uri.https(StaticClass.serverBaseURL, '${StaticClass.serverApiURL}/booking');
      final response = await http.post(
        url
      );
      if (response.statusCode.toString().contains('20')){
        return Booking();
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