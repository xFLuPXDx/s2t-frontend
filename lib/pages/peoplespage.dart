import 'package:flutter/material.dart';

class Peoples extends StatefulWidget {
 final String group_Id;
  const Peoples({super.key, required this.group_Id});

  @override
  State<Peoples> createState() => _PeoplesState();
}

class _PeoplesState extends State<Peoples> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Text(widget.group_Id),
    );
  }
}