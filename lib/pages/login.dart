import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'signup.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String API_URL = dotenv.get("API_URL");

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isHidden = true;
  bool _success = true;
  int statusCode = 0;

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
    return;
  }

  Future<void> saveAccessToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('access_token', accessToken);
    prefs.setString("user_status", "loggedIn");
  }

  Future postData() async {
    final body = {
      'username': emailController.text,
      'password': passwordController.text,
    };

    final response = await http.post(
      Uri.parse("$API_URL/auth"),
      body: body,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      saveAccessToken(data["access_token"]);
    } 
    statusCode = response.statusCode;
  }

  Future getData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final response = await http.get(
      Uri.parse("$API_URL/user/get"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      prefs.setString("user_Type", data["user_Type"]);
    } else {}
  }

  bool _isValidEmail(String email) {
    String emailRegex = r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(emailRegex);
    return regex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    RegExp alphabeticRegex = RegExp(r'[a-zA-Z]');
    RegExp numericRegex = RegExp(r'[0-9]');
    return password.length >= 6 &&
        alphabeticRegex.hasMatch(password) &&
        numericRegex.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Form(
        key: _formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 150,
              width: 150,
              child: Image.asset(
                "assets/images/clarity.png",
              ),
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  } else if (!_isValidEmail(value)) {
                    return 'Enter a valid email address';
                  }
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
              child: TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Password',
                  suffix: InkWell(
                    onTap: _togglePasswordView,
                    child: Icon(
                      _isHidden ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
                obscureText: _isHidden,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password must be at least 8 characters';
                  } else if (!_isValidPassword(value)) {
                    return 'Password must contain alpha neumeric ';
                  }
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                if (_formkey.currentState!.validate()) {
                  postData().whenComplete(() {
                   if (statusCode == 401) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Invalid Credentials'),
                      ));
                    }else
                    {
                      getData().whenComplete(() {
                        Get.off(() => const MyHomePage());
                      });
                    }
                  });
                }
              },
              child: SizedBox(
                width: screenWidth * 0.8,
                height: screenHeight * 0.07,
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
                    Get.off(const SignUpPage());
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
