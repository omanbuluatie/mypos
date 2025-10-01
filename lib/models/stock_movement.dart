class StockMovement {
  int? id;
  int productId;
  int quantity;
  String type; // e.g., 'IN', 'OUT', 'ADJUSTMENT', 'INITIAL'
  String? reason;
  DateTime timestamp;

  StockMovement({
    this.id,
    required this.productId,
    required this.quantity,
    required this.type,
    this.reason,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'quantity': quantity,
      'type': type,
      'reason': reason,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory StockMovement.fromMap(Map<String, dynamic> map) {
    return StockMovement(
      id: map['id'],
      productId: map['product_id'],
      quantity: map['quantity'],
      type: map['type'],
      reason: map['reason'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
