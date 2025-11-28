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
          StaticClass.currentUser = UserModel.fromJSON(userData);
        }
        return true;
      } else {
        final data = jsonDecode(response.body);
        if (context.mounted) {
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
        final responseData = await response.stream.bytesToString();
        final data = jsonDecode(responseData);
        if (context.mounted) {
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
