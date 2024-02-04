import 'package:flutter/material.dart';
import 'views/getgroups.dart';

class Resource_Page extends StatefulWidget {
  final String group_Id;
  const Resource_Page({super.key, required this.group_Id});

  @override
  State<Resource_Page> createState() => _Resource_PageState();
}

class _Resource_PageState extends State<Resource_Page> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
      ),
      body: Column(children: [
        Container(
            height: screenHeight * 0.2,
            width: screenWidth * 0.88,
            color: Color.fromARGB(255, 202, 255, 142),
            child: Text(widget.group_Id)),
      ]),
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
