import 'product.dart';

class CartItem {
  Product product;
  int qty;
  double price;
  double discount;

  CartItem({
    required this.product,
    this.qty = 1,
    required this.price,
    this.discount = 0.0,
  });

  double get subtotal => (price - discount) * qty;

  CartItem copyWith({
    Product? product,
    int? qty,
    double? price,
    double? discount,
  }) {
    return CartItem(
      product: product ?? this.product,
      qty: qty ?? this.qty,
      price: price ?? this.price,
      discount: discount ?? this.discount,
    );
  }
}
