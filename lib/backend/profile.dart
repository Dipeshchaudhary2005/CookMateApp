import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookmate/core/static.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cookmate/backend/model/user.dart';
class UpdateHelper {
  static Future<bool> updateProfile({String? fullName, String? phoneNumber, String? email, String? userAddress}) async {
    try{
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;
      DocumentReference docRef = FirebaseFirestore.instance.collection(StaticClass.usersCollection).doc(user.uid);
      UserModel userModel = UserModel();
      userModel.fullName = fullName;
      userModel.phoneNumber = phoneNumber;
      userModel.email = email;
      userModel.userAddress = userAddress;
      var map = userModel.toMap();
      map[UserModel.updatedAtField] = FieldValue.serverTimestamp();
      // userModel.updatedAt = FieldValue.serverTimestamp();
      await docRef.set(userModel.toMap(), SetOptions(merge: true));
      user.updateDisplayName(fullName);
      if (email != null){
        user.verifyBeforeUpdateEmail(email);
      }
      return true;
    } on Exception catch (e){
      if (kDebugMode){
        print(e.toString());
      }
      return false;
    }
  }
}