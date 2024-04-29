import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/JoinCreateGroup.dart';
import 'splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/getgroups.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

String API_URL = dotenv.get("API_URL");

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
        backgroundColor: Color(0xFF7BD3EA),
        shadowColor: Colors.black,
        elevation: 5,
        actions: [
          IconButton(
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Click on Logout to confirm'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, 'Cancel');
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          logout().whenComplete(
                              () => Get.off(() => const Spalsh_Screen()));
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );
              },
              icon: Container(
                margin: const EdgeInsets.only(right: 10),
                child: const Icon(
                  Icons.logout_rounded,
                ),
              ))
        ],
      ),
      body: RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          color: const Color(0xFF7BD3EA),
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            setState(() {});
          },
          child: const Center(child: fetchGroups())),
      drawer: const Groups_Drawer(),
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
