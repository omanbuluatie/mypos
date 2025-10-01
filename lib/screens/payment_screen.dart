import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import '../providers/sale_provider.dart';
import '../providers/sale_item_provider.dart';
import '../providers/product_provider.dart';
import '../models/sale.dart';
import '../models/sale_item.dart';
import '../models/cart_item.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  String paymentMethod = 'tunai';
  double paidAmount = 0.0;

  final List<String> paymentMethods = ['tunai', 'kartu', 'transfer'];

  void _showReceiptDialog(BuildContext context, Sale sale, List<CartItem> items, String invoiceNumber) {
    String receipt = '''
Toko Portable
Invoice: $invoiceNumber
Tanggal: ${sale.date.toString()}
Metode: ${sale.paymentMethod}

Items:
''';
    for (final item in items) {
      receipt += '${item.product.name} x${item.qty} @${item.price} = ${item.subtotal}\n';
    }
    receipt += '''
Total: ${sale.total}
Terima Kasih!
''';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Struk'),
          content: SingleChildScrollView(
            child: Text(receipt),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tutup'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Print receipt
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Print not implemented yet')),
                );
              },
              child: Text('Print'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final total = cartState.total;
    final change = paidAmount - total;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pembayaran'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total: Rp${total.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Metode Pembayaran:'),
            DropdownButton<String>(
              value: paymentMethod,
              onChanged: (String? newValue) {
                setState(() {
                  paymentMethod = newValue!;
                });
              },
              items: paymentMethods.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            if (paymentMethod == 'tunai') ...[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Jumlah Dibayar',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    paidAmount = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              SizedBox(height: 16),
              Text(
                'Kembalian: Rp${change.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, color: change >= 0 ? Colors.green : Colors.red),
              ),
            ],
            Spacer(),
            ElevatedButton(
              onPressed: (paymentMethod != 'tunai' || paidAmount >= total) ? () async {
                // Create Sale
                final sale = Sale(
                  date: DateTime.now(),
                  total: total,
                  paymentMethod: paymentMethod,
                  status: 'completed',
                );
                final insertedSale = await ref.read(saleProvider.notifier).addSale(sale);
                // Generate invoice number
                final invoiceNumber = 'INV-${insertedSale.id}';
                await ref.read(saleProvider.notifier).updateSale(insertedSale.copyWith(invoiceNumber: invoiceNumber));
                // Create SaleItems
                for (final item in cartState.items) {
                  final saleItem = SaleItem(
                    saleId: insertedSale.id!,
                    productId: item.product.id!,
                    qty: item.qty,
                    price: item.price,
                    discount: item.discount,
                  );
                  await ref.read(saleItemProvider(insertedSale.id!).notifier).addItem(saleItem);
                  // Reduce stock
                  await ref.read(productProvider.notifier).adjustStock(
                    id: item.product.id!,
                    adjustment: -item.qty,
                    type: 'sale',
                    reason: 'Sale $invoiceNumber',
                  );
                }
                // Clear cart
                ref.read(cartProvider.notifier).clearCart();
                // Show receipt
                _showReceiptDialog(context, insertedSale, cartState.items, invoiceNumber);
                Navigator.pop(context);
              } : null,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('Selesai'),
            ),
          ],
        ),
      ),
    );
  }
}
