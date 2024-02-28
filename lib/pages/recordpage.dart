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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.withOpacity(0.8),
              ),
              child: IconButton(
                  icon: const Icon(Icons.mic_none_rounded),
                  onPressed: () {

                  },
                  iconSize: 100,
                  padding: const EdgeInsets.only(right: 100, top: 5)),
            )
          ],
        ),
      ),
    );
  }
}
