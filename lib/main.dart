import 'package:flutter/material.dart';
import 'package:arthub_flutter/config/app_styles.dart';
import 'package:arthub_flutter/screens/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:arthub_flutter/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:arthub_flutter/screens/auth/login_screen.dart';
import 'package:arthub_flutter/screens/admin/admin_home_screen.dart';
import 'package:arthub_flutter/test/widget_test_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  // Initialize Supabase with proper error handling
  try {
    await Supabase.initialize(
      url: 'https://yynwntzanqxcdihswljp.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl5bndudHphbnF4Y2RpaHN3bGpwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDczMzI0MTMsImV4cCI6MjA2MjkwODQxM30.gnTe49uBfb4fOeTxrJG6xp-LgERzPJ304vEg4bqg7SA',
      debug: true, // Enable debug mode to see more detailed error messages
    );
    print('Supabase initialized successfully');
  } catch (e) {
    print('Error initializing Supabase: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ArtHub',
      theme: ThemeData(
        primaryColor: const Color(0xFF2D9B88),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2D9B88),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      // home: const WidgetTestScreen(),
      // home: const AdminHomeScreen(),
      // home: const LoginScreen(),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
