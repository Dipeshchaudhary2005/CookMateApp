import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookmate/backend/fetch_from_database.dart';
import 'package:cookmate/backend/model/chef.dart';
import 'package:cookmate/backend/model/user.dart';
import 'package:cookmate/core/static.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  test("Testing get names of nearby chefs", () async{
    final chefRam = Chef(
      uid: '1',
      fullName: 'Ram',
      geoPoint: GeoPoint(0, 0),
      userType: {UserModel.chefField : true}
    );
    final chefShyam = Chef(
      uid: '2',
      fullName: 'Shyam',
      geoPoint: GeoPoint(10, 10),
      userType: {UserModel.chefField : true}
    );

    final user = UserModel(
      uid: '3',
      fullName: 'User',
      geoPoint: GeoPoint(10, 10.1),
      userType: {UserModel.customerField : true}
    );

    final fakeFirestore = FakeFirebaseFirestore();

    await fakeFirestore.collection(StaticClass.usersCollection).add(chefRam.toMap());
    await fakeFirestore.collection(StaticClass.usersCollection).add(chefShyam.toMap());
    await fakeFirestore.collection(StaticClass.usersCollection).add(user.toMap());

    final stream = FetchFromDatabase.getNameOfChef(userLocation: user.geoPoint, firestoreInstance: fakeFirestore);
    stream.listen((list){
      expect(list.contains(chefShyam.fullName), true);
    });
  });
}