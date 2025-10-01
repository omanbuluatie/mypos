import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_helper.dart';
import '../models/po.dart';

class PONotifier extends StateNotifier<List<PO>> {
  PONotifier() : super([]) {
    loadPOs();
  }

  Future<void> loadPOs() async {
    final pos = await DatabaseHelper().getPOs();
    state = pos;
  }

  Future<PO> addPO(PO po) async {
    final insertedPO = await DatabaseHelper().insertPO(po);
    await loadPOs();
    return insertedPO;
  }

  Future<void> updatePO(PO po) async {
    await DatabaseHelper().updatePO(po);
    await loadPOs();
  }

  Future<void> deletePO(int id) async {
    await DatabaseHelper().deletePO(id);
    await loadPOs();
  }

  Future<void> receivePO(int id) async {
    await DatabaseHelper().receivePO(id);
    await loadPOs();
  }

  Future<void> returnPO(int id) async {
    await DatabaseHelper().returnPO(id);
    await loadPOs();
  }
}

final poProvider = StateNotifierProvider<PONotifier, List<PO>>((ref) => PONotifier());
