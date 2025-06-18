import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splash_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://uvpnrcjlrklcppwyekbi.supabase.co',       
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV2cG5yY2pscmtsY3Bwd3lla2JpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAwODI3MTcsImV4cCI6MjA2NTY1ODcxN30.HajiDbkFWnRDg7ZJ-joymvVbQRM-4C78BRn3dqrg9Kw',                           // Replace with your Supabase anon key
  );

  runApp(const ValperApp());
}

class ValperApp extends StatelessWidget {
  const ValperApp({super.key});

  Future<Widget> _getInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    return isLoggedIn ? const HomeScreen() : const SplashScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VALPER',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/register': (context) => const RegisterStepsScreen(isStudent: true),
      },
      home: const SplashScreen(),
      /*
      // Optional: use FutureBuilder to show based on login
      home: FutureBuilder(
        future: _getInitialScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          } else {
            return snapshot.data as Widget;
          }
        },
      ),
      */
    );
  }
}
