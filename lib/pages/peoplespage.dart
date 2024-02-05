import 'package:flutter/material.dart';

class Peoples extends StatefulWidget {
  const Peoples({super.key});

  @override
  State<Peoples> createState() => _PeoplesState();
}

class _PeoplesState extends State<Peoples> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("peoples"),
    );
  }
}