import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arthub_flutter/config/app_styles.dart';
import 'package:arthub_flutter/screens/main_screen.dart';
import 'package:arthub_flutter/models/settings_model.dart';
import 'package:arthub_flutter/providers/checkout_provider.dart';
import './screens/splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsModel()),
        ChangeNotifierProvider(create: (_) => CheckoutProvider()),
      ],
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
        // home: const MainScreen(),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}