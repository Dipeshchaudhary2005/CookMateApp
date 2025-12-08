enum BookingStatus{
  pending, upcoming, cancelled, completed
}
class Booking {
  String? id;
  String? eventType;

  String? chefId;
  String? chefName;

  String? customerName;
  String? customerId;
  String? customerPhone;
  String? customerAddress;
  num? cost;
  DateTime? date;
  String? timeInterval;
  int? noOfPeople;
  List<dynamic>? packages;
  String? status;
  num? rating;

  Booking({this.id, this.eventType, this.cost, this.date, this.timeInterval,
    this.customerId, this.customerName, this.chefId, this.packages, this.noOfPeople, this.status,
    this.chefName, this.rating, this.customerPhone, this.customerAddress});

  factory Booking.fromJSON(dynamic  data) {
    return Booking(
      id: data['_id'],
      chefId: data['chef']['_id'],
      chefName: data['chef']['fullName'],

      customerId: data['customer']['_id'],
      customerName: data['customer']['fullName'],
      customerPhone: data['customer']['phoneNumber'],
      customerAddress: data['customer']['userAddress'],

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