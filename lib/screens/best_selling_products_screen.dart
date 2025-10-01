import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_helper.dart';

class BestSellingProductsScreen extends ConsumerStatefulWidget {
  const BestSellingProductsScreen({super.key});

  @override
  _BestSellingProductsScreenState createState() => _BestSellingProductsScreenState();
}

class _BestSellingProductsScreenState extends ConsumerState<BestSellingProductsScreen> {
  List<Map<String, dynamic>> products = [];
  int limit = 10;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    products = await DatabaseHelper().getBestSellingProducts(limit);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Produk Terlaris'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text('Jumlah produk: $limit'),
                SizedBox(width: 16),
                DropdownButton<int>(
                  value: limit,
                  items: [10, 20, 50].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value'),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      setState(() {
                        limit = newValue;
                      });
                      _loadProducts();
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ListTile(
                    title: Text(product['name']),
                    subtitle: Text('Total Terjual: ${product['total_qty']}'),
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
