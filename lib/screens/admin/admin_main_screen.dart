import 'package:arthub_flutter/services/auth_functions.dart';
import 'package:flutter/material.dart';
import 'package:arthub_flutter/services/auth_service.dart';
import 'package:arthub_flutter/screens/auth/login_screen.dart';
<<<<<<< HEAD
import 'package:arthub_flutter/screens/user/user_main_screen.dart';
import 'package:arthub_flutter/screens/admin/admin_home_screen.dart';
=======
import 'package:arthub_flutter/screens/admin/user_management_screen.dart';
import 'package:arthub_flutter/screens/admin/product_management_screen.dart';
import 'package:arthub_flutter/screens/admin/order_management_screen.dart';
import 'package:arthub_flutter/screens/admin/dashboard_screen.dart';
import 'package:arthub_flutter/screens/admin/settings_screen.dart';
import 'package:arthub_flutter/config/app_styles.dart';
>>>>>>> 65a4c29d72f1b17a0be0faadec197fb304ed9c52

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({Key? key}) : super(key: key);

  @override
  _AdminMainScreenState createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
<<<<<<< HEAD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  AuthService().signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => AdminHomeScreen()));
                },
                child: Text('Admin Home Page')
            ),
            Text(AuthService().getCurrentUser()!.email!),
            FutureBuilder<String?>(
              future: AuthFunctions().getUserRole(),
              builder: (context, snapshot) {
                return TextButton(
                    onPressed: () async {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => UserMainScreen()),
                      );
                    },
                    child: Text('Go to User MainScreen'),
                  );
              },
            ),
            TextButton(
                onPressed: () {
                  AuthService().signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text('Log Out')),
          ],
        ),
=======
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const UserManagementScreen(),
    const ProductManagementScreen(),
    const OrderManagementScreen(),
    const AdminSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppStyles.primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.art_track),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
>>>>>>> 65a4c29d72f1b17a0be0faadec197fb304ed9c52
      ),
    );
  }
}
