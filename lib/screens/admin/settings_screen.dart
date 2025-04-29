import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:arthub_flutter/screens/main_screen.dart';
import 'package:arthub_flutter/config/app_styles.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Settings'),
        backgroundColor: AppStyles.primaryColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader('Account'),
          _buildSettingTile(
            'Switch to User View',
            Icons.home,
            () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
              );
            },
          ),
          _buildSettingTile(
            'Logout',
            Icons.logout,
            () async {
              await FirebaseAuth.instance.signOut();
              // TODO: Navigate to login screen
            },
          ),
          const Divider(),
          _buildSectionHeader('App Settings'),
          _buildSettingTile(
            'Manage Categories',
            Icons.category,
            () {
              // TODO: Navigate to category management
            },
          ),
          _buildSettingTile(
            'Manage Payment Methods',
            Icons.payment,
            () {
              // TODO: Navigate to payment methods management
            },
          ),
          _buildSettingTile(
            'Manage Shipping Options',
            Icons.local_shipping,
            () {
              // TODO: Navigate to shipping options management
            },
          ),
          const Divider(),
          _buildSectionHeader('System'),
          _buildSettingTile(
            'Backup & Restore',
            Icons.backup,
            () {
              // TODO: Show backup options
            },
          ),
          _buildSettingTile(
            'System Logs',
            Icons.history,
            () {
              // TODO: Show system logs
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildSettingTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppStyles.primaryColor),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
} 