import 'package:flutter/material.dart';

import 'login.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final emailController = TextEditingController();
  final usertypeController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              SizedBox(
                height: screenHeight * 0.1,
              ),
              Container(
                color: Colors.amber,
                height: 150,
                width: 150,
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
            Container(
              padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
              child: TextFormField(
                autofocus: true,
                controller: fnameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'First Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
              child: TextFormField(
                autofocus: true,
                controller: lnameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Last Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
              child: TextFormField(
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
              child: TextFormField(
                autofocus: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
              child: TextFormField(
                autofocus: true,
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm Password',
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
                    "Sign Up",
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
                const Text("Already have an account? "),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
