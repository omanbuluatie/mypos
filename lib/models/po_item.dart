class POItem {
  int? id;
  int poId;
  int productId;
  int qty;
  double costPrice;

  POItem({
    this.id,
    required this.poId,
    required this.productId,
    required this.qty,
    required this.costPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'po_id': poId,
      'product_id': productId,
      'qty': qty,
      'cost_price': costPrice,
    };
  }

  factory POItem.fromMap(Map<String, dynamic> map) {
    return POItem(
      id: map['id'],
      poId: map['po_id'],
      productId: map['product_id'],
      qty: map['qty'],
      costPrice: map['cost_price'],
    );
  }

  POItem copyWith({
    int? id,
    int? poId,
    int? productId,
    int? qty,
    double? costPrice,
  }) {
    return POItem(
      id: id ?? this.id,
      poId: poId ?? this.poId,
      productId: productId ?? this.productId,
      qty: qty ?? this.qty,
      costPrice: costPrice ?? this.costPrice,
    );
  }
}
