import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/product_provider.dart';
// Import price level provider
import '../providers/cart_provider.dart';
import '../models/product.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  void _showProductOptions(BuildContext context, WidgetRef ref, Product product) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              if (product.stock > 0)
                ListTile(
                  leading: Icon(Icons.add_shopping_cart),
                  title: Text('Tambah ke Keranjang'),
                  onTap: () {
                    Navigator.pop(context); // Close the bottom sheet
                    final price = product.prices[1] ?? 0.0; // Default price level 1
                    ref.read(cartProvider.notifier).addItem(product, price);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${product.name} ditambahkan ke keranjang')),
                    );
                  },
                ),
              ListTile(
                leading: Icon(Icons.inventory),
                title: Text('Penyesuaian Stok'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  Navigator.pushNamed(context, '/stock_adjustment', arguments: product);
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Ubah Gambar'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  Navigator.pushNamed(context, '/image_search', arguments: product);
                },
              ),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  Navigator.pushNamed(context, '/product_form', arguments: product);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Hapus'),
                onTap: () async {
                  Navigator.pop(context); // Close the bottom sheet first

                  // Show confirmation dialog
                  final bool? confirmDelete = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Konfirmasi Hapus'),
                        content: Text('Apakah Anda yakin ingin menghapus produk "${product.name}"?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Batal'),
                            onPressed: () {
                              Navigator.of(context).pop(false); // Dismiss dialog and return false
                            },
                          ),
                          TextButton(
                            style: TextButton.styleFrom(foregroundColor: Colors.red),
                            onPressed: () {
                              Navigator.of(context).pop(true); // Dismiss dialog and return true
                            },
                            child: Text('Hapus'),
                          ),
                        ],
                      );
                    },
                  );

                  // If the user confirmed, then delete the product
                  if (confirmDelete == true) {
                    await ref.read(productProvider.notifier).deleteProduct(product.id!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${product.name} telah dihapus')),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productProvider);
    final products = productState.filteredProducts;
    // Assuming default price level ID is 1 for Retail
    final defaultPriceLevelId = 1; 

    return Scaffold(
      appBar: AppBar(
        title: Text('Data Produk'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
            tooltip: 'Keranjang',
          ),
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () {
              // TODO: Implement export to Excel
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export to Excel not implemented yet')));
            },
            tooltip: 'Export Excel',
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Share not implemented yet')));
            },
            tooltip: 'Share',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari berdasarkan nama atau kode',
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.qr_code_scanner),
                  onPressed: () {
                    // TODO: Implement barcode scan for search
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Barcode scan for search not implemented yet')));
                  },
                ),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                ref.read(productProvider.notifier).setSearchQuery(value);
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'SEMUA PRODUK',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: products.isEmpty
                ? Center(child: Text('Tidak ada produk ditemukan.'))
                : ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Card(
                        child: ListTile(
                          leading: SizedBox(
                            width: 56,
                            height: 56,
                            child: product.image != null && product.image!.isNotEmpty
                                ? Image.network(
                                    product.image!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Icon(Icons.inventory_2, size: 32), // Placeholder on error
                                  )
                                : Icon(Icons.inventory_2, size: 32), // Placeholder if no image
                          ),
                          title: Text(product.name),
                          subtitle: Text('Harga: Rp${product.prices[defaultPriceLevelId] ?? 0.0} | Stok: ${product.stock} | Kode: ${product.barcode ?? 'N/A'}'),
                          onTap: () {
                            _showProductOptions(context, ref, product);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(Icons.inventory),
                      title: Text('Tambah Produk Barang'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/product_form', arguments: false);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.build),
                      title: Text('Tambah Produk Jasa'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/product_form', arguments: true);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
