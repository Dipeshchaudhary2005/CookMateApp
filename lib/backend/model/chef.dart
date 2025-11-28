import 'package:cookmate/backend/model/user.dart';

class Chef extends UserModel {
  static const specialityField = 'speciality';
  static const experienceField = 'experience';

  String? speciality;
  String? experience;

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
    super.location,
    super.urlToImage,
    this.speciality,
    this.experience
  });

  factory Chef.fromJSON(dynamic data){
    final chefFields = data['chef'] != null ? data['chef'] as Map : {specialityField : null, experienceField: null};

    final location = data[UserModel.locationField] != null ? data[UserModel.locationField] as Map : null;
    final coordinates = location?[UserModel.coordinatesField] != null ? (location![UserModel.coordinatesField] as List).map((e) => e as double).toList() : null;

    return Chef(
      uid: data[UserModel.uidField],
      email: data[UserModel.emailField],
      fullName: data[UserModel.fullNameField],
      phoneNumber: data[UserModel.phoneNumberField],

      userType: data[UserModel.userTypeField] != null
          ? (data[UserModel.userTypeField] as List).map((type) => UserType.fromString(type)).toList()
          : null,
      signInMethod: data[UserModel.signInMethodField],
      createdAt: data[UserModel.createdAtField],
      updatedAt: data[UserModel.updatedAtField],

      location: coordinates,
      userAddress: data[UserModel.userAddressField],

      urlToImage: data[UserModel.urlToImageField],

      speciality: chefFields[specialityField],
      experience: chefFields[experienceField]
    );
  }
}
