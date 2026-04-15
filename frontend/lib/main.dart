import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  runApp(BioPulseApp(isLoggedIn: token != null));
}

class BioPulseApp extends StatelessWidget {
  final bool isLoggedIn;

  BioPulseApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BioPulse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.light),
        scaffoldBackgroundColor: const Color(0xFFF4F9F7),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.grey.shade900),
          titleTextStyle: TextStyle(color: Colors.grey.shade900, fontSize: 20, fontWeight: FontWeight.w700),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withOpacity(0.85),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0), borderSide: BorderSide.none),
          contentPadding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
            elevation: 0,
            padding: EdgeInsets.symmetric(vertical: 16.0),
          ),
        ),
      ),
      home: SplashScreen(isLoggedIn: isLoggedIn),
    );
  }
}
