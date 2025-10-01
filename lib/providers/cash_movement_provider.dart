import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_helper.dart';
import '../models/cash_movement.dart';

class CashMovementState {
  final List<CashMovement> movements;

  CashMovementState({required this.movements});

  CashMovementState copyWith({List<CashMovement>? movements}) {
    return CashMovementState(movements: movements ?? this.movements);
  }
}

class CashMovementNotifier extends StateNotifier<CashMovementState> {
  CashMovementNotifier() : super(CashMovementState(movements: []));

  Future<void> loadMovements(int shiftId) async {
    final movements = await DatabaseHelper().getCashMovementsByShift(shiftId);
    state = state.copyWith(movements: movements);
  }

  Future<CashMovement> addMovement(CashMovement movement) async {
    final inserted = await DatabaseHelper().insertCashMovement(movement);
    await loadMovements(movement.shiftId);
    return inserted;
  }

  Future<void> updateMovement(CashMovement movement) async {
    await DatabaseHelper().updateCashMovement(movement);
    await loadMovements(movement.shiftId);
  }

  Future<void> deleteMovement(int id, int shiftId) async {
    await DatabaseHelper().deleteCashMovement(id);
    await loadMovements(shiftId);
  }
}

final cashMovementProvider = StateNotifierProvider<CashMovementNotifier, CashMovementState>((ref) => CashMovementNotifier());
