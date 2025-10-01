import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_helper.dart';
import '../models/sale_item.dart';

class SaleItemState {
  final List<SaleItem> items;

  SaleItemState({required this.items});

  SaleItemState copyWith({List<SaleItem>? items}) {
    return SaleItemState(items: items ?? this.items);
  }
}

class SaleItemNotifier extends StateNotifier<SaleItemState> {
  final int saleId;

  SaleItemNotifier(this.saleId) : super(SaleItemState(items: [])) {
    loadItems();
  }

  Future<void> loadItems() async {
    final items = await DatabaseHelper().getSaleItems(saleId);
    state = state.copyWith(items: items);
  }

  Future<int> addItem(SaleItem item) async {
    final inserted = await DatabaseHelper().insertSaleItem(item);
    await loadItems();
    return inserted.id!;
  }

  Future<void> updateItem(SaleItem item) async {
    await DatabaseHelper().updateSaleItem(item);
    await loadItems();
  }

  Future<void> deleteItem(int id) async {
    await DatabaseHelper().deleteSaleItem(id);
    await loadItems();
  }
}

final saleItemProvider = StateNotifierProvider.family<SaleItemNotifier, SaleItemState, int>((ref, saleId) => SaleItemNotifier(saleId));
