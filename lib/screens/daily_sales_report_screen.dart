import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:csv/csv.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../database/database_helper.dart';
import '../models/sale.dart';

class DailySalesReportScreen extends ConsumerStatefulWidget {
  const DailySalesReportScreen({super.key});

  @override
  _DailySalesReportScreenState createState() => _DailySalesReportScreenState();
}

class _DailySalesReportScreenState extends ConsumerState<DailySalesReportScreen> {
  DateTime selectedDate = DateTime.now();
  List<Sale> sales = [];
  double totalSales = 0.0;

  @override
  void initState() {
    super.initState();
    _loadSales();
  }

  Future<void> _loadSales() async {
    DateTime start = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    DateTime end = start.add(Duration(days: 1));
    sales = await DatabaseHelper().getSalesByDateRange(start, end);
    totalSales = sales.fold(0.0, (sum, sale) => sum + sale.total);
    setState(() {});
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      _loadSales();
    }
  }

  Future<void> _exportToCSV() async {
    List<List<String>> data = [
      ['Invoice', 'Total', 'Payment Method', 'Date']
    ];
    for (var sale in sales) {
      data.add([
        sale.invoiceNumber ?? 'N/A',
        sale.total.toStringAsFixed(2),
        sale.paymentMethod,
        sale.date.toLocal().toString()
      ]);
    }
    String csv = const ListToCsvConverter().convert(data);
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/daily_sales_${selectedDate.toLocal().toString().split(' ')[0]}.csv';
    final file = File(path);
    await file.writeAsString(csv);
    await Share.shareXFiles([XFile(path)], text: 'Laporan Penjualan Harian');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Penjualan Harian'),
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
                Text('Tanggal: ${selectedDate.toLocal().toString().split(' ')[0]}'),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Pilih Tanggal'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('Total Penjualan: Rp${totalSales.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: sales.length,
                itemBuilder: (context, index) {
                  final sale = sales[index];
                  return ListTile(
                    title: Text('Invoice: ${sale.invoiceNumber ?? 'N/A'}'),
                    subtitle: Text('Total: Rp${sale.total.toStringAsFixed(2)} - ${sale.paymentMethod} - ${sale.date.toLocal()}'),
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
