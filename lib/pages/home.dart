import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:s2t_learning/pages/resourcepage.dart';
import 'joinGroup.dart';
import 'login.dart';
import 'splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'views/getgroups.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    getUserType();
    super.initState();
  }
  String? user_Type;

  getUserType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_Type = prefs.getString("user_Type");
    });
  }

  Future logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString("user_status", "loggedOut");
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: const Icon(Icons.menu),
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
              onTap: () {
                logout().whenComplete(() => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Spalsh_Screen())));
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(
                  Icons.logout_rounded,
                ),
              ))
        ],
      ),
      body: const fetchGroups(),
      floatingActionButton: FloatingActionButton(
        splashColor: const Color.fromARGB(255, 255, 255, 255),
        shape: const CircleBorder(),
        backgroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          if (user_Type == "educator") {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: screenHeight * 0.135,
                  width: screenWidth,
                  color: Colors.white,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          
                        },
                        child: Container(
                          height: 55,
                          width: screenWidth,
                          decoration:  BoxDecoration(
                            color: Colors.white,
                            boxShadow: [BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(0, 1),
                              )],
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(left: 20, top: 15),
                            child: Text(
                              "Create",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => JoinGroup()),
                      );
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 1),
                          height: 55,
                          width: screenWidth,
                          color: Colors.white,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 20 ,top: 10),
                            child: Text(
                              "Join",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: screenHeight * 0.1,
                  width: screenWidth,
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                        width: screenWidth,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 20, top: 20),
                          child: Text(
                            "Join",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
    ;
  }
}
