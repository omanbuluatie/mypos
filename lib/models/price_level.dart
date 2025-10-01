class PriceLevel {
  int? id;
  String name;

  PriceLevel({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory PriceLevel.fromMap(Map<String, dynamic> map) {
    return PriceLevel(
      id: map['id'],
      name: map['name'],
    );
  }
}
