import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/price_level_provider.dart';
import '../models/price_level.dart';

class PriceLevelFormScreen extends ConsumerStatefulWidget {
  const PriceLevelFormScreen({super.key});

  @override
  _PriceLevelFormScreenState createState() => _PriceLevelFormScreenState();
}

class _PriceLevelFormScreenState extends ConsumerState<PriceLevelFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  PriceLevel? _editingPriceLevel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final priceLevel = ModalRoute.of(context)?.settings.arguments as PriceLevel?;
    if (priceLevel != null && _editingPriceLevel == null) {
      _editingPriceLevel = priceLevel;
      _nameController.text = priceLevel.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _savePriceLevel() {
    if (_formKey.currentState!.validate()) {
      final priceLevel = PriceLevel(
        id: _editingPriceLevel?.id,
        name: _nameController.text,
      );

      if (_editingPriceLevel == null) {
        ref.read(priceLevelProvider.notifier).addPriceLevel(priceLevel);
      } else {
        ref.read(priceLevelProvider.notifier).updatePriceLevel(priceLevel);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editingPriceLevel == null ? 'Tambah Level Harga' : 'Edit Level Harga'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _savePriceLevel,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama Level Harga'),
                validator: (value) => (value == null || value.isEmpty) ? 'Nama tidak boleh kosong' : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
