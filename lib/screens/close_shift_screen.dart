import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/shift_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/cash_movement_provider.dart';
import '../models/shift.dart';
import '../models/cash_movement.dart';
import '../database/database_helper.dart';

class CloseShiftScreen extends ConsumerStatefulWidget {
  const CloseShiftScreen({super.key});

  @override
  _CloseShiftScreenState createState() => _CloseShiftScreenState();
}

class _CloseShiftScreenState extends ConsumerState<CloseShiftScreen> {
  double closingBalance = 0.0;
  Shift? openShift;

  @override
  void initState() {
    super.initState();
    _loadOpenShift();
  }

  Future<void> _loadOpenShift() async {
    final authState = ref.read(authProvider);
    if (authState.userId != null) {
      openShift = await DatabaseHelper().getOpenShift(authState.userId!);
      if (openShift != null) {
        await ref.read(cashMovementProvider.notifier).loadMovements(openShift!.id!);
      }
      setState(() {});
    }
  }

  void _showAddMovementDialog(BuildContext context) {
    String type = 'out';
    double amount = 0.0;
    String reason = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Gerakan Kas'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: type,
                items: [
                  DropdownMenuItem(value: 'in', child: Text('Masuk')),
                  DropdownMenuItem(value: 'out', child: Text('Keluar')),
                ],
                onChanged: (value) => type = value!,
                decoration: InputDecoration(labelText: 'Tipe'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Jumlah'),
                keyboardType: TextInputType.number,
                onChanged: (value) => amount = double.tryParse(value) ?? 0.0,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Alasan'),
                onChanged: (value) => reason = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final movement = CashMovement(
                  shiftId: openShift!.id!,
                  type: type,
                  amount: amount,
                  reason: reason,
                  timestamp: DateTime.now(),
                );
                await ref.read(cashMovementProvider.notifier).addMovement(movement);
                Navigator.pop(context);
              },
              child: Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (openShift == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Tutup Shift'),
        ),
        body: Center(
          child: Text('Tidak ada shift terbuka'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Tutup Shift'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Saldo Awal: Rp${openShift!.openingBalance.toStringAsFixed(2)}'),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Saldo Akhir',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  closingBalance = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Gerakan Kas:', style: TextStyle(fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: () => _showAddMovementDialog(context),
                  child: Text('Tambah'),
                ),
              ],
            ),
            SizedBox(height: 8),
            Consumer(
              builder: (context, ref, child) {
                final movementState = ref.watch(cashMovementProvider);
                return Expanded(
                  child: ListView.builder(
                    itemCount: movementState.movements.length,
                    itemBuilder: (context, index) {
                      final movement = movementState.movements[index];
                      return ListTile(
                        title: Text('${movement.type == 'in' ? 'Masuk' : 'Keluar'}: Rp${movement.amount.toStringAsFixed(2)}'),
                        subtitle: Text('${movement.reason ?? ''} - ${movement.timestamp.toLocal()}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => ref.read(cashMovementProvider.notifier).deleteMovement(movement.id!, openShift!.id!),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final updatedShift = openShift!.copyWith(
                  closeTime: DateTime.now(),
                  closingBalance: closingBalance,
                );
                await ref.read(shiftProvider.notifier).updateShift(updatedShift);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Shift ditutup')),
                );
                Navigator.pop(context);
              },
              child: Text('Tutup Shift'),
            ),
          ],
        ),
      ),
    );
  }
}
