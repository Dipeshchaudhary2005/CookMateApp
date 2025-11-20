import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookmate/backend/model/user.dart';

class Chef extends UserModel {
  static const cuisinesField = 'cuisines';
  static const dishesField = 'dishes';

  List<String>? cuisines;
  List<String>? dishes;

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map[Chef.cuisinesField] = cuisines;
    map[Chef.dishesField] = dishes;
    return map;
  }

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

  factory Chef.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snap) {
    final data = snap.data()!;
    return Chef(
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
      cuisines: data[Chef.cuisinesField] != null ? List<String>.from(data[Chef.cuisinesField] as List) : null,
      dishes: data[Chef.dishesField] != null ? List<String>.from(data[Chef.dishesField] as List) : null,
    );
  }
}
