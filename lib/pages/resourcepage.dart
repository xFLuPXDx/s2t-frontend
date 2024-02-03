import 'package:flutter/material.dart';
import 'views/getgroups.dart';

class Resource_Page extends StatefulWidget {
  const Resource_Page({super.key});

  @override
  State<Resource_Page> createState() => _Resource_PageState();
}

class _Resource_PageState extends State<Resource_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
      ),
      drawer: Groups_Drawer(),
    );
  }
}
