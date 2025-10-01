import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_helper.dart';
import '../models/price_level.dart';

class PriceLevelNotifier extends StateNotifier<List<PriceLevel>> {
  PriceLevelNotifier() : super([]) {
    loadPriceLevels();
  }

  Future<void> loadPriceLevels() async {
    state = await DatabaseHelper().getPriceLevels();
  }

  Future<void> addPriceLevel(PriceLevel priceLevel) async {
    await DatabaseHelper().insertPriceLevel(priceLevel);
    await loadPriceLevels();
  }

  Future<void> updatePriceLevel(PriceLevel priceLevel) async {
    await DatabaseHelper().updatePriceLevel(priceLevel);
    await loadPriceLevels();
  }

  Future<void> deletePriceLevel(int id) async {
    await DatabaseHelper().deletePriceLevel(id);
    await loadPriceLevels();
  }
}

final priceLevelProvider = StateNotifierProvider<PriceLevelNotifier, List<PriceLevel>>((ref) => PriceLevelNotifier());
