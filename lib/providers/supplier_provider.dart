import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_helper.dart';
import '../models/supplier.dart';

class SupplierNotifier extends StateNotifier<List<Supplier>> {
  SupplierNotifier() : super([]) {
    loadSuppliers();
  }

  Future<void> loadSuppliers() async {
    final suppliers = await DatabaseHelper().getSuppliers();
    state = suppliers;
  }

  Future<void> addSupplier(Supplier supplier) async {
    await DatabaseHelper().insertSupplier(supplier);
    await loadSuppliers();
  }

  Future<void> updateSupplier(Supplier supplier) async {
    await DatabaseHelper().updateSupplier(supplier);
    await loadSuppliers();
  }

  Future<void> deleteSupplier(int id) async {
    await DatabaseHelper().deleteSupplier(id);
    await loadSuppliers();
  }
}

final supplierProvider = StateNotifierProvider<SupplierNotifier, List<Supplier>>((ref) => SupplierNotifier());
