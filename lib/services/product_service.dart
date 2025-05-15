import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // In-memory storage for products
  static final Map<String, Map<String, dynamic>> _products = {};
  
  // Create a new product
  Future<Map<String, dynamic>> createProduct({
    required String storeId,
    required String productName,
    required String productImage,
    required double price,
    required String quantityType,
    required int quantity,
    required String category,
    required String artist,
    required Map<String, dynamic> deliveryDetails,
    double? discount,
    String? productDescription,
    Map<String, dynamic>? extra,
    String status = 'active',
  }) async {
    final now = FieldValue.serverTimestamp();
    final docRef = _firestore.collection('products').doc();
    final product = {
      'productId': docRef.id,
      'storeId': storeId,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'discount': discount,
      'productDescription': productDescription,
      'quantityType': quantityType,
      'quantity': quantity,
      'category': category,
      'artist': artist,
      'extra': extra ?? {},
      'deliveryDetails': deliveryDetails,
      'status': status,
      'created_at': now,
      'modified_at': now,
    };
    print('Creating product: $product');
    try {
      await docRef.set(product);
      print('Product created!');
      return product;
    } catch (e, st) {
      print('Error creating product: $e\n$st');
      rethrow;
    }
  }

  // Get all products
  Future<List<Map<String, dynamic>>> getAllProducts() async {
    final querySnapshot = await _firestore.collection('products').get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<Map<String, dynamic>?> getProductById(String productId) async {
    final doc = await _firestore.collection('products').doc(productId).get();
    return doc.exists ? doc.data() : null;
  }


  Future<List<Map<String, dynamic>>> getProductsByStoreId(String storeId) async {
    final querySnapshot = await _firestore
      .collection('products')
      .where('storeId', isEqualTo: storeId)
      .get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }


  // Get products by category
  Future<List<Map<String, dynamic>>> getProductsByCategory(String category) async {
    return _products.values.where((product) => product['category'] == category).toList();
  }

  // Get products by artist
  Future<List<Map<String, dynamic>>> getProductsByArtist(String artist) async {
    return _products.values.where((product) => product['artist'] == artist).toList();
  }

  // Update product
  Future<Map<String, dynamic>?> updateProduct({
    required String productId,
    String? productName,
    String? productImage,
    double? price,
    double? discount,
    String? productDescription,
    String? quantityType,
    int? quantity,
    String? category,
    String? artist,
    Map<String, dynamic>? extra,
    Map<String, dynamic>? deliveryDetails,
    String? status,
  }) async {
    final docRef = _firestore.collection('products').doc(productId);
    final updates = <String, dynamic>{
      'modified_at': FieldValue.serverTimestamp(),
    };
    if (productName != null) updates['productName'] = productName;
    if (productImage != null) updates['productImage'] = productImage;
    if (price != null) updates['price'] = price;
    if (discount != null) updates['discount'] = discount;
    if (productDescription != null) updates['productDescription'] = productDescription;
    if (quantityType != null) updates['quantityType'] = quantityType;
    if (quantity != null) updates['quantity'] = quantity;
    if (category != null) updates['category'] = category;
    if (artist != null) updates['artist'] = artist;
    if (extra != null) updates['extra'] = extra;
    if (deliveryDetails != null) updates['deliveryDetails'] = deliveryDetails;
    if (status != null) updates['status'] = status;

    await docRef.update(updates);
    final updatedDoc = await docRef.get();
    return updatedDoc.data();
  }

  // Delete product
  Future<bool> deleteProduct(String productId) async {
    final docRef = _firestore.collection('products').doc(productId);
    await docRef.delete();
    return true;
  }

  // Search products
  Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    query = query.toLowerCase();
    return _products.values.where((product) {
      return product['productName'].toString().toLowerCase().contains(query) ||
             product['category'].toString().toLowerCase().contains(query) ||
             product['artist'].toString().toLowerCase().contains(query);
    }).toList();
  }

  // Get products by price range
  Future<List<Map<String, dynamic>>> getProductsByPriceRange({
    required double minPrice,
    required double maxPrice,
  }) async {
    return _products.values.where((product) {
      final price = product['price'] as double;
      return price >= minPrice && price <= maxPrice;
    }).toList();
  }

  // Get products by status
  Future<List<Map<String, dynamic>>> getProductsByStatus(String status) async {
    return _products.values.where((product) => product['status'] == status).toList();
  }

  // Update product status
  Future<Map<String, dynamic>?> updateProductStatus(String productId, String status) async {
    return updateProduct(productId: productId, status: status);
  }

  // Update product quantity
  Future<Map<String, dynamic>?> updateProductQuantity(String productId, int quantity) async {
    return updateProduct(productId: productId, quantity: quantity);
  }

  // Update product price
  Future<Map<String, dynamic>?> updateProductPrice(String productId, double price) async {
    return updateProduct(productId: productId, price: price);
  }

  // Update product discount
  Future<Map<String, dynamic>?> updateProductDiscount(String productId, double discount) async {
    return updateProduct(productId: productId, discount: discount);
  }
}




// {
//   'productId': String,
//   'storeId': String,
//   'productName': String,
//   'productImage': String,
//   'price': double,
//   'discount': double?,
//   'productDescription': String?,
//   'quantityType': String,
//   'quantity': int,
//   'category': String,
//   'artist': String,
//   'extra': Map<String, dynamic>?,
//   'deliveryDetails': Map<String, dynamic>,
//   'status': String,
//   'created_at': String (ISO8601 timestamp),
//   'modified_at': String (ISO8601 timestamp)
// }

// final productService = ProductService();

// // Create a product
// await productService.createProduct(
//   storeId: 'store123',
//   productName: 'Art Print',
//   productImage: 'image_url',
//   price: 99.99,
//   quantityType: 'piece',
//   quantity: 10,
//   category: 'Prints',
//   artist: 'John Doe',
//   deliveryDetails: {
//     'shippingMethod': 'Standard',
//     'deliveryTime': '3-5 days',
//     'shippingCost': 5.99
//   },
//   discount: 10.0,
//   productDescription: 'Beautiful art print',
//   extra: {
//     'size': 'A4',
//     'material': 'Premium Paper'
//   }
// );

// // Get all products
// final products = await productService.getAllProducts();

// // Update a product
// await productService.updateProduct(
//   productId: 'product123',
//   productName: 'Updated Product Name',
//   price: 89.99,
//   status: 'inactive'
// );

// // Delete a product
// await productService.deleteProduct('product123');