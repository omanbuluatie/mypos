import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_helper.dart';
import '../models/shift.dart';

class ShiftState {
  final List<Shift> shifts;

  ShiftState({required this.shifts});

  ShiftState copyWith({List<Shift>? shifts}) {
    return ShiftState(shifts: shifts ?? this.shifts);
  }
}

class ShiftNotifier extends StateNotifier<ShiftState> {
  ShiftNotifier() : super(ShiftState(shifts: [])) {
    loadShifts();
  }

  Future<void> loadShifts() async {
    final shifts = await DatabaseHelper().getShifts();
    state = state.copyWith(shifts: shifts);
  }

  Future<Shift> addShift(Shift shift) async {
    final inserted = await DatabaseHelper().insertShift(shift);
    await loadShifts();
    return inserted;
  }

  Future<void> updateShift(Shift shift) async {
    await DatabaseHelper().updateShift(shift);
    await loadShifts();
  }

  Future<void> deleteShift(int id) async {
    await DatabaseHelper().deleteShift(id);
    await loadShifts();
  }
}

final shiftProvider = StateNotifierProvider<ShiftNotifier, ShiftState>((ref) => ShiftNotifier());
