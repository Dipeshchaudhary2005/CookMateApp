import 'package:cookmate/backend/auth.dart';
import 'package:cookmate/backend/model/user.dart';
import 'package:cookmate/core/static.dart';
import 'package:cookmate/routes.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Helper {
  static final storage = FlutterSecureStorage();

  static Future<bool> loadDashBoard(
    BuildContext context, {
    UserType? userType,
  }) async {
    // Check persistent login user type
    final storedLoginType = await storage.read(key: UserModel.userTypeField);
    userType ??= storedLoginType != null ? UserType.fromString(storedLoginType) : null;
    if (userType == null) return false;

    // Check persistent login JSON web token
    StaticClass.jsonWebToken ??= await storage.read(key: StaticClass.jsonWebTokenField,);
    if (StaticClass.jsonWebToken == null || Auth.jwtIsExpired(StaticClass.jsonWebToken!)) {
      return false;
    }

    // Get currentUser data for persistent login but skip if logging in
    if (StaticClass.currentUser == null) {
      if (!context.mounted) return false;
      String? uid = await Auth.verifyToken(
        context,
        StaticClass.jsonWebToken!,
      );
      if (uid == null) return false;
      if (!context.mounted) return false;
      StaticClass.currentUser = await Auth.getUserData(
        context,
        StaticClass.jsonWebToken!,
        uid,
      );
    }


    if (!StaticClass.currentUser!.userType!.contains(userType)) {
      if (context.mounted) {
        Helper.showError(context, "The user is not registerd for the role of $userType. \nTry regestring for that role");
      }
      return false;
    }

    // Direct user according to the user type
    if (userType == UserType.chef){
      if (context.mounted){
        Navigator.pushNamed(context, AppRoutes.chefDashboardRoute);
        await storage.write(
          key: StaticClass.jsonWebTokenField,
          value: StaticClass.jsonWebToken
        );
        await storage.write(key: UserModel.userTypeField, value: userType.name);
      }
    }
    else if (userType == UserType.customer){
      if (context.mounted){
        Navigator.pushNamed(context, AppRoutes.customerDashboardRoute);
        await storage.write(
          key: StaticClass.jsonWebTokenField,
          value: StaticClass.jsonWebToken
        );
        await storage.write(key: UserModel.userTypeField, value: userType.name);
      }
    }
    else if (userType == UserType.admin){
      // TODO
      return false;
    }

    return true;
  }

  /// Used to show error messages
  static void showError(
    BuildContext context,
    String message, {
    int? statusCode,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red, duration: Duration(seconds: 3),),
    );
    if (statusCode != null && statusCode == 401) {
      Auth.signOut();
    }
  }

  /// Returns [AlertDialog] to remove the credentials and pop to login screen
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
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Logout'),
        ),
      ],
    );
  }
}
