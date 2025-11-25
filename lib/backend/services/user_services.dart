import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookmate/backend/auth.dart';
import 'package:cookmate/backend/model/user.dart';
import 'package:cookmate/core/helper.dart';
import 'package:cookmate/core/static.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:http/http.dart' as http;

class UserServices {
  static const serverPath = '/users';

  static Future<bool> updateProfile(String userId,  BuildContext context , {String? fullName, String? phoneNumber, Map<String, bool>? role, GeoPoint? geoPoint}) async{
    try {
      final url = Uri.https(StaticClass.serverBaseURL, '${StaticClass.serverApiURL}$serverPath/$userId');
      var response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
            'Accept': 'application/json',
            'Authorization': StaticClass.jsonWebToken!
          },
          body: jsonEncode({
            'fullName' : fullName,
            'phoneNumber' : phoneNumber,
            'geoPoint' : geoPoint != null ? GeoFirePoint(geoPoint).data : null,
            'role' : role
          })
      );
      if (response.statusCode.toString().contains('20')){

        if (context.mounted){
          final userData = await Auth.getUserData(context, StaticClass.jsonWebToken!, StaticClass.currentUser!.uid!);
          StaticClass.currentUser = UserModel.fromJSON(userData);
        }
        return true;
      }
      else{
        final data = jsonDecode(response.body);
        if (context.mounted){
          Helper.showError(context, data['error']);
        }
        return false;
      }

    } on Exception catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      if (context.mounted) {
        Helper.showError(context, "Internal Error");
      }
      return false;
    }
  }
}