class SaleItem {
  int? id;
  int saleId;
  int productId;
  int qty;
  double price;
  double discount;

  SaleItem({
    this.id,
    required this.saleId,
    required this.productId,
    required this.qty,
    required this.price,
    required this.discount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sale_id': saleId,
      'product_id': productId,
      'qty': qty,
      'price': price,
      'discount': discount,
    };
  }

  factory SaleItem.fromMap(Map<String, dynamic> map) {
    return SaleItem(
      id: map['id'],
      saleId: map['sale_id'],
      productId: map['product_id'],
      qty: map['qty'],
      price: map['price'],
      discount: map['discount'],
    );
  }

  SaleItem copyWith({
    int? id,
    int? saleId,
    int? productId,
    int? qty,
    double? price,
    double? discount,
  }) {
    return SaleItem(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      productId: productId ?? this.productId,
      qty: qty ?? this.qty,
      price: price ?? this.price,
      discount: discount ?? this.discount,
    );
  }
}
