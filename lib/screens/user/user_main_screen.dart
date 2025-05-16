import 'package:flutter/material.dart';
import 'user_home_screen.dart';
import 'browse_screen.dart';
import 'my_store_screen.dart';
import 'order_history_screen.dart';
import 'profile_screen.dart';
import 'package:arthub_flutter/services/auth_service.dart';
import 'package:arthub_flutter/screens/auth/login_screen.dart';
import 'package:arthub_flutter/screens/admin/admin_home_screen.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({Key? key}) : super(key: key);

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    UserHomeScreen(),
    BrowseScreen(),
    MyStoreScreen(),
    OrderHistoryScreen(),
    ProfileScreen(),
  ];

  final List<String> _titles = [
    'Arts',
    'Browse',
    'My Store',
    'Order History',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Color(0xFF21967A),
        elevation: 0,
        title: Text(_titles[_selectedIndex], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
            onPressed: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
              await AuthService().signOut();
            },
          ),
          if (_selectedIndex == 0) ...[
            IconButton(icon: Icon(Icons.favorite_border, color: Colors.white), onPressed: () {}),
            Stack(
              children: [
                IconButton(icon: Icon(Icons.shopping_cart_outlined, color: Colors.white), onPressed: () {}),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (_selectedIndex != 0) ...[
            IconButton(icon: Icon(Icons.favorite_border, color: Colors.white), onPressed: () {}),
            Stack(
              children: [
                IconButton(icon: Icon(Icons.shopping_cart_outlined, color: Colors.white), onPressed: () {}),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF21967A),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Browse'),
          BottomNavigationBarItem(icon: Icon(Icons.storefront), label: 'My Store'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Order History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}