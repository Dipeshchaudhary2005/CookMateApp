import 'package:cookmate/backend/auth.dart';
import 'package:cookmate/backend/model/user.dart';
import 'package:cookmate/core/static.dart';
import 'package:cookmate/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  static Future<bool> loadDashBoard(
    BuildContext context, {
    String? userType,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final storage = FlutterSecureStorage();

    userType ??= prefs.getString(UserModel.userTypeField);
    StaticClass.jsonWebToken ??= await storage.read(key: StaticClass.jsonWebTokenField);

    if (StaticClass.jsonWebToken == null || Auth.jwtIsExpired(StaticClass.jsonWebToken!)) return false;
    if (StaticClass.currentUser == null) {
      if (context.mounted){
        String? uid = await Auth.verifyToken(context, StaticClass.jsonWebToken!);
        if (uid != null){
          if (context.mounted){
            StaticClass.currentUser = await Auth.getUserData(context, StaticClass.jsonWebToken!, uid);
          }
          else {return false;}
        }else {
          return false;
        }
      } else{
        return false;
      }
    }

    if (StaticClass.currentUser!.userType![UserModel.chefField] == true &&
        (userType == null || userType == UserModel.chefField)) {
      if (context.mounted) {
        Navigator.pushNamed(context, AppRoutes.chefDashboardRoute);
        await storage.write(key: StaticClass.jsonWebTokenField, value: StaticClass.jsonWebToken);
        await prefs.setString(UserModel.userTypeField, UserModel.chefField);
      }
    } else if (StaticClass.currentUser!.userType![UserModel.customerField] ==
            true &&
        (userType == null || userType == UserModel.customerField)) {
      if (context.mounted) {
        Navigator.pushNamed(context, AppRoutes.customerDashboardRoute);
        await storage.write(key: StaticClass.jsonWebTokenField, value: StaticClass.jsonWebToken);
        await prefs.setString(UserModel.userTypeField, UserModel.customerField);
      }
    }
    return true;
  }

  static void showError(BuildContext context, String message, {int? statusCode}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
    if (statusCode != null && statusCode == 401){
      Auth.signOut();
    }
  }

  static AlertDialog confirmLogOut(BuildContext context) {
    return AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Navigate back to landing page
            Auth.signOut();
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.landingPageRoute,
              (route) => false,
            );
            // Navigator.pushAndRemoveUntil(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const LandingPage(),
            //   ),
            //       (route) => false,
            // );
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Logout'),
        ),
      ],
    );
  }
}
