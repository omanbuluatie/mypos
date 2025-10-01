import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text('Penjualan'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              // TODO: Implement list action
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Already on cart
            },
          ),
          IconButton(
            icon: Icon(Icons.list_alt),
            onPressed: () {
              // TODO: Implement list alt action
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share action
            },
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // Simpan transaksi
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Transaksi berhasil disimpan')),
              );
              // Tampilkan dialog konfirmasi
              showDialog(
                context: context,
                barrierColor: Colors.grey[800]!.withOpacity(0.8),
                builder: (BuildContext context) {
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    child: Container(
                      width: 300,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Uang Kembali',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Sans-Serif',
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '0',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Sans-Serif',
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // TODO: Implement print invoice
                                },
                                child: Text(
                                  'PRINT INVOICE',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Sans-Serif',
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // TODO: Implement print surat jalan
                                },
                                child: Text(
                                  'PRINT SURAT JALAN',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Sans-Serif',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () {
                                  // TODO: Implement share
                                },
                                child: Text(
                                  'SHARE',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Sans-Serif',
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // TODO: Implement email
                                },
                                child: Text(
                                  'EMAIL',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Sans-Serif',
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // TODO: Implement print
                                },
                                child: Text(
                                  'PRINT',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Sans-Serif',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kasir Toko Portable',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'oman.buluatie@gmail.com',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            ListTile(
              leading: Icon(Icons.store),
              title: Text('Etalase'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.point_of_sale),
              title: Text('Penjualan'),
              onTap: () {
                Navigator.pop(context);
                // Already on sales
              },
            ),
            // Add other menu items as needed
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                Navigator.pop(context);
                // TODO: Implement logout
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Header informasi transaksi
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'ID Transaksi: TRS1561754599309',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Nomor Invoice: INV00000001',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Tanggal: 01/10/2025',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Customer: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Tabel detail penjualan
          Expanded(
            child: cartState.items.isEmpty
                ? Center(
                    child: Text('Keranjang kosong. Tambahkan produk untuk memulai.'),
                  )
                : SingleChildScrollView(
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('NO')),
                        DataColumn(label: Text('NAMA PRODUK')),
                        DataColumn(label: Text('JML')),
                        DataColumn(label: Text('NILAI')),
                      ],
                      rows: cartState.items.asMap().entries.map((entry) {
                        int index = entry.key;
                        CartItem item = entry.value;
                        return DataRow(
                          cells: [
                            DataCell(Text('${index + 1}')),
                            DataCell(Text(item.product.name)),
                            DataCell(Text('${item.qty}')),
                            DataCell(Text('Rp${item.subtotal}')),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
          ),
          // Total
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: Rp${cartState.total}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/payment');
                  },
                  child: Text('Bayar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
