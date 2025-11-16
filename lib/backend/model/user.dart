import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? email;
  String? fullName;
  String? phoneNumber;
  FieldValue? createdAt;
  FieldValue? updatedAt;

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (uid != null) map['uid'] = uid;
    if (email != null) map['email'] = email;
    if (fullName != null) map['fullName'] = fullName;
    if (phoneNumber != null) map['phoneNumber'] = phoneNumber;
    if (createdAt != null) map['createdAt'] = createdAt;
    if (updatedAt != null) map['updatedAt'] = updatedAt;

    return map;
  }
}