import 'dart:io';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Unified cloud storage service for Supabase.
class CloudStorageService {
  static final _supabase = Supabase.instance.client;

  // static Future<String?> uploadProductImageWeb(Uint8List bytes) async {
  //   return "https://letsenhance.io/blog/content/images/size/w2000/2025/04/Thumbnail_LE_upscale_strong_x2-1.jpg";
  // }


  static Future<String?> uploadProductImageWeb(Uint8List bytes) async {
    try {
      // Check if Supabase is initialized
      if (!(Supabase.instance.client.auth.currentSession?.isExpired ?? true)) {
        await Supabase.initialize(
          url: 'https://yynwntzanqxcdihswljp.supabase.co',
          anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl5bndudHphbnF4Y2RpaHN3bGpwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDczMzI0MTMsImV4cCI6MjA2MjkwODQxM30.gnTe49uBfb4fOeTxrJG6xp-LgERzPJ304vEg4bqg7SA',
          debug: true, // Enable debug mode to see more detailed error messages
        );
        print('Supabase initialized successfully');
      }

      // Generate a unique file name
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_web_upload.png';

      print('Attempting to upload file (web): $fileName');

      // Upload the bytes to the 'products' bucket
      final response = await _supabase.storage
          .from('products')
          .uploadBinary(fileName, bytes);

      print('Upload response: $response');

      // Get the public URL for the uploaded file
      final publicUrl = _supabase.storage
          .from('products')
          .getPublicUrl(fileName);

      print('File uploaded successfully. URL: $publicUrl');
      return publicUrl;
    } catch (e) {
      print('Error uploading file to Supabase (web): $e');
      return null;
    }
  }

  /// Uploads a file to Supabase Storage and returns the public URL.
  static Future<String?> uploadProductImage(File file) async {
    try {
      // Check if Supabase is initialized
      if (Supabase.instance.client.auth.currentSession == null ||
    Supabase.instance.client.auth.currentSession!.isExpired) {
  print('Supabase client is not initialized or session is expired');
  return null;
}

      // Generate a unique file name using timestamp and original file name
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      
      print('Attempting to upload file: $fileName');
      
      // Upload the file to the 'products' bucket
      final response = await _supabase.storage
          .from('products')
          .upload(fileName, file);
      
      print('Upload response: $response');
      
      // Get the public URL for the uploaded file
      final publicUrl = _supabase.storage
          .from('products')
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
      await _supabase.storage.from('products').remove([filePath]);
    } catch (e) {
      throw Exception('Supabase deleteFile error: $e');
    }
  }

  /// Gets a public URL for a file in Supabase Storage.
  static Future<String?> getPublicUrl(String filePath) async {
    try {
      return _supabase.storage.from('products').getPublicUrl(filePath);
    } catch (e) {
      print('Supabase getPublicUrl error: $e');
      return null;
    }
  }

  /// Lists all files in a storage bucket/folder in Supabase.
  static Future<List<String>> listFiles({String folder = 'products'}) async {
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
// final files = await CloudStorageService.listFiles(folder: 'products');