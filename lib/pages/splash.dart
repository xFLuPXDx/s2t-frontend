import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'signup.dart';
import 'login.dart';

class Spalsh_Screen extends StatefulWidget {
  const Spalsh_Screen({super.key});

  @override
  State<Spalsh_Screen> createState() => _Spalsh_ScreenState();
}

class _Spalsh_ScreenState extends State<Spalsh_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        splash: Icons.bar_chart, 
        duration: 3000,
        nextScreen: LoginPage()),
    );
  }
}
