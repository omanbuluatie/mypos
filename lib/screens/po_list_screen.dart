import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/po_provider.dart';
import '../providers/supplier_provider.dart';
import '../models/po.dart';
import '../models/supplier.dart';

class POListScreen extends ConsumerWidget {
  const POListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pos = ref.watch(poProvider);
    final suppliers = ref.watch(supplierProvider);

    Map<int, Supplier> supplierMap = { for (var s in suppliers) s.id! : s };

    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase Orders'),
      ),
      body: pos.isEmpty
          ? Center(child: Text('No purchase orders yet.'))
          : ListView.builder(
              itemCount: pos.length,
              itemBuilder: (context, index) {
                final po = pos[index];
                final supplier = supplierMap[po.supplierId];
                return Card(
                  child: ListTile(
                    title: Text('PO #${po.id} - ${supplier?.name ?? 'Unknown'}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: ${po.date.toLocal().toString().split(' ')[0]}'),
                        Text('Status: ${po.status}'),
                        Text('Total: Rp${po.total}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (po.status != 'received' && po.status != 'returned')
                          IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () async {
                              await ref.read(poProvider.notifier).receivePO(po.id!);
                            },
                          ),
                        if (po.status == 'received')
                          IconButton(
                            icon: Icon(Icons.undo),
                            onPressed: () async {
                              await ref.read(poProvider.notifier).returnPO(po.id!);
                            },
                          ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await ref.read(poProvider.notifier).deletePO(po.id!);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      // Navigate to edit
                      Navigator.pushNamed(context, '/po_form', arguments: po);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/po_form');
        },
      ),
    );
  }
}
