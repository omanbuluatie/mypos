class Discount {
  int? id;
  String name;
  String type; // 'PERCENTAGE' or 'FLAT'
  double value;
  List<int> productIds; // Not stored in the table, but used for business logic

  Discount({
    this.id,
    required this.name,
    required this.type,
    required this.value,
    this.productIds = const [],
  });

  // This map is for the 'discounts' table only.
  // Product relationships are managed in a separate table.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'value': value,
    };
  }

  factory Discount.fromMap(Map<String, dynamic> map) {
    return Discount(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      value: map['value'],
      // productIds will be populated separately by the provider/database helper.
    );
  }
}
