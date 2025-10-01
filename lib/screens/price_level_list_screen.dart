import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/price_level_provider.dart';

class PriceLevelListScreen extends ConsumerWidget {
  const PriceLevelListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priceLevels = ref.watch(priceLevelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Level Harga'),
      ),
      body: priceLevels.isEmpty
          ? Center(child: Text('Tidak ada level harga.'))
          : ListView.builder(
              itemCount: priceLevels.length,
              itemBuilder: (context, index) {
                final priceLevel = priceLevels[index];
                return ListTile(
                  title: Text(priceLevel.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.pushNamed(context, '/price_level_form', arguments: priceLevel);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Hapus Level Harga'),
                              content: Text('Apakah Anda yakin ingin menghapus "${priceLevel.name}"?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text('Hapus'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await ref.read(priceLevelProvider.notifier).deletePriceLevel(priceLevel.id!);
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/price_level_form');
        },
      ),
    );
  }
}
