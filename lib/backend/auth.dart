import 'package:cookmate/core/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cookmate/core/static.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'model/user.dart';

class Auth {
  static final GoogleSignIn googleSignIn = GoogleSignIn.instance;

  // Email/Password Registration with Phone Number
  static Future<bool> createUserWithEmail(
    String email,
    String password,
    String fullName,
    String userType, {
    String? phoneNumber,
    required BuildContext context,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = credential.user!;
      await user.updateDisplayName(fullName);
      final userMap = <String, dynamic>{
        UserModel.uidField: user.uid,
        UserModel.emailField: user.email,
        UserModel.fullNameField: fullName,
        UserModel.userTypeField: {userType: true},
        UserModel.phoneNumberField: phoneNumber ?? '',
        UserModel.signInMethodField: 'email',
        UserModel.createdAtField: FieldValue.serverTimestamp(),
      };

      DocumentReference docref = FirebaseFirestore.instance
          .collection(StaticClass.usersCollection)
          .doc(user.uid);
      await docref.set(userMap, SetOptions(merge: true));

      return true;
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return true;
      switch (e.code) {
        case 'email-already-in-use':
          var userCred = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          bool checked = await checkUserType(userCred, userType, true);
          if (checked) {
            return true;
          } else {
            if (context.mounted) {
              Helper.showError(context, "A user already exists with the email");
            }
          }
          break;
        case 'weak-password':
          Helper.showError(context, "Weak password. Try a more complex one.");
          break;
        case 'too-many-requests':
          Helper.showError(context, "Too many requests. Try later.");
          break;
        case 'network-request-failed':
          Helper.showError(
            context,
            "Network error. Check your connection or try again later",
          );
          break;
        default:
          Helper.showError(context, "Internal Error.");
          break;
      }
      return false;
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
    String userType,
  ) async {
    try {
      await FirebaseAuth.instance.signOut();
      final userCred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      bool check = await checkUserType(userCred, userType, false);
      if (check) {
        return true;
      } else {
        await FirebaseAuth.instance.signOut();
        if (context.mounted) {
          Helper.showError(
            context,
            "This email is not registred for $userType role",
          );
        }
      }
      return true;
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return false;
      switch (e.code) {
        case 'user-disabled':
          Helper.showError(context, "This email has been disabled");
          break;
        case 'user-not-found':
          Helper.showError(context, "No user associated with this email");
          break;
        case 'wrong-password':
        case 'INVALID_LOGIN_CREDENTIALS':
        case 'invalid-credential':
          Helper.showError(context, "Invalid email or password");
        case 'too-many-requests':
          Helper.showError(context, "Too many requests. Try later.");
          break;
        case 'network-request-failed':
          Helper.showError(
            context,
            "Network error. Check your connection or try again later",
          );
          break;
        default:
          Helper.showError(context, "Internal Error");
          break;
      }
      return false;
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

  static Future<User?> signInWithGoogle(
    String userType,
    BuildContext context,
  ) async {
    try {
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      var userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      // if (kDebugMode){
      //   print(userCredential.user.toString());
      //   print(FirebaseAuth.instance.currentUser.toString());
      // }
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        var userModel = UserModel(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email,
          fullName: userCredential.user!.displayName,
          userType: {userType: true},
          phoneNumber: userCredential.user!.phoneNumber,
          signInMethod: 'google',
        );

        var map = userModel.toMap();
        map[UserModel.createdAtField] = FieldValue.serverTimestamp();

        DocumentReference docref = FirebaseFirestore.instance
            .collection(StaticClass.usersCollection)
            .doc(userCredential.user!.uid);
        await docref.set(map, SetOptions(merge: true));
      } else {
        await checkUserType(userCredential, userType, true);
      }

      return userCredential.user;
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
      await googleSignIn.signOut();
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
          .update({UserModel.phoneNumberField: phoneNumber});
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating phone number: $e');
      }
      return false;
    }
  }
}
