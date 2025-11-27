import 'package:cookmate/backend/model/user.dart';
import 'package:flutter/material.dart';

class StaticClass {
  static const String usersCollection = 'users';
  static const String predefinedCollection = 'predefinedData';
  static const String chefsCollection = 'chefs';
  static const String customersCollection = 'customers';
  static const String bookingsCollection = 'bookings';
  static const String cuisinesCollection = 'cuisines';
  static UserModel? currentUser;
  static String? jsonWebToken;

  static const String jsonWebTokenField = 'jwt';
  static const String serverBaseURL = 'cookmate-nodejs.onrender.com';
  static const String serverApiURL = '/api/v1';
  static Image noImage = Image.asset('Resource/no_image.jpeg');
}
