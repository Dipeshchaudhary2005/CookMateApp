import 'dart:convert';

import 'package:cookmate/core/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:cookmate/core/static.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decode/jwt_decode.dart';

import 'model/user.dart';

class Auth {
  static final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  static final secureStorage = FlutterSecureStorage();
  static final String serverPath = '/auth';
  // Email/Password Registration with Phone Number
  static Future<bool> createUserWithEmail(
    String email,
    String password,
    String fullName,
    UserType userType, {
    required String phoneNumber,
    required BuildContext context,
  }) async {
    try {
      final url = Uri.https(
        StaticClass.serverBaseURL,
        '${StaticClass.serverApiURL}$serverPath/register',
      );
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'fullName': fullName,
          'password': password,
          'phoneNumber': phoneNumber,
          'signInMethod': 'email',
          'role': [userType.name],
        }),
      );
      if (response.statusCode.toString().contains('20')) {
        return true;
      } else {
        final data = jsonDecode(response.body);
        if (context.mounted) {
          Helper.showError(context, data['error']);
        }
        return false;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      if (context.mounted) {
        Helper.showError(context, "Internal Error");
      }
      return false;
    }
  }

  static Future<bool> checkUserType(
    UserCredential userCred,
    String userType,
    bool addUserTypeIfNotPresent,
  ) async {
    final docRef = FirebaseFirestore.instance
        .collection(StaticClass.usersCollection)
        .doc(userCred.user!.uid);
    final doc = await docRef.get();
    if (doc.data()![UserModel.userTypeField][userType] == true) {
      return true;
    } else {
      if (addUserTypeIfNotPresent) {
        await addUserType(userType, docRef);
        return true;
      }
      return false;
    }
  }

  static Future<void> addUserType(
    String userType,
    DocumentReference docRef,
  ) async {
    Map<String, dynamic> map = {
      UserModel.userTypeField: {userType: true},
    };
    await docRef.set(map, SetOptions(merge: true));
  }

  // Email/Password Login
  static Future<bool> loginUserWithEmail(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      final url = Uri.https(
        StaticClass.serverBaseURL,
        '${StaticClass.serverApiURL}$serverPath/login',
      );
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode.toString().contains('20')) {
        final data = jsonDecode(response.body);
        StaticClass.jsonWebToken = data['token'];
        StaticClass.currentUser = UserModel.fromJSON(data['user']);
        if (StaticClass.jsonWebToken != null) {
          await secureStorage.write(
            key: StaticClass.jsonWebTokenField,
            value: StaticClass.jsonWebToken!,
          );
        }
        return true;
      } else {
        final data = jsonDecode(response.body);
        if (context.mounted) {
          Helper.showError(context, data['error']);
        }
        return false;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      if (context.mounted) {
        Helper.showError(context, "Internal Error");
      }
      return false;
    }
  }

  static Future<String?> verifyToken(BuildContext context, String token) async {
    try {
      final url = Uri.https(
        StaticClass.serverBaseURL,
        '${StaticClass.serverApiURL}$serverPath/verifyToken',
      );
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
          'Authorization': token,
        },
      );
      if (response.statusCode.toString().contains('20')) {
        final data = jsonDecode(response.body);
        return data['userId'];
      } else {
        final data = jsonDecode(response.body);
        if (context.mounted) {
          Helper.showError(context, data['error']);
        }
        return null;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error verifying jwt: $e');
      }
      if (context.mounted) {
        Helper.showError(context, 'Error verifying jwt');
      }
      return null;
    }
  }

  static Future<UserModel?> getUserData(
    BuildContext context,
    String token,
    String userId,
  ) async {
    final url = Uri.https(
      StaticClass.serverBaseURL,
      '${StaticClass.serverApiURL}$serverPath/users/$userId',
    );
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Accept': 'application/json',
        'Authorization': token,
      },
    );
    if (response.statusCode.toString().contains('20')) {
      final data = jsonDecode(response.body);
      final user = UserModel.fromJSON(data['user']);
      return user;
    } else {
      final data = jsonDecode(response.body);
      if (context.mounted) {
        Helper.showError(context, data['error']);
      }
      return null;
    }
  }

  static Future<User?> signInWithGoogle(
    UserType userType,
    BuildContext context,
  ) async {
    try {
      // TODO
      return null;
      // final GoogleSignInAccount googleUser = await googleSignIn.authenticate();
      //
      // // Obtain the auth details from the request
      // final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      //
      // // Create a new credential
      // final credential = GoogleAuthProvider.credential(
      //   idToken: googleAuth.idToken,
      // );
      //
      // // Once signed in, return the UserCredential
      // var userCredential = await FirebaseAuth.instance.signInWithCredential(
      //   credential,
      // );
      // // if (kDebugMode){
      // //   print(userCredential.user.toString());
      // //   print(FirebaseAuth.instance.currentUser.toString());
      // // }
      // if (userCredential.additionalUserInfo?.isNewUser ?? false) {
      //   var userModel = UserModel(
      //     uid: userCredential.user!.uid,
      //     email: userCredential.user!.email,
      //     fullName: userCredential.user!.displayName,
      //     userType: [userType],
      //     phoneNumber: userCredential.user!.phoneNumber,
      //     signInMethod: 'google',
      //     geoPoint: GeoPoint(0, 0.5),
      //   );
      //
      //   var map = userModel.toMap();
      //   map[UserModel.createdAtField] = FieldValue.serverTimestamp();
      //
      //   DocumentReference docref = FirebaseFirestore.instance
      //       .collection(StaticClass.usersCollection)
      //       .doc(userCredential.user!.uid);
      //   await docref.set(map, SetOptions(merge: true));
      // } else {
      //   await checkUserType(userCredential, userType, true);
      // }
      //
      // return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        switch (e.code) {
          case 'account-exists-with-different-credential':
            Helper.showError(
              context,
              "Account is already registered with email and password. Try linking",
            );
            break;
          case 'invalid-credential':
            Helper.showError(context, "Invalid credentials");
            break;
          case 'user-disabled':
            Helper.showError(
              context,
              "The user for this account have been disabled. Contact admin",
            );
            break;
          default:
            Helper.showError(context, "Internal error");
            break;
        }
      }
      await googleSignIn.signOut();
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Google Sign-In error: $e');
      }
      return null;
    }
  }

  static Future<void> signOut() async {
    try {
      await googleSignIn.signOut();
      StaticClass.currentUser = null;
      StaticClass.jsonWebToken = null;
      await secureStorage.delete(key: StaticClass.jsonWebTokenField);
    } catch (e) {
      if (kDebugMode) {
        print('Sign out error: $e');
      }
    }
  }

  static bool jwtIsExpired(String token) {
    bool isExpired = Jwt.isExpired(token);
    if (isExpired) {
      signOut();
      return true;
    } else {
      return false;
    }
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
}
