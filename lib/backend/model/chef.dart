import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookmate/backend/model/user.dart';

class Chef extends UserModel {
  static const cuisinesField = 'cuisines';
  static const dishesField = 'dishes';

  List<String>? cuisines;
  List<String>? dishes;


  Chef({
    super.uid,
    super.email,
    super.fullName,
    super.createdAt,
    super.updatedAt,
    super.phoneNumber,
    super.signInMethod,
    super.userAddress,
    super.userType,
    super.geoPoint,
    this.cuisines,
    this.dishes,
  });

}
