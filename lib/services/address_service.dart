import 'dart:async';

class AddressService {
  // In-memory storage for addresses
  static final Map<String, Map<String, dynamic>> _addresses = {};
  
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

    _addresses[addressId] = address;
    return address;
  }

  // Get all addresses
  Future<List<Map<String, dynamic>>> getAllAddresses() async {
    return _addresses.values.toList();
  }

  // Get address by ID
  Future<Map<String, dynamic>?> getAddressById(String addressId) async {
    return _addresses[addressId];
  }

  // Get addresses by user ID
  Future<List<Map<String, dynamic>>> getAddressesByUserId(String userId) async {
    return _addresses.values.where((address) => address['userId'] == userId).toList();
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
    if (!_addresses.containsKey(addressId)) {
      return null;
    }

    final address = _addresses[addressId]!;
    
    if (street != null) address['street'] = street;
    if (city != null) address['city'] = city;
    if (district != null) address['district'] = district;
    if (state != null) address['state'] = state;
    if (country != null) address['country'] = country;
    if (landmark != null) address['landmark'] = landmark;
    if (pincode != null) address['pincode'] = pincode;
    if (status != null) address['status'] = status;
    
    address['updated_at'] = DateTime.now().toIso8601String();
    
    _addresses[addressId] = address;
    return address;
  }

  // Delete address
  Future<bool> deleteAddress(String addressId) async {
    if (!_addresses.containsKey(addressId)) {
      return false;
    }
    
    _addresses.remove(addressId);
    return true;
  }

  // Search addresses
  Future<List<Map<String, dynamic>>> searchAddresses(String query) async {
    query = query.toLowerCase();
    return _addresses.values.where((address) {
      return address['street'].toString().toLowerCase().contains(query) ||
             address['city'].toString().toLowerCase().contains(query) ||
             address['district'].toString().toLowerCase().contains(query) ||
             address['state'].toString().toLowerCase().contains(query) ||
             address['country'].toString().toLowerCase().contains(query) ||
             address['pincode'].toString().toLowerCase().contains(query);
    }).toList();
  }

  // Get addresses by city
  Future<List<Map<String, dynamic>>> getAddressesByCity(String city) async {
    return _addresses.values.where((address) => address['city'] == city).toList();
  }

  // Get addresses by state
  Future<List<Map<String, dynamic>>> getAddressesByState(String state) async {
    return _addresses.values.where((address) => address['state'] == state).toList();
  }

  // Get addresses by country
  Future<List<Map<String, dynamic>>> getAddressesByCountry(String country) async {
    return _addresses.values.where((address) => address['country'] == country).toList();
  }

  // Get addresses by pincode
  Future<List<Map<String, dynamic>>> getAddressesByPincode(String pincode) async {
    return _addresses.values.where((address) => address['pincode'] == pincode).toList();
  }

  // Get addresses by status
  Future<List<Map<String, dynamic>>> getAddressesByStatus(String status) async {
    return _addresses.values.where((address) => address['status'] == status).toList();
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
    return _addresses.values.where((address) {
      if (city != null && address['city'] != city) return false;
      if (state != null && address['state'] != state) return false;
      if (country != null && address['country'] != country) return false;
      if (pincode != null && address['pincode'] != pincode) return false;
      return true;
    }).toList();
  }

  // Get address statistics
  Future<Map<String, dynamic>> getAddressStatistics() async {
    final totalAddresses = _addresses.length;
    final activeAddresses = _addresses.values.where((a) => a['status'] == 'active').length;
    final inactiveAddresses = _addresses.values.where((a) => a['status'] == 'inactive').length;
    
    final cities = _addresses.values.map((a) => a['city']).toSet().length;
    final states = _addresses.values.map((a) => a['state']).toSet().length;
    final countries = _addresses.values.map((a) => a['country']).toSet().length;

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
    final address = await getAddressById(addressId);
    if (address == null) return false;

    // Check if all required fields are present and not empty
    return address['street']?.isNotEmpty == true &&
           address['city']?.isNotEmpty == true &&
           address['district']?.isNotEmpty == true &&
           address['state']?.isNotEmpty == true &&
           address['country']?.isNotEmpty == true &&
           address['pincode']?.isNotEmpty == true;
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