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
  static const locationField = 'location';
  static const coordinatesField = 'coordinates';

  static const urlToImageField = 'urlToImage';

  static const specialityField = 'speciality';
  static const experienceField = 'experience';
  static const ratingField = 'rating';
  static const ratingCountField = 'ratingCount';
  static const cuisinesField = 'cuisines';
  static const bioField = "bio";

  String? uid;
  String? email;
  String? fullName;
  String? phoneNumber;
  List<UserType>? userType;
  String? createdAt;
  String? updatedAt;
  String? signInMethod;
  String? userAddress;
  List<double>? location;
  String? urlToImage;
  String? bio;

  String? speciality;
  String? experience;
  List<String>? cuisines;
  num? rating;
  int? ratingCount;

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
    this.urlToImage,
    this.location,
    this.speciality,
    this.experience,
    this.rating,
    this.ratingCount,
    this.cuisines,
    this.bio
  });

  factory UserModel.fromJSON(dynamic data) {
    // Checking for cast null error
    final chefFields = data['chef'] != null ? data['chef'] as Map : {specialityField : null, experienceField: null, ratingField: null, ratingCountField: null, cuisinesField: null};
    final location = data[locationField] != null ? data[locationField] as Map : null;
    final coordinates = location?[coordinatesField] != null ? (location![coordinatesField] as List).map((e) => e as double).toList() : null;
    final cuisines = chefFields[cuisinesField] != null ? (chefFields[cuisinesField] as List).map((e) => e as String).toList() : null;
    return UserModel(
      uid: data[uidField],
      email: data[emailField],
      fullName: data[fullNameField],
      userType: data[userTypeField] != null
          ? (data[userTypeField] as List).map((type) => UserType.fromString(type)).toList()
          : null,
      phoneNumber: data[phoneNumberField],
      signInMethod: data[signInMethodField],
      createdAt: data[createdAtField],
      updatedAt: data[updatedAtField],
      location: coordinates,
      bio: data[bioField],
      userAddress: data[userAddressField],
      urlToImage: data[urlToImageField],
      speciality: chefFields[specialityField],
      experience: chefFields[experienceField],
      rating: chefFields[ratingField] as num,
      ratingCount: chefFields[ratingCountField] as int,
      cuisines: cuisines
    );
  }
}
