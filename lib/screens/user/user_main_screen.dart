import 'package:arthub_flutter/services/auth_functions.dart';
import 'package:flutter/material.dart';
import 'package:arthub_flutter/services/auth_service.dart';
import 'package:arthub_flutter/screens/auth/login_screen.dart';
import 'package:arthub_flutter/screens/admin/admin_main_screen.dart';
import 'package:arthub_flutter/screens/user/user_home_screen.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({Key? key}) : super(key: key);

  _UserMainScreenState createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => UserHomeScreen()));
                },
                child: Text('User Home Page')
            ),
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
                    child: Text('Go to Admin MainScreen'),
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
