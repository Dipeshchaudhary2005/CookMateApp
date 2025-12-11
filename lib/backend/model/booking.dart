enum BookingStatus{
  pending, upcoming, cancelled, completed
}
class Booking {
  String? id;
  String? eventType;

  String? chefId;
  String? chefName;
  String? chefPhone;
  String? chefUrlToImage;
  String? chefSpeciality;
  String? chefExperience;

  String? customerName;
  String? customerId;
  String? customerPhone;
  String? customerAddress;

  bool? paymentStatus;
  num? cost;
  DateTime? date;
  String? timeInterval;
  int? noOfPeople;
  List<dynamic>? packages;
  String? status;
  num? rating;
  String? review;

  Booking({this.id, this.eventType, this.cost, this.date, this.timeInterval,
    this.customerId, this.customerName, this.chefId, this.packages, this.noOfPeople, this.status,
    this.chefName, this.rating, this.customerPhone, this.customerAddress, this.chefUrlToImage, this.chefPhone,
    this.chefExperience, this.chefSpeciality, this.review, this.paymentStatus});

  factory Booking.fromJSON(dynamic  data) {
    String? speciality;
    String? experience;
    if (data['chef']['chef'] != null){
      speciality = data['chef']['chef']['speciality'];
      experience = data['chef']['chef']['experience'];
    }
    return Booking(
      id: data['_id'],

      chefId: data['chef']['_id'],
      chefName: data['chef']['fullName'],
      chefUrlToImage: data['chef']['urlToImage'],
      chefPhone: data['chef']['phoneNumber'],
      chefExperience: experience,
      chefSpeciality: speciality,

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
      rating: data['rating'],
      review: data['review'],

      paymentStatus: data['paymentDone']
    );
  }
}