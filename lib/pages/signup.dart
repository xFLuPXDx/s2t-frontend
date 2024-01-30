import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'login.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isEmailExist(String email) {
    if (emailExists) {
      return true;
    } else {
      return false;
    }
  }

  bool _isValidEmail(String email) {
    String emailRegex = r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(emailRegex);
    return regex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    RegExp alphabeticRegex = RegExp(r'[a-zA-Z]');
    RegExp numericRegex = RegExp(r'[0-9]');
    return password.length >= 8 &&
        alphabeticRegex.hasMatch(password) &&
        numericRegex.hasMatch(password);
  }

  bool _isMatchPassword(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  Future<void> saveAccessToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('access_token', accessToken);
    prefs.setString("user_status", "loggedIn");
  }

  Future getData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final response = await http.get(
      Uri.parse("http://192.168.0.111:8000/user/get"),
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

  Future postData() async {
    final response = await http.post(
      Uri.parse("http://192.168.0.111:8000/signUp"),
      body: json.encode({
        "user_Id": "string",
        "user_Fname": fnameController.text,
        "user_Lname": lnameController.text,
        "user_Email": emailController.text,
        "group_Ids": [],
        "user_Type": dropdownValue,
        "hashed_password": passwordController.text
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      saveAccessToken(data["access_token"]);
      setState(() {
        emailExists = false;
      });
    } else if (response.statusCode == 409) {
      setState(() {
        emailExists = true;
      });
    }
    print('Error: ${response.statusCode}' + emailExists.toString());
  }

  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool emailExists = false;
  String? dropdownValue;
  bool _isHidden1 = true;
  bool _isHidden2 = true;

  void _togglePasswordView() {
    setState(() {
      _isHidden1 = !_isHidden1;
    });
    return;
  }

  void _togglecPasswordView() {
    setState(() {
      _isHidden2 = !_isHidden2;
    });
    return;
  }

  final snackBar = SnackBar(
    content: const Text('email already exist'),
    action: SnackBarAction(
      label: "X",
      onPressed: () {},
    ),
  );

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: screenHeight * 0.1,
              ),
              Container(
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
                padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
                child: TextFormField(
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
                  controller: lnameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Last Name',
                  ),
                ),
              ),
              DropdownButtonFormField<String>(
                items: <String>['learner', 'educator']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: const Text('User Type'),
                value: dropdownValue,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
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
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: _isHidden1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    suffix: InkWell(
                      onTap: _togglePasswordView,
                      child: Icon(
                        _isHidden1 ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password must be at least 8 characters';
                    } else if (!_isValidPassword(value)) {
                      return 'Password must contain alpha neumeric ';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
                child: TextFormField(
                  controller: confirmPasswordController,
                  obscureText: _isHidden2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password',
                    suffix: InkWell(
                      onTap: _togglecPasswordView,
                      child: Icon(
                        _isHidden2 ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    } else if (!_isMatchPassword(
                        passwordController.text, value)) {
                      return 'Passwords do not match';
                    }
                    return null;
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
                    Future.wait([
                      postData().then(
                        (value) {
                          getData();
                          if (emailExists) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            emailController.text = "";
                            passwordController.text = "";
                            confirmPasswordController.text = "";
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyHomePage()),
                            );
                          }
                        },
                      ),
                      
                    ]);
                  }
                },
                child: Container(
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.07,
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
              SizedBox(
                height: screenHeight * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
