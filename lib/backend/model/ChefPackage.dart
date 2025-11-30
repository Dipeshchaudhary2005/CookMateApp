class ChefPackage {
  String? id;
  String? chefId;
  String? name;
  num? price;
  bool? isActive;
  String? description;
  List<String>? dishes;

  ChefPackage({
    this.chefId,
    this.name,
    this.price,
    this.isActive,
    this.description,
    this.dishes,
    this.id,
  });

  factory ChefPackage.fromJSON(dynamic data) {
    return ChefPackage(
      id: data['_id'],
      chefId: data['chef'],
      name: data['name'],
      price: data['price'],
      isActive: data['isActive'],
      description: data['description'],
      dishes: data['dishes'] != null
          ? (data['dishes'] as List).map((e) => e.toString()).toList()
          : null,
    );
  }
}
