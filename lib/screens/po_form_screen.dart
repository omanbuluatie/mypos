import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/po_provider.dart';
import '../providers/po_item_provider.dart';
import '../providers/supplier_provider.dart';
import '../providers/product_provider.dart';
import '../models/po.dart';
import '../models/po_item.dart';
import '../models/supplier.dart';
import '../models/product.dart';
import '../database/database_helper.dart';

class POFormScreen extends ConsumerStatefulWidget {
  const POFormScreen({super.key});

  @override
  _POFormScreenState createState() => _POFormScreenState();
}

class _POFormScreenState extends ConsumerState<POFormScreen> {
  final _formKey = GlobalKey<FormState>();
  PO? _po;
  int? _selectedSupplierId;
  String _status = 'draft';
  DateTime _date = DateTime.now();
  List<POItem> _items = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _po = ModalRoute.of(context)?.settings.arguments as PO?;
    if (_po != null) {
      _selectedSupplierId = _po!.supplierId;
      _status = _po!.status;
      _date = _po!.date;
      // Load items
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final items = await DatabaseHelper().getPOItems(_po!.id!);
        setState(() {
          _items = items;
        });
      });
    }
  }

  void _savePO() async {
    if (_formKey.currentState!.validate() && _selectedSupplierId != null) {
      final po = PO(
        id: _po?.id,
        supplierId: _selectedSupplierId!,
        date: _date,
        status: _status,
        total: _calculateTotal(),
      );
      if (_po == null) {
        final newPO = await ref.read(poProvider.notifier).addPO(po);
        // Add items
        for (var item in _items) {
          item.poId = newPO.id!;
          await ref.read(poItemProvider(newPO.id!).notifier).addPOItem(item);
        }
      } else {
        await ref.read(poProvider.notifier).updatePO(po);
        // Update items - for simplicity, delete all and re-add
        for (var item in _items) {
          if (item.id == null) {
            await ref.read(poItemProvider(_po!.id!).notifier).addPOItem(item);
          } else {
            await ref.read(poItemProvider(_po!.id!).notifier).updatePOItem(item);
          }
        }
      }
      Navigator.pop(context);
    }
  }

  double _calculateTotal() {
    return _items.fold(0.0, (sum, item) => sum + (item.qty * item.costPrice));
  }

  void _addItem() {
    // Simple dialog to add item
    showDialog(
      context: context,
      builder: (context) {
        int productId = 0;
        int qty = 1;
        double costPrice = 0.0;
        return AlertDialog(
          title: Text('Add Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                value: productId,
                items: ref.watch(productProvider).products.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
                onChanged: (value) => productId = value!,
                decoration: InputDecoration(labelText: 'Product'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Qty'),
                keyboardType: TextInputType.number,
                onChanged: (value) => qty = int.tryParse(value) ?? 1,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Cost Price'),
                keyboardType: TextInputType.number,
                onChanged: (value) => costPrice = double.tryParse(value) ?? 0.0,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _items.add(POItem(poId: _po?.id ?? 0, productId: productId, qty: qty, costPrice: costPrice));
                });
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final suppliers = ref.watch(supplierProvider);
    final products = ref.watch(productProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_po == null ? 'Add PO' : 'Edit PO'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<int>(
                value: _selectedSupplierId,
                items: suppliers.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))).toList(),
                onChanged: (value) => setState(() => _selectedSupplierId = value),
                decoration: InputDecoration(labelText: 'Supplier'),
                validator: (value) => value == null ? 'Required' : null,
              ),
              TextFormField(
                initialValue: _status,
                decoration: InputDecoration(labelText: 'Status'),
                onChanged: (value) => _status = value,
              ),
              // Date picker can be added later
              SizedBox(height: 20),
              Text('Items:'),
              ..._items.map((item) {
                final product = products.products.firstWhere((p) => p.id == item.productId);
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('Qty: ${item.qty}, Cost: ${item.costPrice}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => setState(() => _items.remove(item)),
                  ),
                );
              }),
              ElevatedButton(onPressed: _addItem, child: Text('Add Item')),
              SizedBox(height: 20),
              Text('Total: Rp${_calculateTotal()}'),
              ElevatedButton(
                onPressed: _savePO,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
