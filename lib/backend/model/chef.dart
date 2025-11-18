import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookmate/backend/model/user.dart';

class Chef extends UserModel {
  static const cuisinesField = 'cuisines';
  static const workingLocationField = 'workingLocation';

  List<String>? cuisines;
  String? workingLocation;

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map[Chef.cuisinesField] = cuisines;
    map[Chef.workingLocationField] = workingLocation;
    return map;
  }

  factory Chef.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snap){
    Chef model = UserModel.fromSnapshot(snap) as Chef;
    final data = snap.data();

    if (data![cuisinesField] != null) model.cuisines = data[cuisinesField];
    if (data[workingLocationField] != null) model.workingLocation = data[workingLocationField];

    return model;
  }
}