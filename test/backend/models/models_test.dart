import 'dart:convert';

import 'package:cookmate/backend/model/chef.dart';
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
        "role": userType?.map((e) => e.name).toList()
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
    });
  });

  group("Chef Model", (){
    // Initializing sample user to test
    String uid = "132342";
    String email = "taker@hell.com";
    String fullName = "Hell Taker";
    String phoneNumber = "0987654321";
    List<UserType> userType = [UserType.customer];
    String createdAt = DateTime.now().toString();
    String updatedAt = DateTime.now().toString();
    String signInMethod = "email";
    String userAddress = "Lalitpur";
    List<double> location = [-74.0060, 40.7128];
    String urlToImage = "https://example.uk/images/profile.webp";
    String speciality = "Newari Cuisine";
    String experience = "5 years";

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
        "experience" : experience
      }
    });

    test("Testing creation from json", (){
      final decodedData = jsonDecode(jsonData);
      Chef chef = Chef.fromJSON(decodedData);

      expect(chef.uid, uid);
      expect(chef.fullName, fullName);
      expect(chef.email, email);
      expect(chef.phoneNumber, phoneNumber);
      expect(chef.createdAt, createdAt);
      expect(chef.updatedAt, updatedAt);
      expect(chef.signInMethod, signInMethod);
      expect(chef.userAddress, userAddress);
      expect(chef.location, location);
      expect(chef.urlToImage, urlToImage);
      expect(chef.userType, userType);
      expect(chef.speciality, speciality);
      expect(chef.experience, experience);
    });
  });
}