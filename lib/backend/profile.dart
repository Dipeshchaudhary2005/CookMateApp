import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookmate/core/static.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cookmate/backend/model/user.dart';
class Profile {
  Future<bool> updateProfile({String? fullName, String? phoneNumber}) async {
    try{
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;
      DocumentReference docRef = FirebaseFirestore.instance.collection(StaticClass.usersCollection).doc(user.uid);
      UserModel userModel = UserModel();
      userModel.fullName = fullName;
      userModel.phoneNumber = phoneNumber;
      userModel.updatedAt = FieldValue.serverTimestamp();
      await docRef.set(userModel.toMap(), SetOptions(merge: true));
      return true;
    } on Exception catch (e){
      if (kDebugMode){
        print(e.toString());
      }
      return false;
    }
  }
}