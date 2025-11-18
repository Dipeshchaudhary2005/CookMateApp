
// Create this file at: lib/core/static.dart

import 'package:cookmate/backend/model/user.dart';

class StaticClass {
  static const String usersCollection = 'users';
  static const String predefinedCollection = 'predefinedData';
  static const String chefsCollection = 'chefs';
  static const String customersCollection = 'customers';
  static const String bookingsCollection = 'bookings';
  static UserModel? currentUser;
}
class PredefinedCollection{
  static const String fieldType = 'fieldType';
  static const String listOfFields = 'list';
}
