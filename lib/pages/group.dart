import 'package:flutter/material.dart';
import 'package:s2t_learning/pages/recordpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'peoplespage.dart';
import 'resourcepage1.dart';

class GroupPage extends StatefulWidget {
  final String group_Id;
  final String group_Name;
  const GroupPage({super.key, required this.group_Id , required this.group_Name});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  int _selectedIndex = 0;
  String group_Id = "";
  List<Widget> widgetList = [];
  String? user_Type;

  getUserType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_Type = prefs.getString("user_Type");
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    getUserType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (user_Type == 'educator') {
      widgetList = [
        Resources(group_Id: widget.group_Id , group_Name:  widget.group_Name),
        RecordPage(group_Id: widget.group_Id , group_Name:  widget.group_Name),
        Peoples(group_Id: widget.group_Id , group_Name:  widget.group_Name),
      ];
    } else {
      widgetList = [
        Resources(group_Id: widget.group_Id , group_Name:  widget.group_Name),
        Peoples(group_Id: widget.group_Id , group_Name:  widget.group_Name),
      ];
    }
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        elevation: 5,
      ),
      body: widgetList.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: user_Type == "educator"
            ? const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.file_copy_outlined), label: "Resources"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.record_voice_over), label: "Record"),
                 BottomNavigationBarItem(
                    icon: Icon(Icons.people_alt_sharp), label: "Peoples")
              ]
            : const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.file_copy_outlined), label: "Resources"),
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
