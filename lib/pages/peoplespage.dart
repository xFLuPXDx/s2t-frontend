import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:s2t_learning/structure/peoplesstruct.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

String API_URL = dotenv.get("API_URL");

class Peoples extends StatefulWidget {
  final String group_Id;
  final String group_Subject;
  const Peoples(
      {super.key, required this.group_Id, required this.group_Subject});

  @override
  State<Peoples> createState() => _PeoplesState();
}

class _PeoplesState extends State<Peoples> {
  String gid = "";
  Future<PeoplesInGroup>? futurePeoplesInGroup;

  @override
  void initState() {
    super.initState();
    gid = widget.group_Id;
    futurePeoplesInGroup = getPeoplesInGroup();
  }

  Future<PeoplesInGroup> getPeoplesInGroup() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    http.Response response = await http.post(
      Uri.parse("$API_URL/group/users"),
      body: json.encode({"group_Id": gid}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      return PeoplesInGroup.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load groups');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<PeoplesInGroup>(
                future: futurePeoplesInGroup,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    List<Widget> widgetList = [
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: const Text("Educators",
                            style: TextStyle(fontSize: 30)),
                      ),
                      const Divider(),
                    ];
                    for (int i = 0;i < snapshot.data!.educatorIds!.count!.toInt();i++) {
                      widgetList.add(
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, top: 10),
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
                              child: Text(
                                  "${snapshot.data!.educatorIds!.result![i].userFname} ${snapshot.data!.educatorIds!.result![i].userLname}",
                                  style: const TextStyle(fontSize: 20)),
                            )
                          ],
                        ),
                      );
                    }
                    widgetList.addAll([
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: const Text("Learners",
                            style: TextStyle(fontSize: 30)),
                      ),
                      const Divider(),
                    ]);
                    for (int i = 0;i < snapshot.data!.learnerIds!.count!.toInt();i++) {
                      widgetList.add(
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, top: 10),
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
                              child: Text(
                                  "${snapshot.data!.learnerIds!.result![i].userFname} ${snapshot.data!.learnerIds!.result![i].userLname}",
                                  style: const TextStyle(fontSize: 20)),
                            )
                          ],
                        ),
                      );
                    }
                    return ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 10,
                            ),
                        itemCount: widgetList.length,
                        itemBuilder: ((context, index) {
                          return widgetList[index];
                        }));
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return const Center(child: CircularProgressIndicator());
                })),
          ),
        ],
      ),
    );
  }
}
