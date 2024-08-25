import 'package:dccm/UserInterfaces/LaunchScreen.dart';
import 'package:dccm/UserInterfaces/LoginScreen.dart';
import 'package:dccm/UserInterfaces/RegisterScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LaunchScreen(),
        '/Registerscreen': (context) => const Registerscreen(),
        '/Login': (context) => const Loginscreen()
      },
    );
  }
}
