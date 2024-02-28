import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String API_URL = "http://192.168.0.111:8000";

class Peoples extends StatefulWidget {
  final String group_Id;
  const Peoples({super.key, required this.group_Id});

  @override
  State<Peoples> createState() => _PeoplesState();
}

class _PeoplesState extends State<Peoples> {
  String gid = "";
  List<dynamic> listOfLearners = [];
  List<dynamic> listOfEducators = [];
  List<Widget> listOfWidget = [];

  @override
  void initState() {
    super.initState();
    gid = widget.group_Id;
    getPeoples();
  }

  getPeoples() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    http.Response response1 = await http.post(
      Uri.parse("$API_URL/group/peoples/learners"),
      body: json.encode({"group_Id": gid}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    http.Response response2 = await http.post(
      Uri.parse("$API_URL/group/peoples/educators"),
      body: json.encode({"group_Id": gid}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    List<dynamic> data1 = json.decode(response1.body);
    List<dynamic> data2 = json.decode(response2.body);
    setState(() {
      listOfLearners = data1;
      listOfEducators = data2;
    });
  }

  List<Widget> getwidgetList() {
    List<Widget> widgetList = [
      Container(
        margin: const EdgeInsets.only(top: 20),
        child: const Text("Educators", style: TextStyle(fontSize: 30)),
      ),
      const Divider(),
    ];
    for (var data in listOfEducators) {
      widgetList.add(
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(0.2),
              ),
              child: const Icon(Icons.person),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text(data["user_Fname"] + " " + data["user_Lname"],
                  style: const TextStyle(fontSize: 20)),
            )
          ],
        ),
      );
    }
    widgetList.add(
      Container(
        margin: const EdgeInsets.only(top: 20),
        child: const Text("Learners", style: TextStyle(fontSize: 30)),
      ),
    );
    widgetList.add(const Divider());
    for (var data in listOfLearners) {
      widgetList.add(
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(0.2),
              ),
              child: const Icon(Icons.person),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text(data["user_Fname"] + " " + data["user_Lname"],
                  style: const TextStyle(fontSize: 20)),
            )
          ],
        ),
      );
    }
    setState(() {
      listOfWidget = widgetList;
    });
    return [];
  }

  @override
  Widget build(BuildContext context) {
    getwidgetList();
    return Scaffold(
      body: ListView.builder(
          itemCount: listOfWidget.length,
          itemBuilder: (context, index) {
            return listOfWidget[index];
          }),
    );
  }
}
