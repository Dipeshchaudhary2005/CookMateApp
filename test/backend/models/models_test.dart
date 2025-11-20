
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookmate/backend/model/booking.dart';
import 'package:cookmate/backend/model/chef.dart';
import 'package:cookmate/backend/model/user.dart';
import 'package:cookmate/core/static.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

void main() {
  test("UserModel ", () async {
    String uid = "uid";
    String email = "email";
    String fullName = "name";
    String phoneNumber = "98768394";
    Map<String, dynamic> userType = {"customer": true, "chef": false};
    Timestamp createdAt = Timestamp.now();
    Timestamp updatedAt = Timestamp.now();
    String signInMethod = "email";
    String userAddress = "Hattiban";
    GeoPoint geoPoint = GeoPoint(34.6, 45.6);

    final userModel = UserModel(
      uid: uid,
      email: email,
      fullName: fullName,
      phoneNumber: phoneNumber,
      userType: userType,
      createdAt: createdAt,
      updatedAt: updatedAt,
      signInMethod: signInMethod,
      userAddress: userAddress,
      geoPoint: geoPoint
    );

    final map = userModel.toMap();
    expect(map[UserModel.uidField], uid);
    expect(map[UserModel.emailField], email);
    expect(map[UserModel.fullNameField], fullName);
    expect(map[UserModel.phoneNumberField], phoneNumber);
    expect(map[UserModel.userTypeField], userType);
    expect(map[UserModel.createdAtField], createdAt);
    expect(map[UserModel.updatedAtField], updatedAt);
    expect(map[UserModel.signInMethodField], signInMethod);
    expect(map[UserModel.userAddressField], userAddress);
    expect(map[UserModel.geoPointField], GeoFirePoint(geoPoint).data);

    final fakeFirestore = FakeFirebaseFirestore();
    final docRef = fakeFirestore
        .collection(StaticClass.usersCollection)
        .doc(uid);
    await docRef.set(map, SetOptions(merge: true));

    final snapshot = await docRef.get();
    final user = UserModel.fromSnapshot(snapshot);

    expect(user.uid, uid);
    expect(user.email, email);
    expect(user.fullName, fullName);
    expect(user.phoneNumber, phoneNumber);
    expect(user.userType, userType);
    expect(user.createdAt, createdAt);
    expect(user.updatedAt, updatedAt);
    expect(user.signInMethod, signInMethod);
    expect(user.userAddress, userAddress);
    expect(user.geoPoint, geoPoint);
  });

  test("Booking model", () async {
    final fakeFirestore = FakeFirebaseFirestore();
    String uid = "uid";
    String eventType = "Birthday";
    Timestamp selectedDate = Timestamp.now();
    Timestamp startTime = Timestamp.now();
    Timestamp endTime = Timestamp.now();
    List<String> dishes = ["Pulao", "Rajma"];
    DocumentReference customerRef = fakeFirestore
        .collection(StaticClass.usersCollection)
        .doc("customer");
    DocumentReference chefRef = fakeFirestore
        .collection(StaticClass.usersCollection)
        .doc("chef");
    String status = BookingStatus.ongoing.name;

    final bookingModel = Booking(
      eventType: eventType,
      selectedDate: selectedDate,
      startTime: startTime,
      endTime: endTime,
      dishes: dishes,
      customerRef: customerRef,
      chefRef: chefRef,
      status: status,
      uid: uid,
    );

    final map = bookingModel.toMap();
    expect(map[Booking.eventTypeField], eventType);
    expect(map[Booking.selectedDateField], selectedDate);
    expect(map[Booking.startTimeField], startTime);
    expect(map[Booking.endTimeField], endTime);
    expect(map[Booking.dishesField], dishes);
    expect(map[Booking.customerRefField], customerRef);
    expect(map[Booking.chefRefField], chefRef);
    expect(map[Booking.statusField], status);
    expect(map[Booking.uidField], uid);

    final docRef = await fakeFirestore
        .collection(StaticClass.bookingsCollection)
        .add(map);
    final snapshot = await docRef.get();
    final bookingFromSnapshot = Booking.fromSnapshot(snapshot);

    expect(bookingFromSnapshot.eventType, eventType);
    expect(bookingFromSnapshot.selectedDate, selectedDate);
    expect(bookingFromSnapshot.startTime, startTime);
    expect(bookingFromSnapshot.endTime, endTime);
    expect(bookingFromSnapshot.dishes, dishes);
    expect(bookingFromSnapshot.customerRef, customerRef);
    expect(bookingFromSnapshot.chefRef, chefRef);
    expect(bookingFromSnapshot.status, status);
    expect(bookingFromSnapshot.uid, uid);
  });

  test("Chef Model", () async {
    String uid = "uid";
    String email = "email";
    String fullName = "name";
    String phoneNumber = "98768394";
    Map<String, dynamic> userType = {"customer": true, "chef": false};
    Timestamp createdAt = Timestamp.now();
    Timestamp updatedAt = Timestamp.now();
    String signInMethod = "email";
    String userAddress = "Hattiban";
    GeoPoint geoPoint = GeoPoint(34.6, 45.6);
    List<String> cuisines = ["Nepalese", "Newari"];
    List<String> dishes = ["Pulao", "Roti Tarkari"];

    final chefModel = Chef(
      uid: uid,
      email: email,
      fullName: fullName,
      phoneNumber: phoneNumber,
      userType: userType,
      createdAt: createdAt,
      updatedAt: updatedAt,
      signInMethod: signInMethod,
      userAddress: userAddress,
      geoPoint: geoPoint,
      dishes: dishes,
      cuisines: cuisines,
    );

    final map = chefModel.toMap();
    expect(map[UserModel.uidField], uid);
    expect(map[UserModel.emailField], email);
    expect(map[UserModel.fullNameField], fullName);
    expect(map[UserModel.phoneNumberField], phoneNumber);
    expect(map[UserModel.userTypeField], userType);
    expect(map[UserModel.createdAtField], createdAt);
    expect(map[UserModel.updatedAtField], updatedAt);
    expect(map[UserModel.signInMethodField], signInMethod);
    expect(map[UserModel.userAddressField], userAddress);
    expect(map[UserModel.geoPointField], GeoFirePoint(geoPoint).data);
    expect(map[Chef.dishesField], dishes);
    expect(map[Chef.cuisinesField], cuisines);

    final fakeFirestore = FakeFirebaseFirestore();
    final docRef = await fakeFirestore
        .collection(StaticClass.bookingsCollection)
        .add(map);
    final snapshot = await docRef.get();
    final chef = Chef.fromSnapshot(snapshot);

    expect(chef.uid, uid);
    expect(chef.email, email);
    expect(chef.fullName, fullName);
    expect(chef.phoneNumber, phoneNumber);
    expect(chef.userType, userType);
    expect(chef.createdAt, createdAt);
    expect(chef.updatedAt, updatedAt);
    expect(chef.signInMethod, signInMethod);
    expect(chef.userAddress, userAddress);
    expect(chef.geoPoint, geoPoint);
    expect(chef.dishes, dishes);
    expect(chef.cuisines, cuisines);
  });
}
