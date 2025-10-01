import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_helper.dart';
import '../models/product.dart';
// Import price level provider

class ProductState {
  final List<Product> products;
  final String searchQuery;

  ProductState({required this.products, this.searchQuery = ''});

  ProductState copyWith({List<Product>? products, String? searchQuery}) {
    return ProductState(
      products: products ?? this.products,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  List<Product> get filteredProducts {
    if (searchQuery.isEmpty) return products;
    return products.where((p) =>
      p.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
      (p.barcode?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false)
    ).toList();
  }
}

class ProductNotifier extends StateNotifier<ProductState> {
  final Ref _ref;
  ProductNotifier(this._ref) : super(ProductState(products: [])) {
    loadProducts();
  }

  // Helper to get the default price for display purposes
  // Assumes 'Retail' price level has ID 1. This could be made dynamic.
  int get _defaultPriceLevelId => 1; 

  Future<void> loadProducts() async {
    final products = await DatabaseHelper().getProducts();
    state = state.copyWith(products: products);
  }

  Future<int> addProduct(Product product) async {
    final insertedProduct = await DatabaseHelper().insertProduct(product);
    await loadProducts();
    return insertedProduct.id!;
  }

  Future<void> updateProduct(Product product) async {
    await DatabaseHelper().updateProduct(product);
    await loadProducts();
  }

  Future<void> deleteProduct(int id) async {
    await DatabaseHelper().deleteProduct(id);
    await loadProducts();
  }

  Future<void> adjustStock({required int id, required int adjustment, required String type, String? reason}) async {
    await DatabaseHelper().adjustStock(id: id, adjustment: adjustment, type: type, reason: reason);
    await loadProducts();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  Future<void> toggleFavorite(int id) async {
    final products = state.products.map((p) {
      if (p.id == id) {
        final updated = p.copyWith(
          favorite: !p.favorite,
        );
        DatabaseHelper().updateProduct(updated);
        return updated;
      }
      return p;
    }).toList();
    state = state.copyWith(products: products);
  }
}

final productProvider = StateNotifierProvider<ProductNotifier, ProductState>((ref) => ProductNotifier(ref));