import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/JoinCreateGroup.dart';
import 'splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/getgroups.dart';

String API_URL = "http://192.168.0.111:8000";

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> ListOfGroups = [];
  String? user_Type;

  List<StatelessWidget> draweritem = [
    const DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      child: Text('Drawer Header'),
    ),
  ];

  @override
  void initState() {
    getUserType();

    super.initState();
  }

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
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                logout().whenComplete(Get.off(() =>  const Spalsh_Screen()) as FutureOr<void> Function());
              },
              icon: const Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(
                  Icons.logout_rounded,
                ),
              ))
        ],
      ),
      drawer: const Groups_Drawer(),
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
                        onTap: () => Get.to(const CreateGroup()),
                        child: Container(
                          height: 55,
                          width: screenWidth,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(0, 1),
                              )
                            ],
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
                        onTap: () => Get.to(() => const JoinGroup()),
                        child: Container(
                          margin: const EdgeInsets.only(top: 1),
                          height: 55,
                          width: screenWidth,
                          color: Colors.white,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 20, top: 10),
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
                      GestureDetector(
                        onTap: () => Get.to(() => const JoinGroup()),
                        child: SizedBox(
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
  }
}


