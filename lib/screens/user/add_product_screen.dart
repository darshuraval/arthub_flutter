import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:arthub_flutter/services/product_service.dart';
import 'package:arthub_flutter/services/cloud_storage_service.dart';
import 'package:flutter/foundation.dart'; 


class AddProductScreen extends StatefulWidget {
  final String storeId;
  const AddProductScreen({required this.storeId, Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  Uint8List? _webImageBytes;



  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _offerPriceController = TextEditingController();
  final _locationController = TextEditingController();
  final _descController = TextEditingController();
  final _conditionController = TextEditingController(text: 'Organic');
  final _priceTypeController = TextEditingController();
  final _quantityTypeController = TextEditingController();
  final _quantityController = TextEditingController();
  final _artistController = TextEditingController();
  List<String> _additionalDetails = ['Cash on delivery', 'Available'];
  List<XFile> _images = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final picked = await _picker.pickMultiImage();
    if (picked != null && picked.isNotEmpty) {
      setState(() {
        _images.addAll(picked.take(4 - _images.length));
      });
      if (kIsWeb && _images.isNotEmpty) {
        final bytes = await _images.first.readAsBytes();
        setState(() {
          _webImageBytes = bytes;
        });
      }
    }
  }

  void _removeImage(int idx) {
    setState(() {
      _images.removeAt(idx);
    });
  }

  Future<void> _addProduct() async {
    if (!_formKey.currentState!.validate()) return;
    String imageUrl = '';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      if (_images.isNotEmpty) {
        final image = _images.first;
        if (kIsWeb) {
          final bytes = await image.readAsBytes();
          final uploadedUrl = await CloudStorageService.uploadProductImageWeb(bytes);
          if (uploadedUrl != null) imageUrl = uploadedUrl;
        } else {
          final file = File(image.path);
          final uploadedUrl = await CloudStorageService.uploadProductImage(file);
          if (uploadedUrl != null) imageUrl = uploadedUrl;
        }
      }
      final deliveryDetails = {'location': _locationController.text};
      final extra = {'details': _additionalDetails};
      await ProductService().createProduct(
        storeId: widget.storeId,
        productName: _nameController.text.trim(),
        productImage: imageUrl,
        price: double.tryParse(_priceController.text) ?? 0,
        discount: double.tryParse(_offerPriceController.text),
        quantityType: _quantityTypeController.text.trim(),
        quantity: int.tryParse(_quantityController.text) ?? 1,
        category: _categoryController.text.trim(),
        artist: _artistController.text.trim(),
        deliveryDetails: deliveryDetails,
        productDescription: _descController.text.trim(),
        extra: extra,
        status: 'active',
      );
      if (mounted) {
        Navigator.of(context).pop(); 
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product added!')));
        Navigator.pop(context);
      }
    } catch (e) {
      Navigator.of(context).pop(); 
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }


  Widget _productCardPreview() {
    final imageWidget = _images.isNotEmpty
    ? ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: kIsWeb
            ? (_webImageBytes != null
                ? Image.memory(
                    _webImageBytes!,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : const SizedBox(height: 120)) 
            : Image.file(
                File(_images.first.path),
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
      )
    : ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Image.network(
          'https://yynwntzanqxcdihswljp.supabase.co/storage/v1/object/public/products//product_logo.png',
          height: 120,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageWidget,
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _nameController.text.isNotEmpty ? _nameController.text : 'Product Name',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  _artistController.text.isNotEmpty ? _artistController.text : '',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Text(
                  '₹${_priceController.text.isNotEmpty ? _priceController.text : '--'}',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF21967A)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF21967A),
        elevation: 0,
        title: const Text('Add Product', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _productCardPreview(),
              Row(
                children: [
                  GestureDetector(
                    onTap: _images.length < 4 ? _pickImages : null,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: _images.length < 4
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.add, size: 28, color: Colors.grey),
                                SizedBox(height: 6),
                                Text('Add', style: TextStyle(color: Colors.grey)),
                                Text('1600 x 1200 for hi res', style: TextStyle(fontSize: 8, color: Colors.grey)),
                              ],
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ..._images.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final img = entry.value;
                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[200],
                            image: DecorationImage(
                              image: FileImage(File(img.path)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _removeImage(idx),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: const Icon(Icons.close, size: 18, color: Colors.black54),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
              const SizedBox(height: 8),
              const Text('Max. 4 photos per product', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 18),
              _inputField('Product Name', _nameController),
              _inputField('Category', _categoryController),
              Row(
                children: [
                  Expanded(child: _inputField('Price', _priceController, prefix: '₹')),
                  const SizedBox(width: 12),
                  Expanded(child: _inputField('Offer Price', _offerPriceController, prefix: '₹')),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _inputField('Quantity', _quantityController)),
                  const SizedBox(width: 12),
                  Expanded(child: _inputField('Quantity Type', _quantityTypeController)),
                ],
              ),
              _inputField('Artist', _artistController),
              _inputField('Location Details', _locationController, suffix: Icons.map),
              _inputField('Product Description', _descController, maxLines: 3),
              const SizedBox(height: 12),
              _inputField('Condition', _conditionController, enabled: false),
              _inputField('Price Type', _priceTypeController),
              const SizedBox(height: 12),
              const Text('Additional Details', style: TextStyle(color: Colors.grey)),
              Wrap(
                spacing: 8,
                children: _additionalDetails
                    .map((d) => Chip(label: Text(d), onDeleted: () {
                          setState(() {
                            _additionalDetails.remove(d);
                          });
                        }))
                    .toList(),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF21967A),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _addProduct,
                  child: const Text('Add Product', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller, {bool enabled = true, String? prefix, IconData? suffix, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixText: prefix,
          suffixIcon: suffix != null ? Icon(suffix) : null,
          border: InputBorder.none,
          filled: true,
          fillColor: enabled ? Colors.white : Colors.grey[100],
        ),
        validator: (v) => (enabled && (v == null || v.isEmpty)) ? 'Required' : null,
      ),
    );
  }
}
