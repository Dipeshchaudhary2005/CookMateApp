import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cookmate/core/static.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'model/user.dart';

class Auth {
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // Email/Password Registration with Phone Number
  static Future<bool> createUserWithEmail(
      String email,
      String password,
      String fullName,
      String userType, {
        String? phoneNumber,
      }) async {
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
        UserModel.phoneNumberField : phoneNumber ?? '',
        UserModel.signInMethodField : 'email',
        UserModel.createdAtField : FieldValue.serverTimestamp()
      };

      DocumentReference docref = FirebaseFirestore.instance
          .collection(StaticClass.usersCollection)
          .doc(user.uid);
      await docref.set(userMap, SetOptions(merge: true));

      return true;
    } on Exception catch (e) {
      if (kDebugMode){
        print(e.toString());
      }
      return false;
    }
  }

  // Email/Password Login
  static Future<void> loginUserWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }


  static Future<User?> signInWithGoogle(String userType) async {
    try{
      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance.authenticate();

      if (googleUser != null) return null;
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = googleUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);

      // Once signed in, return the UserCredential
      var userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.additionalUserInfo?.isNewUser ?? false){
        var userModel = UserModel(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email,
          fullName: userCredential.user!.displayName,
          userType: UserType.fromString(userType),
          phoneNumber: userCredential.user!.phoneNumber,
          signInMethod: 'google',
        );

        var map = userModel.toMap();
        map[UserModel.createdAtField] = FieldValue.serverTimestamp();

        DocumentReference docref = FirebaseFirestore.instance
            .collection(StaticClass.usersCollection)
            .doc(userCredential.user!.uid);
        await docref.set(map, SetOptions(merge: true));
      }

      return userCredential.user;
    }catch (e) {
      if (kDebugMode) {
        print('Google Sign-In error: $e');
      }
      return null;
    }
  }

  // // Google Sign-In
  // static Future<User?> signInWithGoogle(String userType) async {
  //   try {
  //     // Trigger the Google Sign-In flow
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.;
  //
  //     if (googleUser == null) {
  //       // User canceled the sign-in
  //       return null;
  //     }
  //
  //     // Obtain the auth details from the request
  //     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //
  //     // Create a new credential
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //
  //     // Sign in to Firebase with the Google credential
  //     UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  //
  //     // Check if this is a new user
  //     if (userCredential.additionalUserInfo?.isNewUser ?? false) {
  //       // Store user data in Firestore for new users
  //       final userMap = <String, dynamic>{
  //         'uid': userCredential.user!.uid,
  //         'email': userCredential.user?.email ?? '',
  //         'fullName': userCredential.user?.displayName ?? '',
  //         'userType': userType,
  //         'phoneNumber': userCredential.user?.phoneNumber ?? '',
  //         'photoURL': userCredential.user?.photoURL ?? '',
  //         'signInMethod': 'google',
  //         'createdAt': FieldValue.serverTimestamp(),
  //       };
  //
  //       DocumentReference docref = FirebaseFirestore.instance
  //           .collection(StaticClass.usersCollection)
  //           .doc(userCredential.user!.uid);
  //       await docref.set(userMap, SetOptions(merge: true));
  //     }
  //
  //     return userCredential.user;
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Google Sign-In error: $e');
  //     }
  //     return null;
  //   }
  // }

  // Sign Out
  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      if (kDebugMode) {
        print('Sign out error: $e');
      }
    }
  }

  // Get current user
  static User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  // Password Reset
  static Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Password reset error: ${e.message}');
      }
      return false;
    }
  }

  // Get user data from Firestore
  static Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection(StaticClass.usersCollection)
          .doc(uid)
          .get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user data: $e');
      }
      return null;
    }
  }

  // Update user phone number
  static Future<bool> updatePhoneNumber(String uid, String phoneNumber) async {
    try {
      await FirebaseFirestore.instance
          .collection(StaticClass.usersCollection)
          .doc(uid)
          .update({
        'phoneNumber': phoneNumber,
      });
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating phone number: $e');
      }
      return false;
    }
  }
}