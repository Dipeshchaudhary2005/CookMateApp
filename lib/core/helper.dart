import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookmate/backend/auth.dart';
import 'package:cookmate/backend/model/user.dart';
import 'package:cookmate/core/static.dart';
import 'package:cookmate/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Helper {
  static Future<bool> loadDashBoard(BuildContext context, {String? userType}) async {
      if (FirebaseAuth.instance.currentUser == null ) {
        return false;
      }
      User user = FirebaseAuth.instance.currentUser!;
      final userDoc = await FirebaseFirestore.instance.collection(StaticClass.usersCollection).doc(user.uid).get();
      StaticClass.currentUser = UserModel.fromSnapshot(userDoc);
      if (StaticClass.currentUser == null) return false;
      if (StaticClass.currentUser!.userType![UserModel.chefField ] == true && (userType == null || userType == UserModel.chefField) ) {
        if (context.mounted) {
          Navigator.pushNamed(context, AppRoutes.chefDashboardRoute);
        }
      }
      else if (StaticClass.currentUser!.userType![UserModel.customerField] == true && (userType == null || userType == UserModel.customerField)) {
        if (context.mounted) {
          Navigator.pushNamed(context, AppRoutes.customerDashboardRoute);
        }
      }
      return true;

  }

  static showError(BuildContext context, String message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

   static AlertDialog confirmLogOut (context){
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
            Auth.googleSignIn.signOut();
            FirebaseAuth.instance.signOut();
            Navigator.pushNamedAndRemoveUntil(context, AppRoutes.landingPageRoute, (route) => false);
            // Navigator.pushAndRemoveUntil(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const LandingPage(),
            //   ),
            //       (route) => false,
            // );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: const Text('Logout'),
        ),
      ],
    );
  }
}