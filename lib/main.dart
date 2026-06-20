import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'home_screen.dart';

void main() async {
  // Ensure Flutter bindings are initialized before Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase for the web
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    providerWeb: ReCaptchaEnterpriseProvider('6LevJyotAAAAAHMevD9bHqZBMhcn4CkpyK8Y0rUM'),
  );

  runApp(const PotlyWaitlistApp());
}

class PotlyWaitlistApp extends StatelessWidget {
  const PotlyWaitlistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Potly - Saving Circles',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        // Deep dark teal/navy background matching your app
        scaffoldBackgroundColor: const Color(0xFF041421),
        primaryColor: const Color(0xFF13F3C6), // Neon Cyan
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF13F3C6),
          secondary: Color(0xFF13F3C6),
          surface: Color(0xFF0A2239), // Slightly lighter for cards
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white70),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}