import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_helper.dart';
import '../models/sale.dart';

class YearlySalesReportScreen extends ConsumerStatefulWidget {
  const YearlySalesReportScreen({super.key});

  @override
  _YearlySalesReportScreenState createState() => _YearlySalesReportScreenState();
}

class _YearlySalesReportScreenState extends ConsumerState<YearlySalesReportScreen> {
  int selectedYear = DateTime.now().year;
  List<Sale> sales = [];
  double totalSales = 0.0;

  @override
  void initState() {
    super.initState();
    _loadSales();
  }

  Future<void> _loadSales() async {
    sales = await DatabaseHelper().getSalesByYear(selectedYear);
    totalSales = sales.fold(0.0, (sum, sale) => sum + sale.total);
    setState(() {});
  }

  Future<void> _selectYear(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(selectedYear, 1, 1),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedYear = picked.year;
      });
      _loadSales();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Penjualan Tahunan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text('Tahun: $selectedYear'),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _selectYear(context),
                  child: Text('Pilih Tahun'),
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
