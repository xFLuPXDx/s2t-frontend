import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

String API_URL = "http://192.168.0.111:8000";

class JoinGroup extends StatefulWidget {
  const JoinGroup({super.key});

  @override
  State<JoinGroup> createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {
  final joinController = TextEditingController();

  Future joinGroups(code) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    http.Response response = await http.post(
      Uri.parse("$API_URL/group/join"),
      body: json.encode({"group_Id": code}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Column(children: [
        const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            "Ask your instructor for class code",
            style:
                TextStyle(color: Color.fromARGB(255, 39, 39, 39), fontSize: 20),
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
          onPressed: () {
            Future.wait([
              joinGroups(joinController.text).whenComplete(() {
                Get.to(() => const MyHomePage());
              })
            ]);
          },
          child: const Text("Join"),
        )
      ]),
    );
  }
}

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final nameController = TextEditingController();
  final subjectController = TextEditingController();

  Future createGroups(name, subject) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    http.Response response = await http.post(
      Uri.parse("$API_URL/group/insert"),
      body: json.encode({
        "group_Name": name,
        "group_Subject": subject,
        "group_Id": "string",
        "educator_Ids": [],
        "learner_Ids": [],
        "resource_Ids": []
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: Column(children: [
        Container(
          padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
          child: TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Group Name',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
          child: TextFormField(
            controller: subjectController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Group Subject',
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Future.wait([
              createGroups(nameController.text, subjectController.text)
                  .whenComplete(() {
                Get.to(() => const MyHomePage());
              })
            ]);
          },
          child: const Text("Create"),
        )
      ]),
    );
  }
}