import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_helper.dart';
import '../models/po_item.dart';

class POItemNotifier extends StateNotifier<List<POItem>> {
  final int poId;
  POItemNotifier(this.poId) : super([]) {
    loadPOItems();
  }

  Future<void> loadPOItems() async {
    final items = await DatabaseHelper().getPOItems(poId);
    state = items;
  }

  Future<void> addPOItem(POItem item) async {
    await DatabaseHelper().insertPOItem(item);
    await loadPOItems();
  }

  Future<void> updatePOItem(POItem item) async {
    await DatabaseHelper().updatePOItem(item);
    await loadPOItems();
  }

  Future<void> deletePOItem(int id) async {
    await DatabaseHelper().deletePOItem(id);
    await loadPOItems();
  }
}

final poItemProvider = StateNotifierProvider.family<POItemNotifier, List<POItem>, int>((ref, poId) => POItemNotifier(poId));
