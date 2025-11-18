import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cookmate/core/static.dart';
import 'package:flutter/foundation.dart';

import 'model/user.dart';

class Auth {
  static Future<bool> createUserWithEmail(String email, String password, String fullName, String userType) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
      );
      User user = credential.user!;
      await user.updateDisplayName(fullName);
      final userMap = <String, dynamic> {
        UserModel.uidField : user.uid,
        UserModel.emailField : user.email,
        UserModel.fullNameField : fullName,
        UserModel.userTypeField : userType,
        UserModel.createdAtField : FieldValue.serverTimestamp()
      };
      DocumentReference docref = FirebaseFirestore.instance.collection(StaticClass.usersCollection).doc(user.uid);
      await docref.set(userMap, SetOptions(merge: true));

      return true;
    } on Exception catch (e) {
      if (kDebugMode){
        print(e.toString());
      }
      return false;
    }
  }

  /// Use [FirebaseAuth.instance] to check auth status
  static Future<void> loginUserWithEmail(String email, String password) async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}