import 'dart:async';

class StoreService {
  // In-memory storage for stores
  static final Map<String, Map<String, dynamic>> _stores = {};
  
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

    _stores[storeId] = store;
    return store;
  }

  // Get all stores
  Future<List<Map<String, dynamic>>> getAllStores() async {
    return _stores.values.toList();
  }

  // Get store by ID
  Future<Map<String, dynamic>?> getStoreById(String storeId) async {
    return _stores[storeId];
  }

  // Get stores by user ID
  Future<List<Map<String, dynamic>>> getStoresByUserId(String userId) async {
    return _stores.values.where((store) => store['userId'] == userId).toList();
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
    if (!_stores.containsKey(storeId)) {
      return null;
    }

    final store = _stores[storeId]!;
    
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
    
    _stores[storeId] = store;
    return store;
  }

  // Delete store
  Future<bool> deleteStore(String storeId) async {
    if (!_stores.containsKey(storeId)) {
      return false;
    }
    
    _stores.remove(storeId);
    return true;
  }

  // Search stores
  Future<List<Map<String, dynamic>>> searchStores(String query) async {
    query = query.toLowerCase();
    return _stores.values.where((store) {
      return store['storeName'].toString().toLowerCase().contains(query) ||
             store['city'].toString().toLowerCase().contains(query) ||
             store['state'].toString().toLowerCase().contains(query) ||
             store['country'].toString().toLowerCase().contains(query);
    }).toList();
  }

  // Get stores by type
  Future<List<Map<String, dynamic>>> getStoresByType(String storeType) async {
    return _stores.values.where((store) => store['storeType'] == storeType).toList();
  }

  // Get stores by status
  Future<List<Map<String, dynamic>>> getStoresByStatus(String status) async {
    return _stores.values.where((store) => store['status'] == status).toList();
  }

  // Get stores by location
  Future<List<Map<String, dynamic>>> getStoresByLocation({
    String? city,
    String? state,
    String? country,
  }) async {
    return _stores.values.where((store) {
      if (city != null && store['city'] != city) return false;
      if (state != null && store['state'] != state) return false;
      if (country != null && store['country'] != country) return false;
      return true;
    }).toList();
  }

  // Update store status
  Future<Map<String, dynamic>?> updateStoreStatus(String storeId, String status) async {
    return updateStore(storeId: storeId, status: status);
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