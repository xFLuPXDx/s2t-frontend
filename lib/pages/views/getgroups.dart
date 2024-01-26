/* import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';


class fetchGroups extends StatefulWidget {
  const fetchGroups({super.key});

  @override
  State<fetchGroups> createState() => _fetchGroupsState();
}

class _fetchGroupsState extends State<fetchGroups> {
  

  getGroups() async{
    Response response = await get(Uri.parse('http://10.0.2.2:8000/getGroup/'));
    
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
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
              padding: const EdgeInsets.all(10),
              color: Colors.white,
              child: ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                  itemCount: ListOfGroups.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: screenHeight * 0.2,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 214, 214, 214),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(0.1), // Shadow color
                            spreadRadius: 0, // Spread radius
                            blurRadius: 2, // Blur radius
                            offset:
                                const Offset(0, 2), // Offset position of shadow
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
                                child: Text(ListOfGroups[index].groupName.toString(),
                                    style:
                                        const TextStyle(color: Colors.black)
                                      ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: Icon(Icons.more_horiz),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Text(ListOfGroups[index].groupSubject.toString(),
                                style: const TextStyle(color: Colors.black)),
                          ),
                        ],
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


 */