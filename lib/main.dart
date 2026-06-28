import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';


void main() async {
  // Ensure Flutter bindings are initialized before Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase for the web
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    providerWeb: ReCaptchaEnterpriseProvider('6LevJyotAAAAAOHs9mncz2DEIcvb8jeLdoVHxjgG'),
  );


  runApp(const PotlyWaitlistApp());
}

class PotlyWaitlistApp extends StatefulWidget {
  const PotlyWaitlistApp({super.key});

  // This helper method allows children to find the state and call setLocale
  static _PotlyWaitlistAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_PotlyWaitlistAppState>();

  @override
  State<PotlyWaitlistApp> createState() => _PotlyWaitlistAppState();
}

class _PotlyWaitlistAppState extends State<PotlyWaitlistApp> {
  Locale? _locale;

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('de'),
      ],
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