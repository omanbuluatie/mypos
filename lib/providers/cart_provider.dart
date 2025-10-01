import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartState {
  final List<CartItem> items;

  CartState({required this.items});

  double get total => items.fold(0.0, (sum, item) => sum + item.subtotal);

  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState(items: []));

  void addItem(Product product, double price, {int qty = 1, double discount = 0.0}) {
    final existingIndex = state.items.indexWhere((item) => item.product.id == product.id);
    if (existingIndex != -1) {
      final existing = state.items[existingIndex];
      final updated = CartItem(
        product: product,
        qty: existing.qty + qty,
        price: price,
        discount: discount,
      );
      final newItems = List<CartItem>.from(state.items);
      newItems[existingIndex] = updated;
      state = state.copyWith(items: newItems);
    } else {
      final newItem = CartItem(
        product: product,
        qty: qty,
        price: price,
        discount: discount,
      );
      state = state.copyWith(items: [...state.items, newItem]);
    }
  }

  void removeItem(int productId) {
    final newItems = state.items.where((item) => item.product.id != productId).toList();
    state = state.copyWith(items: newItems);
  }

  void updateQty(int productId, int qty) {
    if (qty <= 0) {
      removeItem(productId);
      return;
    }
    final newItems = state.items.map((item) {
      if (item.product.id == productId) {
        return CartItem(
          product: item.product,
          qty: qty,
          price: item.price,
          discount: item.discount,
        );
      }
      return item;
    }).toList();
    state = state.copyWith(items: newItems);
  }

  void clearCart() {
    state = state.copyWith(items: []);
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) => CartNotifier());
