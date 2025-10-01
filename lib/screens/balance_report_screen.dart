import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../database/database_helper.dart';

class BalanceReportScreen extends StatefulWidget {
  @override
  _BalanceReportScreenState createState() => _BalanceReportScreenState();
}

class _BalanceReportScreenState extends State<BalanceReportScreen> {
  double totalSales = 0.0;
  double totalCashIn = 0.0;
  double totalCashOut = 0.0;
  double netBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    totalSales = await DatabaseHelper().getTotalSales();
    totalCashIn = await DatabaseHelper().getTotalCashIn();
    totalCashOut = await DatabaseHelper().getTotalCashOut();
    netBalance = totalSales + totalCashIn - totalCashOut;
    setState(() {});
  }

  Future<void> _exportToCSV() async {
    List<List<String>> data = [
      ['Item', 'Amount'],
      ['Total Penjualan', totalSales.toStringAsFixed(2)],
      ['Total Cash Masuk', totalCashIn.toStringAsFixed(2)],
      ['Total Cash Keluar', totalCashOut.toStringAsFixed(2)],
      ['Saldo Bersih', netBalance.toStringAsFixed(2)],
    ];
    String csv = const ListToCsvConverter().convert(data);
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/balance_report.csv';
    final file = File(path);
    await file.writeAsString(csv);
    await Share.shareXFiles([XFile(path)], text: 'Laporan Saldo');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Saldo'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ringkasan Keuangan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Penjualan:', style: TextStyle(fontSize: 16)),
                        Text('Rp${totalSales.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, color: Colors.green)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Cash Masuk:', style: TextStyle(fontSize: 16)),
                        Text('Rp${totalCashIn.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, color: Colors.blue)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Cash Keluar:', style: TextStyle(fontSize: 16)),
                        Text('Rp${totalCashOut.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, color: Colors.red)),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Saldo Bersih:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Rp${netBalance.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: netBalance >= 0 ? Colors.green : Colors.red)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
