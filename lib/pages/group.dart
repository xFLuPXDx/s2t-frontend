import 'package:flutter/material.dart';
import 'package:s2t_learning/pages/recordpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'peoplespage.dart';
import 'resourcepage1.dart';
import 'views/getgroups.dart';

class GroupPage extends StatefulWidget {
  final String group_Id;
  final String group_Subject;
  const GroupPage(
      {super.key, required this.group_Id, required this.group_Subject});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true
  );
  int _selectedIndex = 0;
  String group_Id = "";
  List<Widget> widgetList = [];
  String? user_Type;

  Future getUserType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_Type = prefs.getString("user_Type");
    });
  }

  @override
  void initState() {
    getUserType().whenComplete(() {
      if (user_Type == 'educator') {
        widgetList = [
          Resources(
              group_Id: widget.group_Id, group_Subject: widget.group_Subject),
          RecordPage(
              group_Id: widget.group_Id, group_Subject: widget.group_Subject),
          Peoples(
              group_Id: widget.group_Id, group_Subject: widget.group_Subject),
        ];
      } else {
        widgetList = [
          Resources(
              group_Id: widget.group_Id, group_Subject: widget.group_Subject),
          Peoples(
              group_Id: widget.group_Id, group_Subject: widget.group_Subject),
        ];
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7BD3EA),
        shadowColor: Colors.black,
        elevation: 5,
      ),
      drawer: const Groups_Drawer(),
      body: PageView(
        pageSnapping: true,
        controller: pageController,
        children: widgetList,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
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
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            pageController.animateToPage(index,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          });
        },
      ),
    );
  }
}
