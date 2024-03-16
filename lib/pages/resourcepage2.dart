import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:s2t_learning/structure/resourcestruct.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

String API_URL = dotenv.get("API_URL");

class DetailedResource extends StatefulWidget {
  final String timeStamp;
  final String summarizedText;
  final List<String> topicsCovered;
  final List<String> resourceLinks;
  const DetailedResource({
    super.key,
    required this.timeStamp,
    required this.summarizedText,
    required this.topicsCovered,
    required this.resourceLinks,
  });

  @override
  State<DetailedResource> createState() => _DetailedResourceState();
}

class _DetailedResourceState extends State<DetailedResource> {
  late final List<String> video_ids;
  late List<Widget> widgetlist;

  @override
  void initState() {
    super.initState();
    video_ids = widget.resourceLinks;
    widgetlist = [Text(widget.timeStamp), Text(widget.summarizedText)];
    for (int i = 0; i < widget.resourceLinks.length; i++) {
      widgetlist.add(Column(
        children: [
          Container(
              padding: EdgeInsets.all(10),
              child: Text(widget.topicsCovered[i])),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: YoutubePlayer(
              controller: YoutubePlayerController(
                  initialVideoId: video_ids[i],
                  flags: YoutubePlayerFlags(autoPlay: false)),
              showVideoProgressIndicator: true,
            ),
          ),
        ],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.black,
          elevation: 5,
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: widgetlist.length,
                  itemBuilder: (context, index) {
                    return widgetlist[index];
                  }),
            ),
          ],
        ));
  }
}
