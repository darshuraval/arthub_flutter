import 'package:flutter/material.dart';
import 'package:arthub_flutter/screens/admin/coupon_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Profile Screen', style: TextStyle(fontSize: 24)),
          TextButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CouponsScreen()));
          }, child: Text('Coupon Management')),
          TextButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()));
          }, child: Text('Setting')),
        ],
      ),
    );
  }
} 

