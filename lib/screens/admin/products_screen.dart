import 'package:flutter/material.dart';
import '../../services/cloud_storage_service.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

Widget _buildImageWidget(String imagePath) {
  if (kIsWeb) {
    // For web, treat it as network image using bytes or uploaded file URL
    return Image.network(imagePath);
  } else {
    return Image.file(File(imagePath));
  }
}


class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _displayedProducts = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String? _selectedArtist;
  String? _sortBy;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() => _isLoading = true);
    final products = await CloudStorageService.getProducts();
    setState(() {
      _products = products;
      _applyFilters();
      _isLoading = false;
    });
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_products);
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered = filtered.where((p) =>
        (p['productName'] ?? '').toString().toLowerCase().contains(q) ||
        (p['artist'] ?? '').toString().toLowerCase().contains(q) ||
        (p['category'] ?? '').toString().toLowerCase().contains(q)
      ).toList();
    }
    if (_selectedArtist != null && _selectedArtist!.isNotEmpty) {
      filtered = filtered.where((p) => p['artist'] == _selectedArtist).toList();
    }
    if (_sortBy != null) {
      if (_sortBy == 'price_asc') {
        filtered.sort((a, b) => (double.tryParse(a['price'].toString()) ?? 0)
            .compareTo(double.tryParse(b['price'].toString()) ?? 0));
      } else if (_sortBy == 'price_desc') {
        filtered.sort((a, b) => (double.tryParse(b['price'].toString()) ?? 0)
            .compareTo(double.tryParse(a['price'].toString()) ?? 0));
      } else if (_sortBy == 'name_az') {
        filtered.sort((a, b) => (a['productName'] ?? '').toString().compareTo((b['productName'] ?? '').toString()));
      } else if (_sortBy == 'name_za') {
        filtered.sort((a, b) => (b['productName'] ?? '').toString().compareTo((a['productName'] ?? '').toString()));
      }
    }
    setState(() {
      _displayedProducts = filtered;
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
    _applyFilters();
  }

  void _showArtistFilterDialog() async {
    final artists = _products.map((p) => p['artist'] ?? '').toSet().toList()..sort();
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Filter by Artist'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('All'),
          ),
          ...artists.map((artist) => SimpleDialogOption(
            onPressed: () => Navigator.pop(context, artist),
            child: Text(artist.toString()),
          )),
        ],
      ),
    );
    setState(() {
      _selectedArtist = selected;
    });
    _applyFilters();
  }

  void _showSortDialog() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Sort by'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'price_asc'),
            child: const Text('Price: Low to High'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'price_desc'),
            child: const Text('Price: High to Low'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'name_az'),
            child: const Text('Name: A-Z'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'name_za'),
            child: const Text('Name: Z-A'),
          ),
        ],
      ),
    );
    setState(() {
      _sortBy = selected;
    });
    _applyFilters();
  }

  Future<void> _showProductForm({Map<String, dynamic>? product}) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _ProductFormDialog(product: product),
    );

    if (result != null) {
      try {
        if (product == null) {
          await CloudStorageService.createProduct(result);
        } else {
          await CloudStorageService.updateProduct(product['id'], result);
        }
        await _fetchProducts();
      } catch (e) {
        if (result['uploadedFilePath'] != null) {
          await CloudStorageService.deleteFile(result['uploadedFilePath']);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save product: $e')),
        );
      }
    } else {
      if (result != null && result['uploadedFilePath'] != null && product == null) {
        await CloudStorageService.deleteFile(result['uploadedFilePath']);
      }
    }
  }

  Future<void> _deleteProduct(dynamic productId) async {
    await CloudStorageService.deleteProduct(productId);
    _fetchProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF339989),
        elevation: 0,
        title: const Text('Products', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
        actions: [
          IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
          IconButton(icon: const Icon(Icons.shopping_cart_outlined), onPressed: () {}),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF339989)),
                      hintText: 'Search Product',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton.icon(
                        onPressed: _showSortDialog,
                        icon: const Icon(Icons.sort, color: Color(0xFF339989)),
                        label: const Text('Sort by', style: TextStyle(color: Color(0xFF339989))),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF339989)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: _showArtistFilterDialog,
                        icon: const Icon(Icons.account_box, color: Color(0xFF339989)),
                        label: Text(_selectedArtist == null || _selectedArtist!.isEmpty ? 'Artist' : _selectedArtist!, style: const TextStyle(color: Color(0xFF339989))),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF339989)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: _displayedProducts.length,
                    itemBuilder: (context, index) {
                      final product = _displayedProducts[index];
                      final productImageUrl = product['productImage'] ?? '';
                      final price = product['price'] ?? 0;
                      final discount = product['discount'] ?? 0;
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 80,
                                  width: double.infinity,
                                  child: productImageUrl.isNotEmpty
                                      ? Image.network(
                                          productImageUrl,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Image.asset(
                                            'images/product_logo.png',
                                            height: 80,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Image.asset(
                                          'images/product_logo.png',
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(product['productName'] ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          if (discount != null && discount > 0)
                                            Text(
                                              '\$${price}',
                                              style: const TextStyle(fontSize: 14, color: Colors.grey, decoration: TextDecoration.lineThrough),
                                            ),
                                          if (discount != null && discount > 0) const SizedBox(width: 8),
                                          Text(
                                            '\$${discount != null && discount > 0 ? discount : price}',
                                            style: const TextStyle(fontSize: 18, color: Color(0xFF339989), fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _showProductForm(product: product);
                                  } else if (value == 'delete') {
                                    _deleteProduct(product['id']);
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductForm(),
        backgroundColor: const Color(0xFF339989),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ProductFormDialog extends StatefulWidget {
  final Map<String, dynamic>? product;
  const _ProductFormDialog({this.product});

  @override
  State<_ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<_ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _imageController;
  late TextEditingController _priceController;
  late TextEditingController _discountController;
  late TextEditingController _descController;
  late TextEditingController _quantityController;
  late TextEditingController _quantityTypeController;
  late TextEditingController _categoryController;
  late TextEditingController _artistController;
  late TextEditingController _storeIdController;
  File? _pickedImageFile;
  String? _uploadedImageUrl;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?['productName'] ?? '');
    _imageController = TextEditingController(text: widget.product?['productImage'] ?? '');
    _priceController = TextEditingController(text: widget.product?['price']?.toString() ?? '');
    _discountController = TextEditingController(text: widget.product?['discount']?.toString() ?? '');
    _descController = TextEditingController(text: widget.product?['productDescription'] ?? '');
    _quantityController = TextEditingController(text: widget.product?['quantity']?.toString() ?? '');
    _quantityTypeController = TextEditingController(text: widget.product?['quantityType'] ?? '');
    _categoryController = TextEditingController(text: widget.product?['category'] ?? '');
    _artistController = TextEditingController(text: widget.product?['artist'] ?? '');
    _storeIdController = TextEditingController(text: widget.product?['storeId'] ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _descController.dispose();
    _quantityController.dispose();
    _quantityTypeController.dispose();
    _categoryController.dispose();
    _artistController.dispose();
    _storeIdController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      
      if (result != null && result.files.single.path != null) {
        setState(() {
          _pickedImageFile = File(result.files.single.path!);
          _uploadedImageUrl = null; // Clear any previous URL
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<String?> _uploadImageAndGetUrl() async {
    if (_pickedImageFile == null) {
      // If no new image was picked, return the existing URL
      return widget.product?['productImage'];
    }

    setState(() => _isUploading = true);
    try {
      final url = await CloudStorageService.uploadProductImage(_pickedImageFile!);
      if (url == null) {
        throw Exception('Failed to upload image');
      }
      setState(() {
        _uploadedImageUrl = url;
        _isUploading = false;
      });
      return url;
    } catch (e) {
      setState(() => _isUploading = false);
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _pickedImageFile != null
                    ? Image.file(_pickedImageFile!, height: 80)
                    : (_uploadedImageUrl != null && _uploadedImageUrl!.isNotEmpty)
                        ? Image.network(_uploadedImageUrl!, height: 80)
                        : Container(
                            height: 80,
                            width: 80,
                            color: Colors.grey[200],
                            child: const Icon(Icons.add_a_photo, size: 32),
                          ),
              ),
              if (_isUploading) const LinearProgressIndicator(),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (v) => v == null || v.isEmpty ? 'Enter product name' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _discountController,
                decoration: const InputDecoration(labelText: 'Discount'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _quantityTypeController,
                decoration: const InputDecoration(labelText: 'Quantity Type'),
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              TextFormField(
                controller: _artistController,
                decoration: const InputDecoration(labelText: 'Artist'),
              ),
              TextFormField(
                controller: _storeIdController,
                decoration: const InputDecoration(labelText: 'Store ID'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              String? imageUrl;
              try {
                imageUrl = await _uploadImageAndGetUrl();
                if (imageUrl == null || imageUrl.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Image upload failed.')));
                  return;
                }
                Navigator.pop(context, {
                  'productName': _nameController.text,
                  'productImage': imageUrl,
                  'price': _priceController.text,
                  'discount': _discountController.text,
                  'productDescription': _descController.text,
                  'quantity': _quantityController.text,
                  'quantityType': _quantityTypeController.text,
                  'category': _categoryController.text,
                  'artist': _artistController.text,
                  'storeId': _storeIdController.text,
                  'deliveryDetails': {},
                  'extra': {},
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            }
          },
          child: Text(widget.product == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }
} 