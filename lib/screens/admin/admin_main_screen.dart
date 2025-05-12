import 'package:arthub_flutter/services/auth_functions.dart';
import 'package:flutter/material.dart';
import 'package:arthub_flutter/services/auth_service.dart';
import 'package:arthub_flutter/screens/auth/login_screen.dart';
import 'package:arthub_flutter/screens/user/user_main_screen.dart';
import 'package:arthub_flutter/screens/admin/admin_home_screen.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({Key? key}) : super(key: key);

  @override
  _AdminMainScreenState createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
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
      ),
    );
  }
}
