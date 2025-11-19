import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookmate/core/static.dart';

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
}
