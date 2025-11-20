import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookmate/backend/model/chef.dart';
import 'package:cookmate/backend/model/user.dart';
import 'package:cookmate/core/static.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

class FetchFromDatabase {
  static Future<List<String>> getDataList(String collection) async {
    final snap = await FirebaseFirestore.instance
        .collection(StaticClass.predefinedCollection)
        .doc(collection)
        .collection(PredefinedCollection.listOfFields)
        .get();

    return snap.docs
        .map((doc) => doc.get(PredefinedCollection.nameField) as String?)
        .where((name) => name != null)
        .cast<String>()
        .toList();
  }
  
  static Future<List<String>> getListOfNames(String collection) async{
    final snap = await FirebaseFirestore.instance
        .collection(collection).get();

    return snap.docs
        .map((doc) => doc.get(PredefinedCollection.nameField) as String?)
        .where((name) => name != null)
        .cast<String>().toList();
  }
  
  static Stream<List<String>> getNameOfChef(String collection, {GeoPoint? userLocation}) {
    userLocation ??= GeoPoint(0, 0);
    final center = GeoFirePoint(userLocation);
    const radiusInKm = 50.0;

    final collectionRef = FirebaseFirestore.instance.collection(StaticClass.usersCollection);
    final stream = GeoCollectionReference<Map<String, dynamic>>(collectionRef)
                    .subscribeWithin(
        center: center,
        radiusInKm: radiusInKm,
        field: UserModel.geoPointField,
        geopointFrom: geoPointFrom);

    return stream.map((List<DocumentSnapshot<Map<String, dynamic>>> docs){
      return docs.map((doc) => Chef.fromSnapshot(doc).fullName!).toList();
    });
  }
  static GeoPoint geoPointFrom(Map<String, dynamic> data) {
    return (data[UserModel.geoPointField] as Map<String, dynamic>)['geopoint'] as GeoPoint;
  }
}
