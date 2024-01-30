import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../resourcepage.dart';

class fetchGroups extends StatefulWidget {
  const fetchGroups({super.key});

  @override
  State<fetchGroups> createState() => fetchGroupsState();
}

class fetchGroupsState extends State<fetchGroups> {
  List<dynamic> ListOfGroups = [];

  Future deleteGroups(code) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    http.Response response = await http.post(
      Uri.parse("http://192.168.0.111:8000/group/delete"),
      body: json.encode({"group_Id": code}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    setState(() {
      getGroups();
    });
  }

  Future getGroups() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    http.Response response = await http.get(
      Uri.parse("http://192.168.0.111:8000/group/fetch"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    List<dynamic> data = json.decode(response.body);
    if(data != []){
      setState(() {
      ListOfGroups = data;
    });
    }
    
  }

  @override
  void initState() {
    super.initState();
    getGroups();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Expanded(
          child: Center(
            child: Container(
              color: Colors.white70,
              child: ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                  itemCount: ListOfGroups.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Resource_Page()),
                        );
                      },
                      child: Container(
                        margin:
                            const EdgeInsets.only(top: 10, left: 10, right: 10),
                        height: screenHeight * 0.2,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Text(ListOfGroups[index]['group_Name'],
                                      style:
                                          const TextStyle(color: Colors.black)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              height: screenHeight * 0.08,
                                              width: screenWidth,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.white,
                                              ),
                                              child: Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      showDialog<String>(
                                                          context: context,
                                                          builder: (BuildContext
                                                                  context) =>
                                                              AlertDialog(
                                                                title: const Text(
                                                                    'AlertDialog Title'),
                                                                content: const Text(
                                                                    'AlertDialog description'),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context,
                                                                          'Cancel');
                                                                    },
                                                                    child: const Text(
                                                                        'Cancel'),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      deleteGroups(
                                                                          ListOfGroups[index]
                                                                              [
                                                                              'group_Id']);
                                                                      Navigator.pop(
                                                                          context,
                                                                          'OK');
                                                                    },
                                                                    child: const Text(
                                                                        'Unenrol'),
                                                                  ),
                                                                ],
                                                              ));
                                                    },
                                                    child: SizedBox(
                                                      height: 50,
                                                      width: screenWidth,
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 20,
                                                                top: 20),
                                                        child: Text(
                                                          "Unenrol",
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: const Icon(Icons.more_horiz)),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Text(
                                  ListOfGroups[index]['group_Subject']
                                      .toString(),
                                  style: const TextStyle(color: Colors.black)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ),
      ],
    );
  }
}
