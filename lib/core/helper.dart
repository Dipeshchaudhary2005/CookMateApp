import 'package:cookmate/backend/auth.dart';
import 'package:cookmate/backend/model/user.dart';
import 'package:cookmate/core/static.dart';
import 'package:cookmate/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  static Future<bool> loadDashBoard(
    BuildContext context, {
    UserType? userType,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final storage = FlutterSecureStorage();

    final storedLoginType = prefs.getString(UserModel.userTypeField);
    userType ??= storedLoginType != null ? UserType.fromString(storedLoginType) : null;
    StaticClass.jsonWebToken ??= await storage.read(
      key: StaticClass.jsonWebTokenField,
    );

    if (StaticClass.jsonWebToken == null ||
        Auth.jwtIsExpired(StaticClass.jsonWebToken!)) {
      return false;
    }
    if (StaticClass.currentUser == null) {
      if (context.mounted) {
        String? uid = await Auth.verifyToken(
          context,
          StaticClass.jsonWebToken!,
        );
        if (uid != null) {
          if (context.mounted) {
            StaticClass.currentUser = await Auth.getUserData(
              context,
              StaticClass.jsonWebToken!,
              uid,
            );
          } else {
            return false;
          }
        } else {
          return false;
        }
      } else {
        return false;
      }
    }
    if (userType == null) return false;
    // TODO
    // Fix the login process to show error if the user is not registered for that user type
    // Also create method to add or remove user user
    if (StaticClass.currentUser!.userType!.contains(userType)){
      print("Current user: ${StaticClass.currentUser}");
      print("User Type: $userType");
      if (userType == UserType.chef){
        if (context.mounted){
          Navigator.pushNamed(context, AppRoutes.chefDashboardRoute);
          await storage.write(
            key: StaticClass.jsonWebTokenField,
            value: StaticClass.jsonWebToken
          );
          await prefs.setString(UserModel.userTypeField, userType.toString());
      }
      }

      else if (userType == UserType.customer){
        if (context.mounted){
          Navigator.pushNamed(context, AppRoutes.customerDashboardRoute);
          await storage.write(
            key: StaticClass.jsonWebTokenField,
            value: StaticClass.jsonWebToken
          );
          await prefs.setString(UserModel.userTypeField, userType.toString());
        }
      }
      else if (userType == UserType.admin){
        // TODO
        return false;
      }
    }
    else {
      if (context.mounted){
        Helper.showError(context, "The user is not registerd for the role of $userType. \nTry regestring for that role");
      }
      return false;
    }
    return true;
  }

  static void showError(
    BuildContext context,
    String message, {
    int? statusCode,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
    if (statusCode != null && statusCode == 401) {
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
