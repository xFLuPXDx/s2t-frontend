import 'package:flutter/material.dart';

class RecordPage extends StatefulWidget {
  final String group_Id;
  const RecordPage({super.key, required this.group_Id});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(widget.group_Id),
    );
  }
}