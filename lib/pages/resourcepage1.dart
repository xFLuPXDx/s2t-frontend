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

  @override
  void initState() {
    super.initState();
    futureResources = getResources();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Column(
      children: [
        Container(
            margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
            height: 100,
            width: screenWidth * 0.95,
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
              padding: const EdgeInsets.only(left: 20, top: 60),
              child: Text(
                widget.group_Subject,
                style: const TextStyle(fontSize: 20),
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
                  height: 40,
                  width: 40,
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
                    )),
              ],
            )),
        Expanded(
          child: FutureBuilder<ResourcesList>(
            future: futureResources,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.count!.toInt(),
                    itemBuilder: ((context, index) {
                      return Container(
                        margin:
                            const EdgeInsets.only(top: 15, left: 10, right: 10),
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
                        child: Column(children: [
                          Container(
                            padding: const EdgeInsets.only(
                                top: 10, left: 97, right: 97,bottom: 5),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(10)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                                "${snapshot.data!.result![index].timeStamp.toString()} Lecture Summary "),
                          ),
                          GestureDetector(
                            onTap: () => Get.to(()=>DetailedResource(timeStamp: snapshot.data!.result![index].timeStamp.toString(),summarizedText: snapshot.data!.result![index].summarizedText.toString(),topicsCovered: snapshot.data!.result![index].topicsCovered!.toList(), resourceLinks: snapshot.data!.result![index].resourceLinks!.toList(),)),
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              child: Text(
                                snapshot.data!.result![index].summarizedText
                                    .toString(),
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ]),
                      );
                    }));
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    ));
  }
}
