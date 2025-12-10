import 'dart:convert';
import 'dart:io';

import 'package:cookmate/backend/auth.dart';
import 'package:cookmate/backend/model/user.dart';
import 'package:cookmate/core/helper.dart';
import 'package:cookmate/core/static.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class UserServices {
  static const serverPath = '/auth/users';

  static Future<bool> updateProfile(
    BuildContext context, {
    String? fullName,
    String? phoneNumber,
    Map<String, bool>? role,
    double? longitude,
    double? latitude,
    String? userAddress,
    String? bio,
  }) async {
    try {
      final userId = StaticClass.currentUser!.uid!;
      final url = Uri.https(
        StaticClass.serverBaseURL,
        '${StaticClass.serverApiURL}$serverPath/$userId',
      );
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
          'Authorization': StaticClass.jsonWebToken!,
        },
        body: jsonEncode({
          UserModel.fullNameField: fullName,
          UserModel.phoneNumberField: phoneNumber,
          UserModel.locationField: [longitude, latitude],
          UserModel.userTypeField: role,
          UserModel.userAddressField: userAddress,
          UserModel.bioField: bio,
        }),
      );
      if (response.statusCode.toString().contains('20')) {
        if (context.mounted) {
          final userData = await Auth.getUserData(
            context,
            StaticClass.jsonWebToken!,
            StaticClass.currentUser!.uid!,
          );
          StaticClass.currentUser = userData;
        }
        return true;
      } else {
        final data = jsonDecode(response.body);
        if (context.mounted) {
          Helper.showError(context, data['error']);
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      if (context.mounted) {
        Helper.showError(context, "Internal Error");
      }
      return false;
    }
  }

  static Future<bool> changeUserEmail(
    BuildContext context,
    String newEmail,
  ) async {
    try {
      final userId = StaticClass.currentUser!.uid!;
      final url = Uri.https(
        StaticClass.serverBaseURL,
        '${StaticClass.serverApiURL}$serverPath/$userId/email',
      );
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
          'Authorization': StaticClass.jsonWebToken!,
        },
        body: jsonEncode({UserModel.emailField: newEmail}),
      );
      if (response.statusCode.toString().contains('20')) {
        if (context.mounted) {
          final userData = await Auth.getUserData(
            context,
            StaticClass.jsonWebToken!,
            StaticClass.currentUser!.uid!,
          );
          StaticClass.currentUser = userData;
        }
        return true;
      } else {
        final data = jsonDecode(response.body);
        if (context.mounted) {
          Helper.showError(context, data['error']);
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      if (context.mounted) {
        Helper.showError(context, "Internal Error");
      }
      return false;
    }
  }

  static Future<bool> updateProfilePic(BuildContext context, File image) async {
    try {
      final userId = StaticClass.currentUser!.uid!;
      final url = Uri.https(
        StaticClass.serverBaseURL,
        '${StaticClass.serverApiURL}$serverPath/$userId/pic',
      );
      final request = http.MultipartRequest("POST", url);
      request.headers.addAll({
        "Content-Type": "application/json",
        'Accept': 'application/json',
        'Authorization': StaticClass.jsonWebToken!,
      });
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      final response = await request.send();
      if (response.statusCode.toString().contains('20')) {
        if (!context.mounted) return false;
          final userData = await Auth.getUserData(
            context,
            StaticClass.jsonWebToken!,
            StaticClass.currentUser!.uid!,
          );
          StaticClass.currentUser = userData;
        return true;
      } else {
        final responseData = await response.stream.bytesToString();
        final data = jsonDecode(responseData);
        if (context.mounted) {
          Helper.showError(context, data['error']);
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      if (context.mounted) {
        Helper.showError(context, "Internal Error");
      }
      return false;
    }
  }

  static Future<bool> updateChefFields(
    BuildContext context, {
    String? speciality,
    String? experience,
    List<String>? cuisines,
  }) async {
    try {
      final userId = StaticClass.currentUser!.uid!;
      final url = Uri.https(
        StaticClass.serverBaseURL,
        '${StaticClass.serverApiURL}$serverPath/$userId/chef',
      );
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
          'Authorization': StaticClass.jsonWebToken!,
        },
        body: jsonEncode({
          UserModel.specialityField: speciality,
          UserModel.experienceField: experience,
          UserModel.cuisinesField: cuisines,
        }),
      );

      if (response.statusCode.toString().contains('20')) {
        final data = jsonDecode(response.body);
        StaticClass.currentUser = UserModel.fromJSON(data['user']);
        return true;
      } else {
        final data = jsonDecode(response.body);
        if (context.mounted) {
          Helper.showError(context, data['error']);
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error updating Chef Field ${e.toString()}");
      }
      if (context.mounted) {
        Helper.showError(context, "Internal Error");
      }
      return false;
    }
  }
  
  static Future<bool> generateOTP (BuildContext context, String email) async {
    try{
      final uri = Uri.https(StaticClass.serverBaseURL, '${StaticClass.serverApiURL}/otp/generate');
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email' : email
        })
      );
      if (response.statusCode.toString().contains('20')){
        return true;
      } else {
        final data = jsonDecode(response.body);
        if (context.mounted){
          Helper.showError(context, data['error']);
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error generating OTP ${e.toString()}");
      }
      if (context.mounted) {
        Helper.showError(context, "Internal Error");
      }
      return false;
    }
  }

  static Future<String?> verifyOTP (BuildContext context, String email, String otp) async {
    try{
      final uri = Uri.https(StaticClass.serverBaseURL, '${StaticClass.serverApiURL}/otp/verify');
      final response = await http.post(
          uri,
          headers: {
            "Content-Type": "application/json",
            'Accept': 'application/json',
          },
          body: jsonEncode({
            'email' : email,
            'otp' : otp
          })
      );
      if (response.statusCode.toString().contains('20')){
        final data = jsonDecode(response.body);
        final token = data['token'] as String;
        return token;
      } else {
        final data = jsonDecode(response.body);
        if (context.mounted){
          Helper.showError(context, data['error']);
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error verifying OTP ${e.toString()}");
      }
      if (context.mounted) {
        Helper.showError(context, "Internal Error");
      }
      return null;
    }
  }

  static Future<bool> changePassword (BuildContext context, String token, String password) async {
    try{
      final uri = Uri.https(StaticClass.serverBaseURL, '${StaticClass.serverApiURL}/otp/changePassword');
      final response = await http.post(
          uri,
          headers: {
            "Content-Type": "application/json",
            'Accept': 'application/json',
            'Authorization': token,
          },
          body: jsonEncode({
            'password' : password
          })
      );
      if (response.statusCode.toString().contains('20')){
        return true;
      } else {
        final data = jsonDecode(response.body);
        if (context.mounted){
          Helper.showError(context, data['error']);
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error verifying OTP ${e.toString()}");
      }
      if (context.mounted) {
        Helper.showError(context, "Internal Error");
      }
      return false;
    }
  }
}
