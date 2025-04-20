import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arthub_flutter/config/app_styles.dart';
import 'package:arthub_flutter/screens/main_screen.dart';
import 'package:arthub_flutter/models/settings_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsModel(),
      child: MaterialApp(
        title: 'ArtHub',
        theme: ThemeData(
          primaryColor: AppStyles.primaryColor,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppStyles.primaryColor,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const MainScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}