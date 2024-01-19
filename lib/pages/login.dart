import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> saveAccessToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('access_token', accessToken);
  }

  Future postData() async {
    final body = {
      'username': emailController.text,
      'password': passwordController.text,
    };

    final response = await http.post(
      Uri.parse("http://10.0.2.2:8000/auth"),
      body: body,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      saveAccessToken(data["access_token"]);
      print(data);
    } else {
      print(response.statusCode.toString());
    }
  }

  Future getData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final response = await http.get(
      Uri.parse("http://10.0.2.2:8000/user/get"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      prefs.setString("user_Fname", data["user_Fname"]);
      prefs.setString("user_Lname", data["user_Lname"]);
      prefs.setString("user_Email", data["user_Email"]);
      prefs.setString("user_Type", data["user_Type"]);
    } else {
      print(response.statusCode.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    /* Future fetchData() async {
      final response =
          await http.get(Uri.parse("http://10.0.2.2:8000/user/get"));

      if (response.statusCode == 200) {
        // Successful GET request
        final Map<String, dynamic> data = json.decode(response.body);
        print(data);
      } else {
        // Error in the GET request
        print('Error: ${response.reasonPhrase}');
      }
    } */

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Form(
        key: _formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.amber,
              height: 150,
              width: 150,
              child: Image.asset(
                "assets/images/logo.png",
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                autofocus: true,
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                validator: (email) => email!.length < 3
                    ? "Email should be more than 6 letters"
                    : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
              child: TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                validator: (pass) => pass!.length < 3
                    ? "pass should be more than 6 letters"
                    : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ),
            GestureDetector(
              onTap: () {
                postData();
                getData();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHomePage()),
                );
              },
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
      ),
    );
  }
}
