import 'dart:convert';

import 'package:cookmate/backend/model/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("User Model",() {
    // Initializing sample user to test
      String? uid = "132342";
      String? email = "taker@hell.com";
      String? fullName = "Hell Taker";
      String? phoneNumber = "0987654321";
      List<UserType>? userType = [UserType.customer];
      String? createdAt = DateTime.now().toString();
      String? updatedAt = DateTime.now().toString();
      String? signInMethod = "email";
      String? userAddress = "Lalitpur";
      List<double>? location = [-74.0060, 40.7128];
      String? urlToImage = "https://example.uk/images/profile.webp";

      String? speciality = "Nepali cuisine";
      String? experience = "5 years";
      List<String>? cuisines = ["Nepali cuisine", "Eastern cuisine"];
      num? rating = 4.5;
      int? ratingCount = 2;

      final jsonData = jsonEncode({
        "_id": uid,
        "fullName": fullName,
        "email": email,
        "phoneNumber": phoneNumber,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "signInMethod": signInMethod,
        "userAddress": userAddress,
        "location": {
          "type": "Point",
          "coordinates": location
        },
        "urlToImage": urlToImage,
        "role": userType.map((e) => e.name).toList(),
        "chef" : {
          "speciality" : speciality,
          "experience" : experience,
          "rating" : rating,
          "ratingCount" : ratingCount,
          "cuisines" : cuisines
        }
      });

    test("Getting user model from json", () {

      final decodedData = jsonDecode(jsonData);
      UserModel user = UserModel.fromJSON(decodedData);

      expect(user.uid, uid);
      expect(user.fullName, fullName);
      expect(user.email, email);
      expect(user.phoneNumber, phoneNumber);
      expect(user.createdAt, createdAt);
      expect(user.updatedAt, updatedAt);
      expect(user.signInMethod, signInMethod);
      expect(user.userAddress, userAddress);
      expect(user.location, location);
      expect(user.urlToImage, urlToImage);
      expect(user.userType, userType);
      expect(user.speciality, speciality);
      expect(user.experience, experience);
      expect(user.ratingCount, ratingCount);
      expect(user.rating, rating);
      expect(user.cuisines, cuisines);
    });
  });

}