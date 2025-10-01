import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';

class StockAdjustmentScreen extends ConsumerStatefulWidget {
  final Product? product;

  const StockAdjustmentScreen({super.key, this.product});

  @override
  _StockAdjustmentScreenState createState() => _StockAdjustmentScreenState();
}

class _StockAdjustmentScreenState extends ConsumerState<StockAdjustmentScreen> {
  Product? selectedProduct;
  final TextEditingController adjustmentController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    selectedProduct = widget.product;
    // Add listener to update the UI on text change
    adjustmentController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    adjustmentController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productProvider);
    final products = productState.products;
    final isAddStock = widget.product != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isAddStock ? 'Tambah Stok Awal Produk' : 'Penyesuaian Stok'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (isAddStock) ...[
                TextField(
                  controller: TextEditingController(text: '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Tanggal',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                  onTap: () => _selectDate(context),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(text: widget.product!.name),
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nama Produk',
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(text: widget.product!.unit ?? ''),
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Unit / Satuan',
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: adjustmentController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Jumlah Stok Awal',
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: reasonController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Alasan (Opsional)',
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                        child: Text('BATAL'),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: adjustmentController.text.isNotEmpty
                            ? () async {
                                try {
                                  int adjustment = int.tryParse(adjustmentController.text) ?? 0;
                                  if (adjustment <= 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Jumlah harus positif')),
                                    );
                                    return;
                                  }
                                  await ref.read(productProvider.notifier).adjustStock(
                                    id: widget.product!.id!,
                                    adjustment: adjustment,
                                    type: 'INITIAL',
                                    reason: reasonController.text.isNotEmpty ? reasonController.text : 'Stok Awal',
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Stok awal berhasil ditambahkan')),
                                  );
                                  Navigator.pop(context);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Gagal menambahkan stok: $e')),
                                  );
                                }
                              }
                            : null,
                        child: Text('SIMPAN STOK'),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                DropdownButtonFormField<Product>(
                  value: selectedProduct,
                  hint: Text('Pilih Produk'),
                  items: products.map((product) {
                    return DropdownMenuItem<Product>(
                      value: product,
                      child: Text('${product.name} (Stok: ${product.stock})'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedProduct = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Produk',
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: adjustmentController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Jumlah Penyesuaian (gunakan - untuk mengurangi)',
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: reasonController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Alasan (opsional)',
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: selectedProduct != null && adjustmentController.text.isNotEmpty
                      ? () async {
                          try {
                            int adjustment = int.tryParse(adjustmentController.text) ?? 0;
                            if (adjustment == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Jumlah tidak boleh nol')),
                              );
                              return;
                            }
                            await ref.read(productProvider.notifier).adjustStock(
                              id: selectedProduct!.id!,
                              adjustment: adjustment,
                              type: 'ADJUSTMENT',
                              reason: reasonController.text,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Stok berhasil disesuaikan')),
                            );
                            // Clear fields
                            adjustmentController.clear();
                            reasonController.clear();
                            setState(() {
                              selectedProduct = null;
                            });
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Gagal menyesuaikan stok: $e')),
                            );
                          }
                        }
                      : null,
                  child: Text('Sesuaikan Stok'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}