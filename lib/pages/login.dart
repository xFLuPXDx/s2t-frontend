import 'package:flutter/material.dart';

import 'signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: TextField(
              autofocus: true,
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
            child: TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: screenWidth * 0.8,
              height: screenHeight * 0.07,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(179, 163, 255, 232),
                  borderRadius: BorderRadius.circular(10)),
              child: const Center(
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Dont have an account? "),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.purple),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
