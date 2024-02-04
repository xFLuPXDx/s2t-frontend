import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'resourcepage2.dart';
import 'views/getgroups.dart';

class Resources extends StatefulWidget {
  final String group_Id;
  const Resources({super.key, required this.group_Id});

  @override
  State<Resources> createState() => _ResourcesState();
}

class _ResourcesState extends State<Resources> {
  List<dynamic> ListOfResources = [
    "Resource 1",
    "Resource 2",
    "Resource 3",
    "Resource 4"
  ];

  getGroups() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    http.Response response = await http.get(
      Uri.parse("$API_URL/group/fetch"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
  }

  List<Widget> reswid = [];

  List<Widget> resourceList(List<dynamic> data) {
    List<Widget> ListOfResource = [
      Container(
          margin: const EdgeInsets.all(10),
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 2,
                offset: const Offset(-2, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 25, top: 50),
            child: Text(
              widget.group_Id,
              style: const TextStyle(fontSize: 30),
            ),
          )),
          Container(
            margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 2,
                offset: const Offset(-2, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20),
                height : 40,
                width : 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.withOpacity(0.2),
                ),
                child: const Icon(Icons.person_2),
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Announce something to your class",
                 
                )
              ),
            ],
          )
          )
    ];

    for (String item in data) {
      if (item == "Resource 1" || item == "Resource 2") {
        ListOfResource.add(GestureDetector(
          onTap: () {
            Get.to(() => const Resource());
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(-2, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Text(item,
                          style: const TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
      } else {
         ListOfResource.add(GestureDetector(
        onTap: () {
          Get.to(()=>const Resource());
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 2,
                offset: const Offset(-2, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child:
                        Text(item, style: const TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ));
      }
    }
    setState(() {
      reswid = ListOfResource;
    });
    return [];
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    resourceList(ListOfResources);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        elevation: 5,
      ),
      body: ListView.builder(
          itemCount: reswid.length,
          itemBuilder: (context, Index) {
            return reswid[Index];
          }),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.file_copy_rounded), label: "Resources"),
          BottomNavigationBarItem(
              icon: Icon(Icons.mic_rounded), label: "Record")
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 255, 51, 51),
        onTap: _onItemTapped,
      ),
    );
  }
}
