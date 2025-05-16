import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Create a new address
  Future<Map<String, dynamic>> createAddress({
    required String userId,
    required String street,
    required String city,
    required String district,
    required String state,
    required String country,
    required String pincode,
    String? landmark,
    String status = 'active',
  }) async {
    final now = DateTime.now().toIso8601String();
    final addressId = DateTime.now().millisecondsSinceEpoch.toString();
    
    final address = {
      'addressId': addressId,
      'userId': userId,
      'street': street,
      'city': city,
      'district': district,
      'state': state,
      'country': country,
      'landmark': landmark,
      'pincode': pincode,
      'status': status,
      'created_at': now,
      'updated_at': now,
    };

    await _firestore.collection('addresses').doc(addressId).set(address);
    return address;
  }

  // Get all addresses
  Future<List<Map<String, dynamic>>> getAllAddresses() async {
    final querySnapshot = await _firestore.collection('addresses').get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Get address by ID
  Future<Map<String, dynamic>?> getAddressById(String addressId) async {
    final doc = await _firestore.collection('addresses').doc(addressId).get();
    return doc.exists ? doc.data() : null;
  }

  // Get addresses by user ID
  Future<List<Map<String, dynamic>>> getAddressesByUserId(String userId) async {
    final querySnapshot = await _firestore.collection('addresses').where('userId', isEqualTo: userId).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Update address
  Future<Map<String, dynamic>?> updateAddress({
    required String addressId,
    String? street,
    String? city,
    String? district,
    String? state,
    String? country,
    String? landmark,
    String? pincode,
    String? status,
  }) async {
    final doc = await _firestore.collection('addresses').doc(addressId).get();
    if (!doc.exists) {
      return null;
    }

    final address = doc.data()!;
    
    if (street != null) address['street'] = street;
    if (city != null) address['city'] = city;
    if (district != null) address['district'] = district;
    if (state != null) address['state'] = state;
    if (country != null) address['country'] = country;
    if (landmark != null) address['landmark'] = landmark;
    if (pincode != null) address['pincode'] = pincode;
    if (status != null) address['status'] = status;
    
    address['updated_at'] = DateTime.now().toIso8601String();
    
    await _firestore.collection('addresses').doc(addressId).update(address);
    return address;
  }

  // Delete address
  Future<bool> deleteAddress(String addressId) async {
    final doc = await _firestore.collection('addresses').doc(addressId).get();
    if (!doc.exists) {
      return false;
    }
    
    await _firestore.collection('addresses').doc(addressId).delete();
    return true;
  }

  // Search addresses
  Future<List<Map<String, dynamic>>> searchAddresses(String query) async {
    query = query.toLowerCase();
    final querySnapshot = await _firestore.collection('addresses').get();
    return querySnapshot.docs
        .map((doc) => doc.data())
        .where((address) =>
          (address['street']?.toString().toLowerCase().contains(query) ?? false) ||
          (address['city']?.toString().toLowerCase().contains(query) ?? false) ||
          (address['district']?.toString().toLowerCase().contains(query) ?? false) ||
          (address['state']?.toString().toLowerCase().contains(query) ?? false) ||
          (address['country']?.toString().toLowerCase().contains(query) ?? false) ||
          (address['pincode']?.toString().toLowerCase().contains(query) ?? false)
        )
        .toList();
  }

  // Get addresses by city
  Future<List<Map<String, dynamic>>> getAddressesByCity(String city) async {
    final querySnapshot = await _firestore.collection('addresses').where('city', isEqualTo: city).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Get addresses by state
  Future<List<Map<String, dynamic>>> getAddressesByState(String state) async {
    final querySnapshot = await _firestore.collection('addresses').where('state', isEqualTo: state).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Get addresses by country
  Future<List<Map<String, dynamic>>> getAddressesByCountry(String country) async {
    final querySnapshot = await _firestore.collection('addresses').where('country', isEqualTo: country).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Get addresses by pincode
  Future<List<Map<String, dynamic>>> getAddressesByPincode(String pincode) async {
    final querySnapshot = await _firestore.collection('addresses').where('pincode', isEqualTo: pincode).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Get addresses by status
  Future<List<Map<String, dynamic>>> getAddressesByStatus(String status) async {
    final querySnapshot = await _firestore.collection('addresses').where('status', isEqualTo: status).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Update address status
  Future<Map<String, dynamic>?> updateAddressStatus(String addressId, String status) async {
    return updateAddress(addressId: addressId, status: status);
  }

  // Get addresses by location
  Future<List<Map<String, dynamic>>> getAddressesByLocation({
    String? city,
    String? state,
    String? country,
    String? pincode,
  }) async {
    final querySnapshot = await _firestore.collection('addresses').where('city', isEqualTo: city).where('state', isEqualTo: state).where('country', isEqualTo: country).where('pincode', isEqualTo: pincode).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Get address statistics
  Future<Map<String, dynamic>> getAddressStatistics() async {
    final querySnapshot = await _firestore.collection('addresses').get();
    final totalAddresses = querySnapshot.docs.length;
    final activeAddresses = querySnapshot.docs.where((doc) => doc['status'] == 'active').length;
    final inactiveAddresses = querySnapshot.docs.where((doc) => doc['status'] == 'inactive').length;
    
    final cities = querySnapshot.docs.map((doc) => doc['city']).toSet().length;
    final states = querySnapshot.docs.map((doc) => doc['state']).toSet().length;
    final countries = querySnapshot.docs.map((doc) => doc['country']).toSet().length;

    return {
      'totalAddresses': totalAddresses,
      'activeAddresses': activeAddresses,
      'inactiveAddresses': inactiveAddresses,
      'uniqueCities': cities,
      'uniqueStates': states,
      'uniqueCountries': countries,
    };
  }

  // Validate address
  Future<bool> validateAddress(String addressId) async {
    final doc = await _firestore.collection('addresses').doc(addressId).get();
    if (!doc.exists) return false;

    // Check if all required fields are present and not empty
    return doc['street']?.isNotEmpty == true &&
           doc['city']?.isNotEmpty == true &&
           doc['district']?.isNotEmpty == true &&
           doc['state']?.isNotEmpty == true &&
           doc['country']?.isNotEmpty == true &&
           doc['pincode']?.isNotEmpty == true;
  }
} 

// {
//   'addressId': String,
//   'userId': String,
//   'street': String,
//   'city': String,
//   'district': String,
//   'state': String,
//   'country': String,
//   'landmark': String?,
//   'pincode': String,
//   'status': String,
//   'created_at': String (ISO8601 timestamp),
//   'updated_at': String (ISO8601 timestamp)
// }

// final addressService = AddressService();

// // Create an address
// await addressService.createAddress(
//   userId: 'user123',
//   street: '123 Main St',
//   city: 'New York',
//   district: 'Manhattan',
//   state: 'NY',
//   country: 'USA',
//   pincode: '10001',
//   landmark: 'Near Central Park'
// );

// // Get all addresses
// final addresses = await addressService.getAllAddresses();

// // Update an address
// await addressService.updateAddress(
//   addressId: 'address123',
//   street: '456 New St',
//   status: 'inactive'
// );

// // Get addresses by location
// final nyAddresses = await addressService.getAddressesByLocation(
//   city: 'New York',
//   state: 'NY'
// );

// // Get address statistics
// final stats = await addressService.getAddressStatistics();

// // Delete an address
// await addressService.deleteAddress('address123');