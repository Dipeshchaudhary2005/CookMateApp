import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookmate/backend/model/user.dart';
import 'package:cookmate/core/static.dart';
import 'package:cookmate/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AutoLoginHelper {
  static Future<void> loadDashBoard(BuildContext context) async {
    if (FirebaseAuth.instance.currentUser == null ) return;
    User user = FirebaseAuth.instance.currentUser!;
    final userDoc = await FirebaseFirestore.instance.collection(StaticClass.usersCollection).doc(user.uid).get();
    StaticClass.currentUser = UserModel.fromSnapshot(userDoc);
    if (StaticClass.currentUser == null) return;
    switch(StaticClass.currentUser!.userType){
      case UserType.customer:
        if (context.mounted){
          Navigator.pushNamed(context, AppRoutes.customerDashboardRoute);
        }
        break;
      case UserType.chef:
        if (context.mounted){
          Navigator.pushNamed(context, AppRoutes.chefDashboardRoute);
        }
        break;
      default:
        break;

    }
  }
}