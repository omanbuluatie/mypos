class Supplier {
  int? id;
  String name;
  String? contact;
  String? address;

  Supplier({
    this.id,
    required this.name,
    this.contact,
    this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'address': address,
    };
  }

  factory Supplier.fromMap(Map<String, dynamic> map) {
    return Supplier(
      id: map['id'],
      name: map['name'],
      contact: map['contact'],
      address: map['address'],
    );
  }

  Supplier copyWith({
    int? id,
    String? name,
    String? contact,
    String? address,
  }) {
    return Supplier(
      id: id ?? this.id,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      address: address ?? this.address,
    );
  }
}
