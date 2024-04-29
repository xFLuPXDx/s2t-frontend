import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:s2t_learning/pages/group.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../structure/groupstruct.dart';
import '../home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String API_URL = dotenv.get("API_URL");

class fetchGroups extends StatefulWidget {
  const fetchGroups({super.key});

  @override
  State<fetchGroups> createState() => fetchGroupsState();
}

class fetchGroupsState extends State<fetchGroups> {
  Future deleteGroups(code) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    http.Response response = await http.post(
      Uri.parse("$API_URL/group/delete"),
      body: json.encode({"group_Id": code}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    setState(() {
      futureGroups = getGroups();
    });
  }

  Future<Groups>? futureGroups;

  Future<Groups> getGroups() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    http.Response response = await http.get(
      Uri.parse("$API_URL/group/fetch"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      return Groups.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load groups');
    }
  }

  @override
  void initState() {
    super.initState();
    futureGroups = getGroups();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<Groups>(
        future: futureGroups,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                itemCount: snapshot.data!.count!.toInt(),
                itemBuilder: ((context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => GroupPage(
                          group_Id:
                              snapshot.data!.result![index].groupId.toString(),
                          group_Subject: snapshot
                              .data!.result![index].groupSubject
                              .toString()));
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
                            color: const Color(0xFF7BD3EA).withOpacity(0.3),
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
                                child: Text(
                                    snapshot.data!.result![index].groupName
                                        .toString(),
                                    style:
                                        const TextStyle(fontSize: 20, color: Colors.black )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: IconButton(
                                    onPressed: () {
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
                                                    Navigator.pop(context);
                                                    showDialog<String>(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          AlertDialog(
                                                        title: const Text(
                                                            'Un enroll from group'),
                                                        content: const Text(
                                                            'Click on Un enroll to confirm'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context,
                                                                  'Cancel');
                                                            },
                                                            child: const Text(
                                                                'Cancel'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              deleteGroups(snapshot
                                                                      .data!
                                                                      .result![
                                                                          index]
                                                                      .groupId
                                                                      .toString())
                                                                  .whenComplete(() =>
                                                                      Navigator.pop(
                                                                          context,
                                                                          'OK'));
                                                            },
                                                            child: const Text(
                                                                'Unenroll'),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  child: SizedBox(
                                                    height: 50,
                                                    width: screenWidth,
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 20, top: 20),
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
                                    icon: const Icon(Icons.more_horiz)),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Text(
                                snapshot.data!.result![index].groupSubject
                                    .toString(),
                                style: const TextStyle(fontSize: 20, color: Colors.black )),
                          ),
                        ],
                      ),
                    ),
                  );
                }));
          } else if (snapshot.hasError) {
            return const Text("");
          }
          return const CircularProgressIndicator();
        }));
  }
}

class Groups_Drawer extends StatefulWidget {
  const Groups_Drawer({super.key});

  @override
  State<Groups_Drawer> createState() => _Groups_DrawerState();
}

class _Groups_DrawerState extends State<Groups_Drawer> {
  Future<Groups>? futureGroups;

  Future<Groups> getGroups() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    http.Response response = await http.get(
      Uri.parse("$API_URL/group/fetch"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      return Groups.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load groups');
    }
  }

  @override
  void initState() {
    super.initState();
    futureGroups = getGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF7BD3EA),
      width: 250,
      child: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  color: const Color(0xFF7BD3EA),
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 15, left: 15, bottom: 5),
                        child: Text(
                          'Clarity',
                          style: TextStyle(fontSize: 25 , color: Colors.black , fontWeight:FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                ),
                GestureDetector(
                  onTap: () {
                    Get.off(() => const MyHomePage());
                  },
                  child: Container(
                      padding: const EdgeInsets.only(left: 15, top: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7BD3EA).withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.home_outlined, size: 30),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child:
                                Text("Groups", style: TextStyle(fontSize: 25 , color: Colors.black , fontWeight:FontWeight.w500)),
                          )
                        ],
                      )),
                ),
                const SizedBox(height: 20),
              ]),
              FutureBuilder<Groups>(
                  future: futureGroups,
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: ListView.separated(
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                          itemCount: snapshot.data!.count!.toInt(),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                Get.to(
                                    () => GroupPage(
                                        group_Id: snapshot
                                            .data!.result![index].groupId
                                            .toString(),
                                        group_Subject: snapshot
                                            .data!.result![index].groupSubject
                                            .toString()),
                                    preventDuplicates: false);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF7BD3EA)
                                          .withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, bottom: 5),
                                  child: Text(
                                    snapshot.data!.result![index].groupName
                                        .toString(),
                                    style: const TextStyle(fontSize: 20, color: Colors.black , fontWeight:FontWeight.w500),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Text("");
                    }
                    return const Center(child: CircularProgressIndicator());
                  }))
            ],
          ),
        ),
      ),
    );
  }
}
