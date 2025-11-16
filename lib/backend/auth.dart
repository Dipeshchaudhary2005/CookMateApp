import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cookmate/core/static.dart';
import 'package:flutter/foundation.dart';

class Auth {
  static Future<bool> createUserWithEmail(String email, String password, String fullName, String userType) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
      );
      User user = credential.user!;
      final userMap = <String, dynamic> {
        'uid' : user.uid,
        'email': user.email,
        'fullName': fullName,
        'userType': userType,
        'createdAt' : FieldValue.serverTimestamp()
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