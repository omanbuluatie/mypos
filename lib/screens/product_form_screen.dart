import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/product_provider.dart';
import '../providers/category_provider.dart';
import '../providers/price_level_provider.dart';
import '../models/product.dart';
import '../models/price_level.dart';

class ProductFormScreen extends ConsumerStatefulWidget {
  const ProductFormScreen({super.key});

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _barcodeController;
  late TextEditingController _costPriceController;
  late TextEditingController _descriptionController;
  late TextEditingController _unitController;
  Product? _product;
  bool _favorite = false;
  int? _selectedCategoryId;
  bool _isService = false;

  final Map<int, TextEditingController> _priceControllers = {};
  List<PriceLevel> _priceLevels = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _barcodeController = TextEditingController();
    _costPriceController = TextEditingController();
    _descriptionController = TextEditingController();
    _unitController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _priceLevels = ref.watch(priceLevelProvider);

    // Initialize price controllers for all price levels
    for (var level in _priceLevels) {
      _priceControllers[level.id!] = TextEditingController();
    }

    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is Product) {
      _product = arguments;
      _isService = _product!.isService;
      _nameController.text = _product!.name;
      _barcodeController.text = _product!.barcode ?? '';
      _costPriceController.text = _product!.costPrice.toString();
      _descriptionController.text = _product!.description ?? '';
      _unitController.text = _product!.unit ?? '';
      _selectedCategoryId = _product!.categoryId;
      _favorite = _product!.favorite;

      // Populate price controllers with existing prices
      for (var level in _priceLevels) {
        _priceControllers[level.id!]?.text = (_product!.prices[level.id!] ?? 0.0).toString();
      }
    } else if (arguments is bool) {
      _isService = arguments;
    } else {
      _isService = false;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    _costPriceController.dispose();
    _descriptionController.dispose();
    _unitController.dispose();
    _priceControllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final costPrice = !_isService && _costPriceController.text.isNotEmpty ? double.parse(_costPriceController.text) : 0.0;

      final Map<int, double> productPrices = {};
      for (var level in _priceLevels) {
        final priceText = _priceControllers[level.id!]?.text;
        productPrices[level.id!] = double.tryParse(priceText ?? '0.0') ?? 0.0;
      }

      final product = Product(
        id: _product?.id,
        name: _nameController.text,
        barcode: _barcodeController.text.isEmpty ? null : _barcodeController.text,
        costPrice: costPrice,
        stock: _product?.stock ?? 0, // For existing products, keep current stock. For new ones, it's 0.
        categoryId: _selectedCategoryId,
        favorite: _favorite,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        unit: _unitController.text.isEmpty ? null : _unitController.text,
        isService: _isService,
        image: _product?.image, // Preserve existing image
        prices: productPrices,
      );

      if (_product == null) {
        final newProductId = await ref.read(productProvider.notifier).addProduct(product);
        final newProduct = product.copyWith(
          id: newProductId,
          stock: 0, // Start with 0 before adjustment
        );
        // Navigate to add stock, replacing the current screen
        Navigator.pushReplacementNamed(context, '/stock_adjustment', arguments: newProduct);
      } else {
        await ref.read(productProvider.notifier).updateProduct(product);
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider);
    final isService = _isService;

    return Scaffold(
      appBar: AppBar(
        title: Text(_product == null ? (isService ? 'Tambah Produk Jasa' : 'Tambah Produk Barang') : (isService ? 'Edit Jasa' : 'Edit Produk')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: isService ? 'Nama Jasa' : 'Nama Produk'),
                validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: _barcodeController,
                decoration: InputDecoration(
                  labelText: 'Kode Produk',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.qr_code_scanner),
                    onPressed: () {
                      // TODO: Implement barcode scan
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Barcode scan not implemented yet')));
                    },
                  ),
                ),
              ),
              if (!isService) ...[
                TextFormField(
                  controller: _costPriceController,
                  decoration: InputDecoration(labelText: 'Harga Dasar'),
                  keyboardType: TextInputType.number,
                  validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
                ),
              ],
              // Dynamically generated price fields for each price level
              ..._priceLevels.map((level) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextFormField(
                  controller: _priceControllers[level.id!],
                  decoration: InputDecoration(labelText: 'Harga ${level.name}'),
                  keyboardType: TextInputType.number,
                  validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
                ),
              )),
              TextFormField(
                controller: _unitController,
                decoration: InputDecoration(labelText: 'Satuan'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Keterangan'),
              ),
              DropdownButtonFormField<int?>(
                value: _selectedCategoryId,
                decoration: InputDecoration(labelText: 'Kategori'),
                items: [
                  DropdownMenuItem<int?>(
                    value: null,
                    child: Text('No Category'),
                  ),
                  ...categories.map((category) => DropdownMenuItem<int?>(
                        value: category.id,
                        child: Text(category.name),
                      )),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Favorite'),
                value: _favorite,
                onChanged: (value) {
                  setState(() {
                    _favorite = value ?? false;
                  });
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                      child: Text('Batal'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveProduct,
                      child: Text('Simpan'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
