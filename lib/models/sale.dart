class Sale {
  int? id;
  DateTime date;
  int? customerId;
  double total;
  String paymentMethod;
  String status;
  String? invoiceNumber;

  Sale({
    this.id,
    required this.date,
    this.customerId,
    required this.total,
    required this.paymentMethod,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'customer_id': customerId,
      'total': total,
      'payment_method': paymentMethod,
      'status': status,
      'invoice_number': invoiceNumber,
    };
  }

  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map['id'],
      date: DateTime.parse(map['date']),
      customerId: map['customer_id'],
      total: map['total'],
      paymentMethod: map['payment_method'],
      status: map['status'],
    );
  }

  Sale copyWith({
    int? id,
    DateTime? date,
    int? customerId,
    double? total,
    String? paymentMethod,
    String? status,
    String? invoiceNumber,
  }) {
    return Sale(
      id: id ?? this.id,
      date: date ?? this.date,
      customerId: customerId ?? this.customerId,
      total: total ?? this.total,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
    );
  }
}
