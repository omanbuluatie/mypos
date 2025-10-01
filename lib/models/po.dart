class PO {
  int? id;
  int supplierId;
  DateTime date;
  String status;
  double total;

  PO({
    this.id,
    required this.supplierId,
    required this.date,
    required this.status,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'supplier_id': supplierId,
      'date': date.toIso8601String(),
      'status': status,
      'total': total,
    };
  }

  factory PO.fromMap(Map<String, dynamic> map) {
    return PO(
      id: map['id'],
      supplierId: map['supplier_id'],
      date: DateTime.parse(map['date']),
      status: map['status'],
      total: map['total'],
    );
  }

  PO copyWith({
    int? id,
    int? supplierId,
    DateTime? date,
    String? status,
    double? total,
  }) {
    return PO(
      id: id ?? this.id,
      supplierId: supplierId ?? this.supplierId,
      date: date ?? this.date,
      status: status ?? this.status,
      total: total ?? this.total,
    );
  }
}
