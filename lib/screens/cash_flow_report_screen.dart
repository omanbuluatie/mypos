import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../database/database_helper.dart';
import '../models/cash_movement.dart';

class CashFlowReportScreen extends StatefulWidget {
  @override
  _CashFlowReportScreenState createState() => _CashFlowReportScreenState();
}

class _CashFlowReportScreenState extends State<CashFlowReportScreen> {
  DateTime startDate = DateTime.now().subtract(Duration(days: 30));
  DateTime endDate = DateTime.now();
  List<CashMovement> movements = [];
  double totalIn = 0.0;
  double totalOut = 0.0;
  double netFlow = 0.0;

  @override
  void initState() {
    super.initState();
    _loadMovements();
  }

  Future<void> _loadMovements() async {
    movements = await DatabaseHelper().getCashMovementsByDateRange(startDate, endDate);
    totalIn = movements.where((m) => m.type == 'in').fold(0.0, (sum, m) => sum + m.amount);
    totalOut = movements.where((m) => m.type == 'out').fold(0.0, (sum, m) => sum + m.amount);
    netFlow = totalIn - totalOut;
    setState(() {});
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: startDate, end: endDate),
    );
    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end.add(Duration(days: 1)); // Include end date
      });
      _loadMovements();
    }
  }

  Future<void> _exportToCSV() async {
    List<List<String>> data = [
      ['Type', 'Amount', 'Reason', 'Timestamp']
    ];
    for (var movement in movements) {
      data.add([
        movement.type,
        movement.amount.toStringAsFixed(2),
        movement.reason ?? 'N/A',
        movement.timestamp.toLocal().toString()
      ]);
    }
    String csv = const ListToCsvConverter().convert(data);
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/cash_flow_${startDate.toLocal().toString().split(' ')[0]}_to_${endDate.subtract(Duration(days: 1)).toLocal().toString().split(' ')[0]}.csv';
    final file = File(path);
    await file.writeAsString(csv);
    await Share.shareXFiles([XFile(path)], text: 'Laporan Arus Uang');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Arus Uang'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _exportToCSV,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text('Periode: ${startDate.toLocal().toString().split(' ')[0]} - ${endDate.subtract(Duration(days: 1)).toLocal().toString().split(' ')[0]}'),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _selectDateRange(context),
                  child: Text('Pilih Periode'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Masuk:', style: TextStyle(fontSize: 16)),
                        Text('Rp${totalIn.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, color: Colors.green)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Keluar:', style: TextStyle(fontSize: 16)),
                        Text('Rp${totalOut.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, color: Colors.red)),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Arus Bersih:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Rp${netFlow.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: netFlow >= 0 ? Colors.green : Colors.red)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: movements.length,
                itemBuilder: (context, index) {
                  final movement = movements[index];
                  return ListTile(
                    title: Text('${movement.type == 'in' ? 'Masuk' : 'Keluar'}: Rp${movement.amount.toStringAsFixed(2)}'),
                    subtitle: Text('${movement.reason ?? 'N/A'} - ${movement.timestamp.toLocal()}'),
                    leading: Icon(
                      movement.type == 'in' ? Icons.arrow_downward : Icons.arrow_upward,
                      color: movement.type == 'in' ? Colors.green : Colors.red,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
