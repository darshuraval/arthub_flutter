import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Unified cloud storage service for Supabase.
class CloudStorageService {
  static final _supabase = Supabase.instance.client;

  /// Uploads a file to Supabase Storage and returns the public URL.
  static Future<String?> uploadProductImage(File file) async {
    try {
      // Check if Supabase is initialized
      if (!(Supabase.instance.client.auth.currentSession?.isExpired ?? true)) {
        print('Supabase client is not initialized or session is expired');
        return null;
      }

      // Generate a unique file name using timestamp and original file name
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      
      print('Attempting to upload file: $fileName');
      
      // Upload the file to the 'product-images' bucket
      final response = await _supabase.storage
          .from('product-images')
          .upload(fileName, file);
      
      print('Upload response: $response');
      
      // Get the public URL for the uploaded file
      final publicUrl = _supabase.storage
          .from('product-images')
          .getPublicUrl(fileName);
      
      print('File uploaded successfully. URL: $publicUrl');
      return publicUrl;
    } catch (e) {
      print('Error uploading file to Supabase: $e');
      if (e is StorageException) {
        print('Storage error details: ${e.message}');
      }
      return null;
    }
  }

  /// Creates a product in Supabase.
  static Future<void> createProduct(Map<String, dynamic> productData) async {
    try {
      await _supabase.from('products').insert(productData);
    } catch (e) {
      throw Exception('Supabase create error: $e');
    }
  }

  /// Reads all products from Supabase.
  static Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      final data = await _supabase.from('products').select();
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      throw Exception('Supabase getProducts error: $e');
    }
  }

  /// Updates a product in Supabase. productId is the row id.
  static Future<void> updateProduct(dynamic productId, Map<String, dynamic> updates) async {
    try {
      await _supabase.from('products').update(updates).eq('id', productId);
    } catch (e) {
      throw Exception('Supabase update error: $e');
    }
  }

  /// Deletes a product in Supabase. productId is the row id.
  static Future<void> deleteProduct(dynamic productId) async {
    try {
      await _supabase.from('products').delete().eq('id', productId);
    } catch (e) {
      throw Exception('Supabase delete error: $e');
    }
  }

  /// Gets a single product by ID from Supabase.
  static Future<Map<String, dynamic>?> getProductById(dynamic productId) async {
    try {
      final data = await _supabase.from('products').select().eq('id', productId).single();
      return data as Map<String, dynamic>?;
    } catch (e) {
      throw Exception('Supabase getProductById error: $e');
    }
  }

  /// Deletes a file from Supabase Storage.
  static Future<void> deleteFile(String filePath) async {
    try {
      await _supabase.storage.from('product-images').remove([filePath]);
    } catch (e) {
      throw Exception('Supabase deleteFile error: $e');
    }
  }

  /// Gets a public URL for a file in Supabase Storage.
  static Future<String?> getPublicUrl(String filePath) async {
    try {
      return _supabase.storage.from('product-images').getPublicUrl(filePath);
    } catch (e) {
      print('Supabase getPublicUrl error: $e');
      return null;
    }
  }

  /// Lists all files in a storage bucket/folder in Supabase.
  static Future<List<String>> listFiles({String folder = 'product-images'}) async {
    try {
      final files = await _supabase.storage.from(folder).list();
      return files.map((item) => item.name).toList();
    } catch (e) {
      throw Exception('Supabase listFiles error: $e');
    }
  }
}


// // Upload to Supabase Storage
// final url = await CloudStorageService.uploadProductImage(file);

// // Create product in Supabase
// await CloudStorageService.createProduct(productData);

// // Get a product by ID from Supabase
// final product = await CloudStorageService.getProductById(123);

// // Delete a file from Supabase Storage
// await CloudStorageService.deleteFile('myfile.jpg');

// // List all files in a folder
// final files = await CloudStorageService.listFiles(folder: 'product-images');