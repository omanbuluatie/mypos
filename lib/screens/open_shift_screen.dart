import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/shift_provider.dart';
import '../providers/auth_provider.dart';
import '../models/shift.dart';

class OpenShiftScreen extends ConsumerStatefulWidget {
  const OpenShiftScreen({super.key});

  @override
  _OpenShiftScreenState createState() => _OpenShiftScreenState();
}

class _OpenShiftScreenState extends ConsumerState<OpenShiftScreen> {
  double openingBalance = 0.0;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Buka Shift'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Saldo Awal Kas'),
            TextField(
              decoration: InputDecoration(
                labelText: 'Saldo Awal',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  openingBalance = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final shift = Shift(
                  userId: authState.userId!,
                  openTime: DateTime.now(),
                  openingBalance: openingBalance,
                );
                await ref.read(shiftProvider.notifier).addShift(shift);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Shift dibuka')),
                );
                Navigator.pop(context);
              },
              child: Text('Buka Shift'),
            ),
          ],
        ),
      ),
    );
  }
}
