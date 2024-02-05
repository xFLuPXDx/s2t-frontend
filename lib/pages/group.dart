import 'package:flutter/material.dart';
import 'package:s2t_learning/pages/recordpage.dart';

import 'peoplespage.dart';
import 'resourcepage1.dart';

class GroupPage extends StatefulWidget {
  final String group_Id;
  const GroupPage({super.key, required this.group_Id});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  int _selectedIndex = 0;
  String gid = "";
  List<Widget> widgetList = [];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    gid = widget.group_Id;
    widgetList = [
      Resources(group_Id: gid),
      RecordPage(group_Id: gid),
      Peoples(group_Id: gid),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        elevation: 5,
      ),
      body: widgetList.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.file_copy_outlined), label: "Resources"),
          BottomNavigationBarItem(
              icon: Icon(Icons.record_voice_over), label: "Record"),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_sharp), label: "Peoples")
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        onTap: _onItemTapped,
      ),
    );
  }
}
