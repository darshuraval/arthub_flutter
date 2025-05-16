import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new store
  Future<Map<String, dynamic>> createStore({
    required String userId,
    required String storeName,
    required String storeType,
    required String address,
    required String city,
    required String state,
    required String country,
    required String pincode,
    String? website,
    String? description,
    String status = 'active',
  }) async {
    final now = DateTime.now().toIso8601String();
    final storeId = DateTime.now().millisecondsSinceEpoch.toString();
    
    final store = {
      'storeId': storeId,
      'userId': userId,
      'storeName': storeName,
      'website': website,
      'description': description,
      'storeType': storeType,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'pincode': pincode,
      'status': status,
      'created_at': now,
      'updated_at': now,
    };

    await _firestore.collection('stores').doc(storeId).set(store);
    return store;
  }

  // Get all stores
  Future<List<Map<String, dynamic>>> getAllStores() async {
    final querySnapshot = await _firestore.collection('stores').get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Get store by ID
  Future<Map<String, dynamic>?> getStoreById(String storeId) async {
    final doc = await _firestore.collection('stores').doc(storeId).get();
    return doc.exists ? doc.data() : null;
  }

  // Get stores by user ID
  Future<List<Map<String, dynamic>>> getStoresByUserId(String userId) async {
    final querySnapshot = await _firestore.collection('stores').where('userId', isEqualTo: userId).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Update store
  Future<Map<String, dynamic>?> updateStore({
    required String storeId,
    String? storeName,
    String? website,
    String? description,
    String? storeType,
    String? address,
    String? city,
    String? state,
    String? country,
    String? pincode,
    String? status,
  }) async {
    final doc = await _firestore.collection('stores').doc(storeId).get();
    if (!doc.exists) return null;
    final store = doc.data()!;
    if (storeName != null) store['storeName'] = storeName;
    if (website != null) store['website'] = website;
    if (description != null) store['description'] = description;
    if (storeType != null) store['storeType'] = storeType;
    if (address != null) store['address'] = address;
    if (city != null) store['city'] = city;
    if (state != null) store['state'] = state;
    if (country != null) store['country'] = country;
    if (pincode != null) store['pincode'] = pincode;
    if (status != null) store['status'] = status;
    
    store['updated_at'] = DateTime.now().toIso8601String();
    
    await _firestore.collection('stores').doc(storeId).set(store);
    return store;
  }

  // Delete store
  Future<bool> deleteStore(String storeId) async {
    final doc = await _firestore.collection('stores').doc(storeId).get();
    if (!doc.exists) return false;
    await doc.reference.delete();
    return true;
  }

  // Search stores
  Future<List<Map<String, dynamic>>> searchStores(String query) async {
    query = query.toLowerCase();
    final querySnapshot = await _firestore.collection('stores').where('storeName', isEqualTo: query).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Get stores by type
  Future<List<Map<String, dynamic>>> getStoresByType(String storeType) async {
    final querySnapshot = await _firestore.collection('stores').where('storeType', isEqualTo: storeType).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Get stores by status
  Future<List<Map<String, dynamic>>> getStoresByStatus(String status) async {
    final querySnapshot = await _firestore.collection('stores').where('status', isEqualTo: status).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Get stores by location
  Future<List<Map<String, dynamic>>> getStoresByLocation({
    String? city,
    String? state,
    String? country,
  }) async {
    final querySnapshot = await _firestore.collection('stores').where('city', isEqualTo: city).where('state', isEqualTo: state).where('country', isEqualTo: country).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Update store status
  Future<Map<String, dynamic>?> updateStoreStatus(String storeId, String status) async {
    final doc = await _firestore.collection('stores').doc(storeId).get();
    if (!doc.exists) return null;
    final store = doc.data()!;
    store['status'] = status;
    store['updated_at'] = DateTime.now().toIso8601String();
    await doc.reference.update(store);
    return store;
  }
} 



// {
//   'storeId': String,
//   'userId': String,
//   'storeName': String,
//   'website': String?,
//   'description': String?,
//   'storeType': String,
//   'address': String,
//   'city': String,
//   'state': String,
//   'country': String,
//   'pincode': String,
//   'status': String,
//   'created_at': String (ISO8601 timestamp),
//   'updated_at': String (ISO8601 timestamp)
// }

// final storeService = StoreService();

// // Create a store
// await storeService.createStore(
//   userId: 'user123',
//   storeName: 'My Store',
//   storeType: 'retail',
//   address: '123 Main St',
//   city: 'New York',
//   state: 'NY',
//   country: 'USA',
//   pincode: '10001',
//   website: 'www.mystore.com',
//   description: 'A great store'
// );

// // Get all stores
// final stores = await storeService.getAllStores();

// // Update a store
// await storeService.updateStore(
//   storeId: 'store123',
//   storeName: 'Updated Store Name',
//   status: 'inactive'
// );

// // Delete a store
// await storeService.deleteStore('store123');