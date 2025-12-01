class Booking {
  String? eventType;
  String? chefId;
  String? customerId;
  num? cost;
  DateTime? date;
  String? timeInterval;
  int? noOfPeople;
  List<dynamic>? packages;
  Booking({this. eventType, this.cost, this.date, this.timeInterval, this.customerId, this.chefId, this.packages, this.noOfPeople});
}