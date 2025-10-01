import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/supplier_provider.dart';
import '../models/supplier.dart';

class SupplierListScreen extends ConsumerWidget {
  const SupplierListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suppliers = ref.watch(supplierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Suppliers'),
      ),
      body: suppliers.isEmpty
          ? Center(child: Text('No suppliers yet.'))
          : ListView.builder(
              itemCount: suppliers.length,
              itemBuilder: (context, index) {
                final supplier = suppliers[index];
                return Card(
                  child: ListTile(
                    title: Text(supplier.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (supplier.contact != null) Text('Contact: ${supplier.contact}'),
                        if (supplier.address != null) Text('Address: ${supplier.address}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await ref.read(supplierProvider.notifier).deleteSupplier(supplier.id!);
                      },
                    ),
                    onTap: () {
                      // Navigate to edit
                      Navigator.pushNamed(context, '/supplier_form', arguments: supplier);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/supplier_form');
        },
      ),
    );
  }
}
