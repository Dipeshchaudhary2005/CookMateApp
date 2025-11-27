import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

enum UserType{
  customer,
  chef,
  admin;

  factory UserType.fromString(String userType){
    for(UserType type in UserType.values){
      if (type.name == userType){
        return type;
      }
    }
    throw Exception("Input string: $userType; doesn't match a enum type");
  }
}

class UserModel {
  static const uidField = '_id';
  static const emailField = 'email';
  static const fullNameField = 'fullName';
  static const phoneNumberField = 'phoneNumber';
  static const userTypeField = 'role';
  static const createdAtField = 'createdAt';
  static const updatedAtField = 'updatedAt';
  static const signInMethodField = 'signInMethod';
  static const userAddressField = 'userAddress';
  static const geoPointField = 'geoPoint';
  static const urlToImageField = 'urlToImage';

  static const customerField = 'customer';
  static const chefField = 'chef';

  String? uid;
  String? email;
  String? fullName;
  String? phoneNumber;
  List<UserType>? userType;
  String? createdAt;
  String? updatedAt;
  String? signInMethod;
  String? userAddress;
  GeoPoint? geoPoint;
  String? urlToImage;

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
    this.geoPoint,
    this.urlToImage,
  });

  factory UserModel.fromJSON(dynamic data) {
    return UserModel(
      uid: data[uidField],
      email: data[emailField],
      fullName: data[fullNameField],
      userType: (data[userTypeField] as List).map((type) => UserType.fromString(type)).toList(),
      phoneNumber: data[phoneNumberField],
      signInMethod: data[signInMethodField],
      createdAt: data[createdAtField],
      updatedAt: data[updatedAtField],
      geoPoint: data[geoPointField] != null
          ? (data[geoPointField] as Map<String, dynamic>)['geopoint']
                as GeoPoint
          : null,
      userAddress: data[userAddressField],
      urlToImage: data[urlToImageField],
    );
  }
}
