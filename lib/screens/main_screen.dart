import 'package:arthub_flutter/screens/admin/admin_home_screen.dart';
import 'package:arthub_flutter/screens/admin/admin_main_screen.dart';
import 'package:arthub_flutter/services/auth_functions.dart';
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
            FutureBuilder<String?>(
              future: AuthFunctions().getUserRole(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox.shrink(); // or a loader if you want
                }
                if (snapshot.data == 'admin') {
                  return TextButton(
                    onPressed: () async {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => AdminMainScreen()),
                      );
                    },
                    child: Text('Go to Admin Home'),
                  );
                }
                return SizedBox.shrink(); // Don't show the button for non-admins
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
