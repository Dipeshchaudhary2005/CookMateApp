import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

class UserModel {
  static const uidField = 'uid';
  static const emailField = 'email';
  static const fullNameField = 'fullName';
  static const phoneNumberField = 'phoneNumber';
  static const userTypeField = 'userType';
  static const createdAtField = 'createdAt';
  static const updatedAtField = 'updatedAt';
  static const signInMethodField = 'signInMethod';
  static const userAddressField = 'userAddress';
  static const geoPointField = 'geo';

  static const customerField = 'customer';
  static const chefField = 'chef';

  String? uid;
  String? email;
  String? fullName;
  String? phoneNumber;
  Map<String, dynamic>? userType;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  String? signInMethod;
  String? userAddress;
  GeoPoint? geoPoint;

  UserModel({
    this.uid,
    this.email,
    this.fullName,
    this.phoneNumber,
    this.userType,
    this.updatedAt,
    this.createdAt,
    this.signInMethod,
    this.userAddress,
    this.geoPoint
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (uid != null) map[UserModel.uidField] = uid;
    if (email != null) map[UserModel.emailField] = email;
    if (fullName != null) map[UserModel.fullNameField] = fullName;
    if (phoneNumber != null) map[UserModel.phoneNumberField] = phoneNumber;
    if (userType != null) map[UserModel.userTypeField] = userType;
    if (createdAt != null) map[UserModel.createdAtField] = createdAt;
    if (updatedAt != null) map[UserModel.updatedAtField] = updatedAt;
    if (signInMethod != null) map[UserModel.signInMethodField] = signInMethod;
    if (userAddress != null) map[UserModel.userAddressField] = userAddress;
    if (geoPoint != null) map[UserModel.geoPointField] = GeoFirePoint(geoPoint!).data;
    return map;
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snap) {
    final data = snap.data()!;
    // if (kDebugMode){
    //   data.forEach((key, value){
    //     if (kDebugMode){
    //         print("$key : $value");
    //     }
    //   });
    // }
    return UserModel(
      uid: data[UserModel.uidField],
      email: data[UserModel.emailField],
      fullName: data[UserModel.fullNameField],
      phoneNumber: data[UserModel.phoneNumberField],
      userType: data[UserModel.userTypeField],
      createdAt: data[UserModel.createdAtField],
      updatedAt: data[UserModel.updatedAtField],
      signInMethod: data[UserModel.signInMethodField],
      userAddress: data[UserModel.userAddressField],
      geoPoint: (data[UserModel.geoPointField] as Map<String, dynamic>)['geopoint'] as GeoPoint,
    );
  }
}
