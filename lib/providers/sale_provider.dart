import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_helper.dart';
import '../models/sale.dart';

class SaleState {
  final List<Sale> sales;

  SaleState({required this.sales});

  SaleState copyWith({List<Sale>? sales}) {
    return SaleState(sales: sales ?? this.sales);
  }
}

class SaleNotifier extends StateNotifier<SaleState> {
  SaleNotifier() : super(SaleState(sales: [])) {
    loadSales();
  }

  Future<void> loadSales() async {
    final sales = await DatabaseHelper().getSales();
    state = state.copyWith(sales: sales);
  }

  Future<Sale> addSale(Sale sale) async {
    final inserted = await DatabaseHelper().insertSale(sale);
    await loadSales();
    return inserted;
  }

  Future<void> updateSale(Sale sale) async {
    await DatabaseHelper().updateSale(sale);
    await loadSales();
  }

  Future<void> deleteSale(int id) async {
    await DatabaseHelper().deleteSale(id);
    await loadSales();
  }
}

final saleProvider = StateNotifierProvider<SaleNotifier, SaleState>((ref) => SaleNotifier());
