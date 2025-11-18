import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum UserType{
  customer('Customer'),
  chef('Chef');

  final String name;
  const UserType(this.name);

  static UserType fromString(String type){
    return UserType.values.firstWhere((e) => e.name == type);
  }
}

class UserModel {
  static const uidField = 'uid';
  static const emailField = 'email';
  static const fullNameField = 'fullName';
  static const phoneNumberField = 'phoneNumber';
  static const userTypeField = 'userType';
  static const createdAtField = 'createdAt';
  static const updatedAtField = 'updatedAt';

  String? uid;
  String? email;
  String? fullName;
  String? phoneNumber;
  UserType? userType;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  UserModel({this.uid, this.email, this.fullName, this.phoneNumber, this.userType, this.updatedAt, this.createdAt});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (uid != null) map[UserModel.uidField] = uid;
    if (email != null) map[UserModel.emailField] = email;
    if (fullName != null) map[UserModel.fullNameField] = fullName;
    if (phoneNumber != null) map[UserModel.phoneNumberField] = phoneNumber;
    if (userType != null) map[UserModel.userTypeField] = userType;
    if (createdAt != null) map[UserModel.createdAtField] = createdAt;
    if (updatedAt != null) map[UserModel.updatedAtField] = updatedAt;

    return map;
  }


  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snap){
    final data = snap.data()!;
    if (kDebugMode){
      data.forEach((key, value){
          print("$key : $value");
      });
    }

    return UserModel(
      uid: data[UserModel.userTypeField],
      email: data[UserModel.emailField],
      fullName: data[UserModel.fullNameField],
      phoneNumber: data[UserModel.phoneNumberField],
      userType: UserType.fromString(data[UserModel.userTypeField]),
      createdAt: data[UserModel.createdAtField],
      updatedAt: data[UserModel.updatedAtField]
    );
  }
}

