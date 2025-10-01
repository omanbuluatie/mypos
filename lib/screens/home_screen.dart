import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../models/product.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _showAddToCartDialog(BuildContext context, WidgetRef ref, Product product) {
    int qty = 1;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah ke Keranjang'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Produk: ${product.name}'),
              Text('Harga: Rp${product.prices[1] ?? 0.0}'),
              TextField(
                autofocus: true,
                decoration: InputDecoration(labelText: 'Jumlah'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  qty = int.tryParse(value) ?? 1;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final price = product.prices[1] ?? 0.0; // Default price level 1
                for (int i = 0; i < qty; i++) {
                  ref.read(cartProvider.notifier).addItem(product, price);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${qty}x ${product.name} ditambahkan ke keranjang')),
                );
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
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final productState = ref.watch(productProvider);
    final products = productState.products;
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text('Etalase'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, '/cart');
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '${cartState.items.length}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
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
                    'oman.buluatie@gmail.com', // TODO: dynamic user email
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
                // Already on home
              },
            ),
            ListTile(
              leading: Icon(Icons.store),
              title: Text('Etalase'),
              onTap: () {
                Navigator.pop(context);
                // Already on etalase
              },
            ),
            Divider(),
            Text('  Transaksi Produk', style: TextStyle(fontWeight: FontWeight.bold)),
            ListTile(
              leading: Icon(Icons.point_of_sale),
              title: Text('Penjualan'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fitur Penjualan belum diimplementasi')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.undo),
              title: Text('Retur Penjualan'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fitur Retur Penjualan belum diimplementasi')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag),
              title: Text('Pembelian'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/pos');
              },
            ),
            ListTile(
              leading: Icon(Icons.undo),
              title: Text('Retur Pembelian'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fitur Retur Pembelian belum diimplementasi')),
                );
              },
            ),
            Divider(),
            Text('  Transaksi Keuangan', style: TextStyle(fontWeight: FontWeight.bold)),
            ListTile(
              leading: Icon(Icons.money_off),
              title: Text('Pengeluaran Umum'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fitur Pengeluaran Umum belum diimplementasi')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Pengeluaran Pengiriman'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fitur Pengeluaran Pengiriman belum diimplementasi')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Pemasukan Lain-lain'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fitur Pemasukan Lain-lain belum diimplementasi')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.trending_down),
              title: Text('Hutang'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fitur Hutang belum diimplementasi')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.trending_up),
              title: Text('Piutang'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fitur Piutang belum diimplementasi')),
                );
              },
            ),
            Divider(),
            Text('  💰 Keuangan', style: TextStyle(fontWeight: FontWeight.bold)),
            ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text('Cashbox'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fitur Cashbox belum diimplementasi')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.waves),
              title: Text('Arus Uang'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/cash_flow_report');
              },
            ),
            ListTile(
              leading: Icon(Icons.add_circle),
              title: Text('Penambahan Saldo'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fitur Penambahan Saldo belum diimplementasi')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.remove_circle),
              title: Text('Pengurangan Saldo'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fitur Pengurangan Saldo belum diimplementasi')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.swap_horiz),
              title: Text('Pemindahan Saldo'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fitur Pemindahan Saldo belum diimplementasi')),
                );
              },
            ),
            Divider(),
            Text('  📊 Laporan Umum', style: TextStyle(fontWeight: FontWeight.bold)),
            ListTile(
              leading: Icon(Icons.today),
              title: Text('Laporan Harian'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/daily_sales_report');
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_view_month),
              title: Text('Laporan Bulanan'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/monthly_sales_report');
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Laporan Tahunan'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/yearly_sales_report');
              },
            ),
            ListTile(
              leading: Icon(Icons.trending_up),
              title: Text('Produk Terlaris'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/best_selling_products');
              },
            ),
            ListTile(
              leading: Icon(Icons.account_balance),
              title: Text('Laporan Saldo'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/balance_report');
              },
            ),
            Divider(),
            Text('  📦 Produk', style: TextStyle(fontWeight: FontWeight.bold)),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Kategori Produk'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/categories');
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Data Produk'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/products');
              },
            ),
            ListTile(
              leading: Icon(Icons.inventory),
              title: Text('Data Stok'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/stock_adjustment');
              },
            ),
            ListTile(
              leading: Icon(Icons.discount),
              title: Text('Paket Diskon'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/discounts');
              },
            ),
            ListTile(
              leading: Icon(Icons.price_change),
              title: Text('Level Harga'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/price_levels');
              },
            ),
            Divider(),
            Text('  📇 Kontak', style: TextStyle(fontWeight: FontWeight.bold)),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Data Customer'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fitur Data Customer belum diimplementasi')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.business),
              title: Text('Data Supplier'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/suppliers');
              },
            ),
            Divider(),
            Text('  👥 User', style: TextStyle(fontWeight: FontWeight.bold)),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Operator'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fitur Operator belum diimplementasi')),
                );
              },
            ),
            Divider(),
            Text('  ⚙️ Bagian Pengaturan', style: TextStyle(fontWeight: FontWeight.bold)),
            ListTile(
              leading: Icon(Icons.store),
              title: Text('Pengaturan Toko'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fitur Pengaturan Toko belum diimplementasi')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Pengaturan Password'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fitur Pengaturan Password belum diimplementasi')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text('Pengaturan Logo Toko'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fitur Pengaturan Logo Toko belum diimplementasi')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.receipt),
              title: Text('Pengaturan Logo Struk'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fitur Pengaturan Logo Struk belum diimplementasi')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.print),
              title: Text('Pengaturan Printer'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fitur Pengaturan Printer belum diimplementasi')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Pengaturan Mode'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fitur Pengaturan Mode belum diimplementasi')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.menu),
              title: Text('Pengaturan Menu'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fitur Pengaturan Menu belum diimplementasi')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Tanda Tangan'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fitur Tanda Tangan belum diimplementasi')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.cloud_upload),
              title: Text('Backup Dropbox'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fitur Backup Dropbox belum diimplementasi')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.add_circle),
              title: Text('Fitur Tambahan'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fitur Tambahan belum diimplementasi')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.swap_horiz),
              title: Text('Transfer Data'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fitur Transfer Data belum diimplementasi')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.restore),
              title: Text('Reset Data'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fitur Reset Data belum diimplementasi')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: Text('Ketentuan'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fitur Ketentuan belum diimplementasi')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fitur About belum diimplementasi')),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                Navigator.pop(context);
                await ref.read(authProvider.notifier).logout();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Pencarian produk',
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.qr_code_scanner),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Fitur scan barcode belum diimplementasi')),
                    );
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              onChanged: (value) {
                // TODO: Implement search
              },
            ),
          ),
          if (productState.products.where((p) => p.favorite).isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Produk Favorit',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(16),
                itemCount: productState.products.where((p) => p.favorite).length,
                itemBuilder: (context, index) {
                  final favorites = productState.products.where((p) => p.favorite).toList();
                  final product = favorites[index];
                  return Container(
                    width: 100,
                    margin: EdgeInsets.only(right: 16),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                              child: product.image != null && product.image!.isNotEmpty
                                  ? Image.network(
                                      product.image!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder: (context, error, stackTrace) => Center(
                                        child: Icon(
                                          Icons.favorite,
                                          size: 24,
                                          color: Colors.red,
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: Icon(
                                        Icons.favorite,
                                        size: 24,
                                        color: Colors.red,
                                      ),
                                    ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Rp ${product.prices[1] ?? 0.0}',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 4, 2), // Adjusted padding
                            child: ElevatedButton(
                              onPressed: () {
                                ref.read(cartProvider.notifier).addItem(product, product.prices[1] ?? 0.0);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Ditambahkan ke keranjang: ${product.name}')),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduce tap target size
                                padding: EdgeInsets.symmetric(vertical: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text('Tambah', style: TextStyle(fontSize: 10)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          Expanded(
            child: products.isEmpty
                ? Center(
                    child: Container(
                      color: Colors.grey.shade200,
                      padding: EdgeInsets.all(32),
                      child: Text(
                        'Belum ada produk untuk ditampilkan',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return InkWell(
                        onTap: () {
                          _showAddToCartDialog(context, ref, product);
                        },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                    child: product.image != null && product.image!.isNotEmpty
                                        ? Image.network(
                                            product.image!,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            errorBuilder: (context, error, stackTrace) => Center(
                                              child: Icon(
                                                Icons.inventory,
                                                size: 48,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          )
                                        : Center(
                                            child: Icon(
                                              Icons.inventory,
                                              size: 48,
                                              color: Colors.grey,
                                            ),
                                          ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Rp ${product.prices[1] ?? 0.0}',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Stok: ${product.stock}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TOTAL',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Rp ${cartState.total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
