import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? _userStatus;

class Spalsh_Screen extends StatefulWidget {
  const Spalsh_Screen({super.key});

  @override
  State<Spalsh_Screen> createState() => _Spalsh_ScreenState();
}

class _Spalsh_ScreenState extends State<Spalsh_Screen> {
  @override
  void initState() {
    super.initState();
    Future.wait([
      getValidationData()
    ]);
    
  }

  Future getValidationData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getString("user_status");
    setState(() {
      _userStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
          splash: Image.asset(
            "assets/images/clarity.png",
            height: 400,
            width: 400,
          ),
          duration: 1000,
          nextScreen: _userStatus == "loggedIn" ?  MyHomePage() : LoginPage()),
    );
  }
}
