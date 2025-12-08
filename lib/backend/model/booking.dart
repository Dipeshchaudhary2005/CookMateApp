enum BookingStatus{
  pending, upcoming, cancelled, ongoing, completed
}
class Booking {
  String? eventType;
  String? chefId;
  String? chefName;
  String? id;
  String? customerId;
  num? cost;
  DateTime? date;
  String? timeInterval;
  int? noOfPeople;
  List<dynamic>? packages;
  String? status;
  num? rating;

  Booking({this.id, this.eventType, this.cost, this.date, this.timeInterval, this.customerId, this.chefId, this.packages, this.noOfPeople, this.status, this.chefName, this.rating});

  factory Booking.fromJSON(dynamic  data) {

    return Booking(
      id: data['_id'],
      chefId: data['chef']['_id'],
      chefName: data['chef']['fullName'],
      customerId: data['customer'],
      eventType: data['eventType'],
      noOfPeople: data['noOfPeople'],
      date: DateTime.tryParse(data['date']),
      timeInterval: data['timeInterval'],
      cost: data['cost'],
      packages: data['packages'],
      status: data['status'],
      rating: data['rating']
    );
  }
}