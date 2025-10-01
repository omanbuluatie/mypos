import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_helper.dart';
import '../models/discount.dart';

class DiscountNotifier extends StateNotifier<List<Discount>> {
  DiscountNotifier() : super([]) {
    loadDiscounts();
  }

  Future<void> loadDiscounts() async {
    state = await DatabaseHelper().getDiscounts();
  }

  Future<void> addDiscount(Discount discount) async {
    await DatabaseHelper().insertDiscount(discount);
    await loadDiscounts();
  }

  Future<void> updateDiscount(Discount discount) async {
    await DatabaseHelper().updateDiscount(discount);
    await loadDiscounts();
  }

  Future<void> deleteDiscount(int id) async {
    await DatabaseHelper().deleteDiscount(id);
    await loadDiscounts();
  }
}

final discountProvider = StateNotifierProvider<DiscountNotifier, List<Discount>>((ref) => DiscountNotifier());
