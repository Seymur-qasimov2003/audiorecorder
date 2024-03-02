import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';

class AudioRecorderPage extends StatefulWidget {
  const AudioRecorderPage({super.key});

  @override
  State<AudioRecorderPage> createState() => _AudioRecorderPageState();
}

class _AudioRecorderPageState extends State<AudioRecorderPage> {
  late var audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  String audioPath = '';
  List<String> audioList = [];
  List<bool> isPlaying = [];
  var scrollController = ScrollController();

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    audioRecord = Record();
// TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    audioRecord.dispose();
    audioPlayer.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> startRecording() async {
    try {
      if (await audioRecord.hasPermission()) {
        await audioRecord.start();
        setState(() {
          isRecording = true;
        });
      } else {
        print('No permission');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await audioRecord.stop();

      setState(() {
        isRecording = false;
        audioPath = path!;
        audioList.add(audioPath);
        isPlaying.add(false);
        print(audioList.length);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> playAudio(String audioPathh, int indexx) async {
    try {
      Source audioSource = UrlSource(
        audioPathh,
      );
      setState(() {
        isPlaying[indexx] = true;
      });
      await audioPlayer.play(
        audioSource,
      );
    } catch (e) {
      print(e);
    }
  }

  ///stopAudio
  Future<void> stopAudio(int index) async {
    try {
      await audioPlayer.stop();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('audioList: $audioList');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Recorder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                if (isRecording) {
                  stopRecording();
                } else {
                  startRecording();
                }
              },
              child: isRecording
                  ? const Text('Stop Recording')
                  : const Text('Start Recording'),
            ),
            SizedBox(
              height: 20,
            ),
            if (audioPath != null && !isRecording)
              Expanded(
                child: Scrollbar(
                // thumbVisibility: true,
                 // trackVisibility: true,
                  controller: scrollController
                    ..addListener((){
                      print('scrolling');

                    }),
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: audioList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          child: isPlaying[index]
                              ? InkWell(
                                  onTap: () {
                                    stopAudio(index);
                                    setState(
                                      () {
                                        isPlaying[index] = false;
                                      },
                                    );
                                  },
                                  child: const Icon(
                                    Icons.pause,
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    playAudio(audioList[index], index);
                                    setState(
                                      () {
                                        isPlaying[index] = true;

                                        ///digerleri durdur]
                                        for (int i = 0;
                                            i < isPlaying.length;
                                            i++) {
                                          if (i != index) {
                                            isPlaying[i] = false;
                                          }
                                        }
                                      },
                                    );
                                  },
                                  child: Icon(
                                    Icons.play_arrow,
                                  ),
                                ),
                        ),
                        title: Text('Audio ${index + 1}'),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
