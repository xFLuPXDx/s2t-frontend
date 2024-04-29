import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    widgetlist = [
      Container(
      
          margin: const EdgeInsets.only(
            top: 20
          ),
          child: Center(
              child: Text(
            "${widget.timeStamp} Lecture Summary",
            style: const TextStyle(fontSize: 20 ,color: Colors.black),
          ))),
          Divider(),
      Container(margin: const EdgeInsets.all(20), child: Text(widget.summarizedText, style: const TextStyle(fontSize: 18,color: Colors.black)))
    ];
    for (int i = 0; i < widget.resourceLinks.length; i++) {
      widgetlist.add(Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          border: Border.all(
            width: 1,
            color: Colors.grey,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 92, 124, 133).withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(-2, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                child: Text(widget.topicsCovered[i] , style: const TextStyle(fontSize: 18 , color: Colors.black))),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: YoutubePlayer(
                controller: YoutubePlayerController(
                    initialVideoId: video_ids[i],
                    flags: const YoutubePlayerFlags(autoPlay: false)),
                showVideoProgressIndicator: true,
              ),
            ),
          ],
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF7BD3EA),
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
