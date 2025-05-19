import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  const GoogleSignInButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        side: const BorderSide(color: Colors.grey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      icon: Image.network('https://yynwntzanqxcdihswljp.supabase.co/storage/v1/object/public/products//google_logo.png', height: 24), // Add your Google logo asset
      label: const Text('Sign in with Google'),
      onPressed: onPressed,
    );
  }
}
