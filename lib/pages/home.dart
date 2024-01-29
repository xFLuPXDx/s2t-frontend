import 'package:flutter/material.dart';
import 'package:s2t_learning/pages/resourcepage.dart';
import 'splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'views/getgroups.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final joinController = TextEditingController();

  Future logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user_status", "loggedOut");
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
              child: const Icon(
                Icons.logout_rounded,
              ))
        ],
      ),
      body: fetchGroups(),
      floatingActionButton: FloatingActionButton(
        splashColor: const Color.fromARGB(255, 255, 255, 255),
        shape: const CircleBorder(),
        backgroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          setState(() {
            
          });
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: screenHeight * 0.5,
                width: screenWidth,
                color: Colors.white,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "Ask your instructor for class code",
                        style: TextStyle(
                            color: Color.fromARGB(255, 39, 39, 39),
                            fontSize: 20),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        
                        controller: joinController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Code',
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: (){
                        
                      }, 
                      child: const Text("Join"),
                      )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
    ;
  }
}
