import 'package:flutter/material.dart';
import 'package:arthub_flutter/screens/admin/coupon_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF21967A),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Profile Page', style: TextStyle(fontSize: 24)),
            TextButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CouponsScreen()));
            }, child: Text('Coupon Management')),
          ],
        ),
      ),
    );
  }
}
