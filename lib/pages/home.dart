import 'package:flutter/material.dart';
import 'package:s2t_learning/pages/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user_status", "loggedOut");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.abc),
        backgroundColor: Colors.amberAccent,
        actions: [
          GestureDetector(
              onTap: () {
                logout().whenComplete(() => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Spalsh_Screen())));
              },
              child: const Icon(
                Icons.logout_rounded,
              ))
        ],
      ),
      body: const Center(child: Text("Home Page")),
    );
    ;
  }
}
