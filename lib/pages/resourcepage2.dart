import 'package:flutter/material.dart';

class Resource extends StatefulWidget {
  final String group_Id;
  final String group_Name;
  const Resource({super.key, required this.group_Id , required this.group_Name});

  @override
  State<Resource> createState() => _ResourceState();
}

class _ResourceState extends State<Resource> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        elevation: 5,
      ),
      backgroundColor: Colors.white,
      body: Text(widget.group_Name),
    );
  }
}