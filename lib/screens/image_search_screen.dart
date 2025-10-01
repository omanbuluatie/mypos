import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

class ImageSearchScreen extends ConsumerStatefulWidget {
  const ImageSearchScreen({super.key});

  @override
  _ImageSearchScreenState createState() => _ImageSearchScreenState();
}

class _ImageSearchScreenState extends ConsumerState<ImageSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedImageUrl;
  bool _isLoading = false;

  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    // Initialize with an empty list, no placeholders
  }

  // This function calls the Google Custom Search API.
  Future<void> _performApiSearch(String query) async {
    // WARNING: Storing API keys directly in code is insecure. Consider using environment variables.
    const String apiKey = 'AIzaSyD2NYNjqji1v-yB2OoYJCXWrOh4VlAPmbY';
    const String cx = 'd27ba915d0098498c'; // Your Custom Search Engine ID

    final uri = Uri.https('www.googleapis.com', '/customsearch/v1', {
      'key': apiKey,
      'cx': cx,
      'q': query,
      'searchType': 'image',
      'num': '10', // Number of search results to return
    });

    try {
      final httpClient = HttpClient();
      final request = await httpClient.getUrl(uri);
      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final data = json.decode(responseBody);

        if (data['items'] != null) {
          final List<String> fetchedUrls = [];
          for (var item in data['items']) {
            if (item['link'] != null) {
              fetchedUrls.add(item['link']);
            }
          }
          setState(() {
            _imageUrls = fetchedUrls;
            _selectedImageUrl = null; // Reset selection on new search
          });
        } else {
          setState(() {
            _imageUrls = []; // Clear results if no items are found
            _selectedImageUrl = null;
          });
        }
      } else {
        // Handle API error
        print('API Error: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: Gagal memuat gambar (Code: ${response.statusCode})')));
      }
    } catch (e) {
      // Handle network or other errors
      print('Error fetching images: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: Periksa koneksi internet Anda.')));
    }
  }

  void _searchImages() {
    if (_searchController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    // Use the real API search.
    _performApiSearch(_searchController.text).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _useImage(BuildContext context, Product product) {
    if (_selectedImageUrl == null) return;

    final updatedProduct = Product(
        id: product.id,
        name: product.name,
        barcode: product.barcode,
        costPrice: product.costPrice,
        stock: product.stock,
        categoryId: product.categoryId,
        favorite: product.favorite,
        description: product.description,
        unit: product.unit,
        isService: product.isService,
        image: _selectedImageUrl, // Assign the new image URL
        prices: product.prices,
    );

    ref.read(productProvider.notifier).updateProduct(updatedProduct).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gambar produk diperbarui.')));
        Navigator.pop(context); // Go back to the product list
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cari Gambar Produk'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Masukkan kata kunci',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchImages,
                ),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _searchImages(),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _imageUrls.isEmpty
                    ? Center(child: Text('Tidak ada gambar. Silakan mulai pencarian.'))
                    : GridView.builder(
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: _imageUrls.length,
                        itemBuilder: (context, index) {
                          final url = _imageUrls[index];
                          final isSelected = url == _selectedImageUrl;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImageUrl = url;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected ? Colors.blue : Colors.transparent,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, progress) {
                                    return progress == null ? child : Center(child: CircularProgressIndicator());
                                  },
                                  errorBuilder: (context, error, stack) => Icon(Icons.error),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _selectedImageUrl != null ? () => _useImage(context, product) : null,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // full width
              ),
              child: Text('Gunakan Gambar Ini'),
            ),
          ),
        ],
      ),
    );
  }
}
