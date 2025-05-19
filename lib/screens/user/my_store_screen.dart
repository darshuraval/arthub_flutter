import 'package:flutter/material.dart';
import 'package:arthub_flutter/screens/user/store_details_screen.dart';
import 'package:arthub_flutter/screens/user/store_form_screen.dart';
import 'package:arthub_flutter/services/store_service.dart';
import 'package:arthub_flutter/services/auth_service.dart';
import 'package:arthub_flutter/services/product_service.dart';
import 'package:arthub_flutter/screens/user/add_product_screen.dart';
import 'package:arthub_flutter/screens/user/store_form_screen.dart';
import 'package:arthub_flutter/screens/user/product_details_screen.dart';

class MyStoreScreen extends StatefulWidget {
  @override
  _MyStoreScreenState createState() => _MyStoreScreenState();
}

class _MyStoreScreenState extends State<MyStoreScreen> {
  @override
  void initState() {
    super.initState();
    _checkForExistingStore();
  }

  Future<void> _checkForExistingStore() async {
    setState(() => _loading = true);
    final user = AuthService().getCurrentUser();
    final userEmail = user?.email ?? '';
    if (userEmail.isEmpty) {
      setState(() => _loading = false);
      return;
    }
    final stores = await StoreService().getStoresByUserId(userEmail);
    setState(() => _loading = false);
    if (stores.isNotEmpty) {
      final userStore = stores.first;
      setState(() {
        _hasStore = true;
        _store = userStore;
      });
    }
  }
  bool _loading = false;
  bool _hasStore = false;
  Map<String, dynamic>? _store;
  List<Map<String, dynamic>> _products = [];

  void _showCreateStoreForm() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => StoreFormScreen(storeId: _store?['storeId'] ?? '', onStoreCreated: (store) {
          setState(() {
            _hasStore = true;
            _store = store;
          });
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    }
    if (!_hasStore) {
      return Scaffold(
        backgroundColor: Color(0xFFF6F6F6),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              Image.network('https://yynwntzanqxcdihswljp.supabase.co/storage/v1/object/public/products//store.png', height: 160),
              SizedBox(height: 24),
              Text('You Dont Have a Store', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF21967A),
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                onPressed: () {
                  _showCreateStoreForm();
                },
                child: Text('Create Store', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }
    final store = _store ?? {};
    final storeName = store['storeName'] ?? '';
    final storeId = store['storeId'] ?? '';
    final userName = storeName.isNotEmpty ? storeName : 'User Name';
    final avatarLetter = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: Color(0xFF21967A),
                    child: Text(
                      avatarLetter,
                      style: TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: Colors.black87),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => StoreFormScreen(
                              storeId: store['storeId'] ?? '',
                              onStoreCreated: (store) {
                                setState(() {
                                  _hasStore = true;
                                  _store = store;
                                });
                              },
                              initialStore: store,
                              readOnly: false,
                            ),
                          ));
                        },
                        child: const Text('Edit Store', style: TextStyle(color: Color(0xFF21967A))),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Color(0xFF21967A)),
                          shape: StadiumBorder(),
                          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                        ),
                      ),
                      const SizedBox(width: 18),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => StoreFormScreen(
                              storeId: store['storeId'] ?? '',
                              onStoreCreated: (_) {},
                              initialStore: store,
                              readOnly: true,
                            ),
                          ));
                        },
                        child: const Text('View Store', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF21967A),
                          shape: StadiumBorder(),
                          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: null,
                    child: Text('Remove  Store', style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: ProductService().getProductsByStoreId(storeId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: CircularProgressIndicator(),
                  );
                }
                final products = snapshot.data ?? [];
                if (products.isEmpty) {
                  return Column(
                    children: [
                      const SizedBox(height: 32),
                      const Text(
                        'You dont have product',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 28),
                      OutlinedButton(
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => AddProductScreen(storeId: storeId)),
                          );
                          setState(() {}); // Reload after returning from add product
                        },
                        child: const Text('Add Product', style: TextStyle(fontSize: 20, color: Color(0xFF21967A), fontWeight: FontWeight.bold)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Color(0xFF21967A)),
                          shape: StadiumBorder(),
                          padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  );
                }
                return Column(
                  children: [
                    OutlinedButton(
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => AddProductScreen(storeId: storeId)),
                        );
                        setState(() {}); // Reload after returning from add product
                      },
                      child: const Text('Add Product', style: TextStyle(fontSize: 20, color: Color(0xFF21967A), fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFF21967A)),
                        shape: StadiumBorder(),
                        padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                      ),
                    ),
                    const SizedBox(height: 32),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, idx) {
                        final p = products[idx];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                          child: Material(
                              color: Colors.transparent, 
                              child: InkWell(
                                onTap: () {
                                  print('Tapped!');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailsScreen(product: p),
                                    ),
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                      child: p['productImage'] != null && p['productImage'].toString().isNotEmpty
                                          ? Image.network(
                                              p['productImage'],
                                              height: 120,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Image.network(
                                                  'https://yynwntzanqxcdihswljp.supabase.co/storage/v1/object/public/products//product_logo.png',
                                                  height: 120,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                            )
                                          : Image.network(
                                              'https://yynwntzanqxcdihswljp.supabase.co/storage/v1/object/public/products//product_logo.png',
                                              height: 120,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            p['productName'] ?? '',
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            p['artist'] ?? '',
                                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            '₹${p['price'] != null ? p['price'].toString() : '--'}',
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF21967A)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 32),
                  ],
                );
              },
            ),
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
