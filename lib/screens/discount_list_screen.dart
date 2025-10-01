import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/discount_provider.dart';

class DiscountListScreen extends ConsumerWidget {
  const DiscountListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discounts = ref.watch(discountProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Paket Diskon'),
      ),
      body: discounts.isEmpty
          ? Center(child: Text('Belum ada diskon dibuat.'))
          : ListView.builder(
              itemCount: discounts.length,
              itemBuilder: (context, index) {
                final discount = discounts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    title: Text(discount.name, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Tipe: ${discount.type}, Nilai: ${discount.value}${discount.type == 'PERCENTAGE' ? '%' : ''}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final bool? confirmDelete = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Konfirmasi Hapus'),
                              content: Text('Anda yakin ingin menghapus diskon "${discount.name}"?'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Batal'),
                                  onPressed: () => Navigator.of(context).pop(false),
                                ),
                                TextButton(
                                  child: Text('Hapus', style: TextStyle(color: Colors.red)),
                                  onPressed: () => Navigator.of(context).pop(true),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirmDelete == true) {
                          await ref.read(discountProvider.notifier).deleteDiscount(discount.id!);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Diskon "${discount.name}" telah dihapus')),
                          );
                        }
                      },
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/discount_form', arguments: discount);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/discount_form');
        },
      ),
    );
  }
}
