import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import '../structure/resourcestruct.dart';
import 'resourcepage2.dart';

String API_URL = dotenv.get("API_URL");

class Resources extends StatefulWidget {
  final String group_Id;
  final String group_Subject;
  const Resources(
      {super.key, required this.group_Id, required this.group_Subject});

  @override
  State<Resources> createState() => _ResourcesState();
}

class _ResourcesState extends State<Resources> {
  Future<ResourcesList>? futureResources;
  String? user_Type;
  int deleteResourceStatusCode = 0;

  getUserType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_Type = prefs.getString("user_Type");
    });
  }

  Future<ResourcesList> getResources() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    http.Response response = await http.post(
      Uri.parse("$API_URL/resource/fetch"),
      body: json.encode({"group_Id": widget.group_Id}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      return ResourcesList.fromJson(json.decode(response.body));
    } else {
      print('Failed to load groups');
      throw Exception('Failed to load groups');
    }
  }

  Future deleteResource(rid) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    http.Response response = await http.post(
      Uri.parse("$API_URL/resource/delete"),
      body: json.encode({"rid": rid}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    deleteResourceStatusCode = response.statusCode;
    setState(() {
      futureResources = getResources();
    });
  }

  @override
  void initState() {
    super.initState();
    getUserType();
    futureResources = getResources();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      color: const Color(0xFF7BD3EA),
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 2));
        setState(() {
          futureResources = getResources();
        });
      },
      child: Scaffold(
          body: Column(
        children: [
          FutureBuilder<ResourcesList>(
            future: futureResources,
            builder: (context, snapshot) {
              late List<Widget> widgetlist;
              widgetlist = [
                Container(
                    margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                    height: 100,
                    width: screenWidth * 0.95,
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
                      children: [
                        user_Type == "educator"
                            ? Container(
                                margin: EdgeInsets.only(
                                    left: screenWidth * 0.65, top: 10),
                                child: Text("Code : ${widget.group_Id}"),
                              )
                            : const Text(""),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 30),
                          child: Text(
                            widget.group_Subject,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    )),
              ];
              if (snapshot.hasData) {
                for (int index = 0;
                    index < snapshot.data!.count!.toInt();
                    index++) {
                  widgetlist.add(Container(
                    margin: const EdgeInsets.only(top: 15, left: 10, right: 10),
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
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                              "${snapshot.data!.result![index].timeStamp.toString()} Lecture Summary ",
                              style: const TextStyle(fontSize: 16 , color: Colors.black)),
                      ),
                            Divider(),
                      GestureDetector(
                        onTap: () => Get.to(() => DetailedResource(
                              timeStamp: snapshot.data!.result![index].timeStamp
                                  .toString(),
                              summarizedText: snapshot
                                  .data!.result![index].summarizedText
                                  .toString(),
                              topicsCovered: snapshot
                                  .data!.result![index].topicsCovered!
                                  .toList(),
                              resourceLinks: snapshot
                                  .data!.result![index].resourceLinks!
                                  .toList(),
                            )),
                        onLongPress: () {
                          user_Type == "educator"
                              ? showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: screenHeight * 0.08,
                                      width: screenWidth,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                              showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                            title: const Text(
                                                                'Delete resource from group'),
                                                            content: const Text(
                                                                'Click on Delete to confirm'),
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
                                                                  deleteResource(snapshot
                                                                          .data!
                                                                          .result![
                                                                              index]
                                                                          .rid
                                                                          .toString())
                                                                      .whenComplete(
                                                                    () {
                                                                      if (deleteResourceStatusCode ==
                                                                          200) {
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(const SnackBar(
                                                                          content:
                                                                              Text('Resource deleted successfully'),
                                                                        ));
                                                                        Navigator.pop(
                                                                            context,
                                                                            "OK");
                                                                      } else {
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(const SnackBar(
                                                                          content:
                                                                              Text('Error in deleting resources'),
                                                                        ));
                                                                      }
                                                                    },
                                                                  );
                                                                },
                                                                child: const Text(
                                                                    'Delete'),
                                                              ),
                                                            ],
                                                          ));
                                            },
                                            child: SizedBox(
                                              height: 50,
                                              width: screenWidth,
                                              child: const Padding(
                                                padding: EdgeInsets.only(
                                                    left: 20, top: 20),
                                                child: Text(
                                                  "Delete Resource",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : const Text("");
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          child: Text(
                            snapshot.data!.result![index].summarizedText
                                .toString(),
                            style: const TextStyle(fontSize: 18 , color: Colors.black),
                          ),
                        ),
                      ),
                    ]),
                  ));
                }
                return Expanded(
                  child: ListView.builder(
                      itemCount: widgetlist.length,
                      itemBuilder: ((context, index) {
                        return widgetlist[index];
                      })),
                );
              } else if (snapshot.hasError) {
                widgetlist.add(
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 300),
                      child: const Text("No Resources Yet"),
                    ),
                  ),
                );
                return Column(children: [widgetlist[0], widgetlist[1]]);
              }
              return Center(
                  child: Container(
                      margin: EdgeInsets.only(top: screenHeight * 0.4),
                      child: const CircularProgressIndicator()));
            },
          ),
        ],
      )),
    );
  }
}
