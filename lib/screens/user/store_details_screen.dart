import 'package:flutter/material.dart';
import 'package:arthub_flutter/screens/user/my_store_screen.dart';

class StoreDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> store;
  const StoreDetailsScreen({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Image.network('https://yynwntzanqxcdihswljp.supabase.co/storage/v1/object/public/products//store.png', height: 140),
                  const SizedBox(height: 16),
                  const Text(
                    'This information is used to set up your shop',
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _infoField('Store Name', store['storeName']),
            _infoField('Store Web Address', store['website']),
            _infoField('Store Description', store['description']),
            _infoField('Store Type', store['storeType']),
            _infoField('Address', store['address']),
            _infoField('City', store['city']),
            _infoField('State', store['state']),
            _infoField('Country', store['country']),
            _infoField('Pincode', store['pincode']),
            _infoField('User ID (Email)', store['userId']),
            _infoField('Store ID', store['storeId']),
            _infoField('Status', store['status']),
            _infoField('Created At', store['created_at']),
            _infoField('Updated At', store['updated_at']),
          ],
        ),
      ),
    );
  }

  Widget _infoField(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 2),
          Text(value?.toString() ?? '', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
