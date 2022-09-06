import 'dart:convert';
import 'dart:core';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:gameover/configgamephl.dart';
import 'package:gameover/gamephlclass.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

//<PMLV2>
class AdminVideos extends StatefulWidget {
  const AdminVideos({Key? key}) : super(key: key);

  @override
  State<AdminVideos> createState() => _AdminVideosState();
}

class _AdminVideosState extends State<AdminVideos> {
  static bool getPhotoCatState = false;
  static bool getPhotoBaseState = false;
  bool isAdminConnected = false;
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  TextEditingController legendeController = TextEditingController();
  int totalSeconds = 100;
  bool timeOut = false;
  bool boolCategory = false;
  int cetteVideo = 0;
  int getPhotoCatError = -1;
  int nbPhotoCat = 0;
  int getPhotoBaseError = -1;
  List<int> photoidSelected = []; // retenues avec les Catégotire

  List<PhotoCat> listPhotoCat = [];
  List<PhotoBase> listPhotoBase = [];
  List<PhotoBase> listPhotoBaseWork = [];
  List<Icon> selIcon = [];
  Icon catIcon = const Icon(Icons.remove);
  int nbPhotoRandom = 0;
  int photoIdRandom = 0;
  int cestCeluiLa = 0;

//
  String ipv4name = "**.**.**";
  Icon thisIconclose = const Icon(Icons.lock_rounded);
  Icon thisIconopen = const Icon(Icons.lock_open_rounded);
  bool lockMemeState = true;
  bool lockPhotoState = true;
  Icon mmIcon = const Icon(Icons.lock_open_rounded);
  Icon phIcon = const Icon(Icons.lock_open_rounded);
  bool repaintPRL = false;
  bool visStar = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
    appBar: AppBar(actions: <Widget>[
        Expanded(
          child: Row(
            children: [
              ElevatedButton(
                  onPressed: () => {Navigator.pop(context)},
                  style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      textStyle: const TextStyle(
                          fontSize: 14,
                          backgroundColor: Colors.red,
                          fontWeight: FontWeight.bold)),
                  child: const Text('Exit')),
                  Text("ID --> " + listPhotoBase[cetteVideo].photoid.toString()),
            ]
          ),
        ),
      ]),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the VideoPlayerController has finished initialization, use
            // the data it provides to limit the aspect ratio of the video.
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              // Use the VideoPlayer widget to display the video.
              child: VideoPlayer(_controller),
            );
          } else {
            // If the VideoPlayerController is still initializing, show a
            // loading spinner.
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: Row(
        children: [

          IconButton(
              icon: const Icon(Icons.arrow_back),
              iconSize: 35,
              color: Colors.blue,
              tooltip: 'Prev',
              onPressed: () {
                prevPRL();
                //createMeme();
                //stopTimer();
              }),
          IconButton(
              icon: const Icon(Icons.arrow_forward),
              iconSize: 35,
              color: Colors.blue,
              tooltip: 'Next',
              onPressed: () {
                nextPRL();
              }),
        ],
      ),
    ));
  }

  Future getPhotoBase() async {
    Uri url = Uri.parse(pathPHP + "readVIDEOBASE.php");
    getPhotoBaseState = false;
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        listPhotoBase =
            datamysql.map((xJson) => PhotoBase.fromJson(xJson)).toList();
        getPhotoBaseState = true;
        cestCeluiLa = 0;

      });
    } else {}
  }


  @override
  void initState() {
    super.initState();

    setState(() {
      getPhotoBase();

      selIcon.clear();
      selIcon.add(const Icon(Icons.remove));
      selIcon.add(const Icon(Icons.add));

      mmIcon = thisIconopen;
      phIcon = thisIconopen;

      lockPhotoState = false;

      // Create and store the VideoPlayerController. The VideoPlayerController
      // offers several different constructors to play videos from assets, files,
      // or the internet.
      _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      );
      _initializeVideoPlayerFuture = _controller.initialize();
      // Use the controller to loop the video.
      _controller.setLooping(true);


    });
  }

  lockPhoto() {
    setState(() {
      lockPhotoState = !lockPhotoState;
      if (lockPhotoState) {
        phIcon = thisIconclose;
      } else {
        phIcon = thisIconopen;
      }
    });
  }

  void manageLocks(index) {
    setState(() {
      if (listPhotoCat[index].selected == 1) {
        catIcon = const Icon(Icons.add);
      } else {
        catIcon = const Icon(Icons.remove);
      }
    });
  }

  nextPRL() {

    setState(() {
      cetteVideo++;
      if (cetteVideo > listPhotoBase.length) {
        cetteVideo = listPhotoBase.length - 1;
      }
      _controller = VideoPlayerController.network(
        'https://lamemopole.com/videopol/' +
            listPhotoBase[cetteVideo].photofilename +
            "." +
            listPhotoBase[cetteVideo].photofiletype,
      );

      // Initialize the controller and store the Future for later use.
   _initializeVideoPlayerFuture = _controller.initialize();
      // Use the controller to loop the video.
      _controller.setLooping(true);
      _controller.play();
    });
  }

  prevPRL() {

    setState(() {
      cetteVideo--;
      if (cetteVideo < 0) {
        cetteVideo = 0;
      }
      _controller = VideoPlayerController.network(
        'https://lamemopole.com/videopol/' +
            listPhotoBase[cetteVideo].photofilename +
            "." +
            listPhotoBase[cetteVideo].photofiletype,
      );

      // Initialize the controller and store the Future for later use.
 _initializeVideoPlayerFuture = _controller.initialize();
      // Use the controller to loop the video.
      _controller.setLooping(true);
      _controller.play();
    });
  }
}
