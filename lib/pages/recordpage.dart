import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart' as ap;
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String API_URL = dotenv.get("API_URL");

class RecordPage extends StatefulWidget {
  final String group_Id;
  const RecordPage({super.key, required this.group_Id});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  final recorder = FlutterSoundRecorder();
  final audioPlayer = ap.AudioPlayer();
  Duration playerDuration = Duration.zero;
  Duration playerPosition = Duration.zero;
  String? url = "";
  bool isPlaying = false;
  bool isRecorderReady = false;
  bool audReady = false;

  Future record() async {
    if (!isRecorderReady) return;
    await recorder.startRecorder(toFile: 'audio', codec: Codec.defaultCodec);
  }

  Future stop() async {
    if (!isRecorderReady) return;
    final path = await recorder.stopRecorder();
    setState(() {
      url = path;
      audReady = true;
    });
    
    print(path);
  }

  Future<void> uploadFile() async {
    var uri = Uri.parse("$API_URL/resource/upload");
    var request = http.MultipartRequest('POST', uri);
    print(url);
    print(url.toString());
    request.files.add(await http.MultipartFile.fromPath('file', url.toString()));
    var response = await request.send();

    if (response.statusCode == 200) {
        print("File uploaded successfully");
    } else {
        print("File upload failed with status: ${response.statusCode}");
    }
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw 'Microphone premission not granted';
    }

    await recorder.openRecorder();
    isRecorderReady = true;

    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRecorder();
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == ap.PlayerState.playing;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    
    recorder.closeRecorder();
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

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
                  icon: Icon(recorder.isRecording
                      ? Icons.stop
                      : Icons.mic_none_rounded),
                  onPressed: () async {
                    if (recorder.isRecording) {
                      await stop();
                    } else {
                      await record();
                    }
                    setState(() {});
                  },
                  iconSize: 100,
                  padding: const EdgeInsets.only(right: 100, top: 5)),
            ),
            StreamBuilder<RecordingDisposition>(
                stream: recorder.onProgress,
                builder: (context, snapshot) {
                  final duration = snapshot.hasData
                      ? snapshot.data!.duration
                      : Duration.zero;

                  String twoDigits(int n) => n.toString().padLeft(2, '0');
                  final twoDigitsMinutes = twoDigits(duration.inMinutes);
                  final twoDigitsSeconds =
                      twoDigits(duration.inSeconds.remainder(60));

                  return Text(
                    '$twoDigitsMinutes:$twoDigitsSeconds',
                    style: const TextStyle(
                      fontSize: 50,
                    ),
                  );
                }),
            const SizedBox(
              height: 20,
            ),
            audReady
                ? Column(
                    children: [
                      Slider(
                          min: 0,
                          max: playerDuration.inSeconds.toDouble(),
                          value: playerPosition.inSeconds.toDouble(),
                          onChanged: (value) async {}),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formatTime(playerPosition)),
                            Text(formatTime(playerDuration - playerPosition))
                          ],
                        ),
                      ),
                      CircleAvatar(
                        radius: 35,
                        child: IconButton(
                          icon:
                              Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                          iconSize: 50,
                          onPressed: () async {
                            if (isPlaying) {
                              await audioPlayer.pause();
                            } else {
                              await audioPlayer
                                  .play(ap.UrlSource(url.toString()));
                              uploadFile().whenComplete(() => print("succ"));
                            }
                          },
                        ),
                      )
                    ],
                  )
                : Text("data")
          ],
        ),
      ),
    );
  }
}
