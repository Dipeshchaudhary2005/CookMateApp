import 'dart:convert';

import 'package:cookmate/core/helper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:cookmate/core/static.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decode/jwt_decode.dart';

import 'model/user.dart';

class Auth {
  static final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  static final secureStorage = FlutterSecureStorage();
  static final String serverPath = '/auth';
  // Email/Password Registration with Phone Number
  static Future<bool> createUserWithEmail(
    String email,
    String password,
    String fullName,
    UserType userType, {
    required String phoneNumber,
    required BuildContext context,
  }) async {
    try {
      final url = Uri.https(
        StaticClass.serverBaseURL,
        '${StaticClass.serverApiURL}$serverPath/register',
      );
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'fullName': fullName,
          'password': password,
          'phoneNumber': phoneNumber,
          'signInMethod': 'email',
          'role': [userType.name],
        }),
      );
      if (response.statusCode.toString().contains('20')) {
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

  // Email/Password Login
  static Future<bool> loginUserWithEmail(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      final url = Uri.https(
        StaticClass.serverBaseURL,
        '${StaticClass.serverApiURL}$serverPath/login',
      );
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode.toString().contains('20')) {
        final data = jsonDecode(response.body);
        StaticClass.jsonWebToken = data['token'];
        StaticClass.currentUser = UserModel.fromJSON(data['user']);
        if (StaticClass.jsonWebToken != null) {
          await secureStorage.write(
            key: StaticClass.jsonWebTokenField,
            value: StaticClass.jsonWebToken!,
          );
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

  static Future<String?> verifyToken(BuildContext context, String token) async {
    try {
      final url = Uri.https(
        StaticClass.serverBaseURL,
        '${StaticClass.serverApiURL}$serverPath/verifyToken',
      );
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
          'Authorization': token,
        },
      );
      if (response.statusCode.toString().contains('20')) {
        final data = jsonDecode(response.body);
        return data['userId'];
      } else {
        final data = jsonDecode(response.body);
        if (context.mounted) {
          Helper.showError(context, data['error']);
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error verifying jwt: $e');
      }
      if (context.mounted) {
        Helper.showError(context, 'Error verifying jwt');
      }
      return null;
    }
  }

  static Future<UserModel?> getUserData(
    BuildContext context,
    String token,
    String userId,
  ) async {
    final url = Uri.https(
      StaticClass.serverBaseURL,
      '${StaticClass.serverApiURL}$serverPath/users/$userId',
    );
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Accept': 'application/json',
        'Authorization': token,
      },
    );
    if (response.statusCode.toString().contains('20')) {
      final data = jsonDecode(response.body);
      final user = UserModel.fromJSON(data['user']);
      return user;
    } else {
      final data = jsonDecode(response.body);
      if (context.mounted) {
        Helper.showError(context, data['error']);
      }
      return null;
    }
  }

  static Future<bool> signInWithGoogle(
    UserType userType,
    BuildContext context,
  ) async {
    try {
      // TODO
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Google Sign-In error: $e');
      }
      return false;
    }
  }

  static Future<void> signOut() async {
    try {
      await googleSignIn.signOut();
      StaticClass.currentUser = null;
      StaticClass.jsonWebToken = null;
      await secureStorage.delete(key: StaticClass.jsonWebTokenField);
    } catch (e) {
      if (kDebugMode) {
        print('Sign out error: $e');
      }
    }
  }

  static bool jwtIsExpired(String token) {
    bool isExpired = Jwt.isExpired(token);
    if (isExpired) {
      signOut();
      return true;
    } else {
      return false;
    }
  }
}
