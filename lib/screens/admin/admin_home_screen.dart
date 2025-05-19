import 'package:flutter/material.dart';
import 'users_screen.dart';
import 'products_screen.dart';
import 'store_screen.dart';
import 'orders_screen.dart';
import 'payments_screen.dart';
import 'address_screen.dart';
import 'profile_screen.dart';
import 'package:arthub_flutter/services/auth_service.dart';
import 'package:arthub_flutter/screens/auth/login_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const UsersScreen(),
    const ProductsScreen(),
    const StoreScreen(),
    const OrdersScreen(),
    const PaymentsScreen(),
    const AddressScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthService().signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory),
            label: 'Products',
          ),
          NavigationDestination(
            icon: Icon(Icons.store),
            label: 'Store',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.payment),
            label: 'Payments',
          ),
          NavigationDestination(
            icon: Icon(Icons.location_on),
            label: 'Address',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}