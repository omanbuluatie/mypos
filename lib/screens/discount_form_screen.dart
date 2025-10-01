import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/discount.dart';
import '../providers/discount_provider.dart';
import '../providers/product_provider.dart';

class DiscountFormScreen extends ConsumerStatefulWidget {
  const DiscountFormScreen({super.key});

  @override
  _DiscountFormScreenState createState() => _DiscountFormScreenState();
}

class _DiscountFormScreenState extends ConsumerState<DiscountFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _valueController = TextEditingController();

  String _selectedType = 'PERCENTAGE';
  List<int> _selectedProductIds = [];
  Discount? _editingDiscount;

  @override
  void initState() {
    super.initState();
    // Using a post-frame callback to access arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final discount = ModalRoute.of(context)?.settings.arguments as Discount?;
      if (discount != null) {
        setState(() {
          _editingDiscount = discount;
          _nameController.text = discount.name;
          _valueController.text = discount.value.toString();
          _selectedType = discount.type;
          _selectedProductIds = List<int>.from(discount.productIds);
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _saveDiscount() {
    if (_formKey.currentState!.validate()) {
      final discount = Discount(
        id: _editingDiscount?.id,
        name: _nameController.text,
        type: _selectedType,
        value: double.tryParse(_valueController.text) ?? 0.0,
        productIds: _selectedProductIds,
      );

      if (_editingDiscount == null) {
        ref.read(discountProvider.notifier).addDiscount(discount);
      } else {
        ref.read(discountProvider.notifier).updateDiscount(discount);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_editingDiscount == null ? 'Tambah Diskon' : 'Edit Diskon'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveDiscount,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nama Diskon'),
              validator: (value) => (value == null || value.isEmpty) ? 'Nama tidak boleh kosong' : null,
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: InputDecoration(labelText: 'Tipe Diskon'),
              items: ['PERCENTAGE', 'FLAT'].map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedType = value;
                  });
                }
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _valueController,
              decoration: InputDecoration(labelText: 'Nilai Diskon'),
              keyboardType: TextInputType.number,
              validator: (value) => (value == null || value.isEmpty) ? 'Nilai tidak boleh kosong' : null,
            ),
            SizedBox(height: 24),
            Text('Produk yang Berlaku', style: Theme.of(context).textTheme.headlineSmall),
            Divider(),
            if (productState.products.isEmpty)
              Center(child: Text('Tidak ada produk tersedia.'))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: productState.products.length,
                itemBuilder: (context, index) {
                  final product = productState.products[index];
                  return CheckboxListTile(
                    title: Text(product.name),
                    value: _selectedProductIds.contains(product.id!),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedProductIds.add(product.id!);
                        } else {
                          _selectedProductIds.remove(product.id!);
                        }
                      });
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
