import 'package:cookmate/backend/model/user.dart';

class StaticClass {
  static const String usersCollection = 'users';
  static const String predefinedCollection = 'predefinedData';
  static UserModel? currentUser;
}
class PredefinedCollection{
  static const String fieldType = 'fieldType';
  static const String listOfFields = 'list';
}
