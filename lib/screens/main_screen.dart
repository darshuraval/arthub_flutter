import 'package:flutter/material.dart';
import 'package:arthub_flutter/services/auth_service.dart';
import 'package:arthub_flutter/screens/auth/login_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AuthService().getCurrentUser()!.email!),
            TextButton(onPressed: () {
              AuthService().signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            }, child: Text('Sign Out')),
          ],
        ),
      ),
    );
  }
}
