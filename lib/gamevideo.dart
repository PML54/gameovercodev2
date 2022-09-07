import 'dart:convert';
import 'dart:core';
import 'dart:math';

import 'dart:async';
import 'package:gameover/configgamephl.dart';
import 'package:gameover/gamephlclass.dart';
import 'package:gameover/phlcommons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';


//<PMLV2>
class VideoPlayerApp extends StatelessWidget {
  const VideoPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'VideoPol',
      home: VideoPlayerScreen(),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool feuVert = false;
  List<PhotoBase> listVideoBase = [];
  int memoStockidRandom = 0;
  bool getVideoBaseState = false;
  int cetteVideo = 0;
  List<Memoto> listMemoto = [];
  bool getMemotoState = false;
  int getMemotoError = -1;

  Icon thisIconclose = const Icon(Icons.lock_rounded);
  Icon thisIconopen = const Icon(Icons.lock_open_rounded);
  bool lockMemeState = true;
  bool lockPhotoState = true;
  Icon mmIcon = const Icon(Icons.lock_open_rounded);
  Icon phIcon = const Icon(Icons.lock_open_rounded);
  String memeLegende = "";
  bool visStar = true;
  late int myUid;
  late String myPseudo;

  @override
  void initState() {
    super.initState();
    cetteVideo = 0;
    getVideoBase();
    getMemoto();

   // thatPRL = 0;

    mmIcon = thisIconopen;
    phIcon = thisIconopen;
    lockMemeState = false;
    lockPhotoState = false;


    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.

    //https://github.com/PML54/videopol
    _controller = VideoPlayerController.network(
      'https://lamemopole.com/videopol/PHL_01_MM-VIDEOMEME_29565375.mp4',

     // 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myPerso = ModalRoute.of(context)!.settings.arguments as GameCommons;
    myUid = myPerso.myUid;
    myPseudo = myPerso.myPseudo;

    return Scaffold(
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
              IconButton(
                icon: mmIcon,
                color: Colors.black,
                iconSize: 30.0,
                tooltip: 'Lock Memes',
                onPressed: () {
                  lockMeme();
                },
              ),
              IconButton(
                icon: phIcon,
                color: Colors.black,
                iconSize: 30.0,
                tooltip: 'Lock Photos',
                onPressed: () {
                  lockPhoto();
                },
              ),
              Visibility(
                visible: visStar,
                child: IconButton(
                  icon: const Icon(Icons.star),
                  color: Colors.red,
                  iconSize: 30.0,
                  tooltip: 'Favori',
                  onPressed: () {
                    createMemolikeVideo();
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                color: Colors.deepPurpleAccent,
                iconSize: 35.0,
                tooltip: 'Save Meme',
                onPressed: () {
                  //createMemeSolo();
                  //
                },
              ),
             // Text(photoIdRandom.toString()),
            ],
          ),
        ),
      ]),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body:
      Column(

        children: [
          Container(
              alignment: Alignment.topLeft,
              child: Text(
                memeLegende,
                style: GoogleFonts.averageSans(fontSize: 18.0),
              )),

          Container(
            child: Expanded(

              child:
              FutureBuilder(

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
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Wrap the play or pause in a call to `setState`. This ensures the
          // correct icon is shown.
          setState(() {
            // If the video is playing, pause it.
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // If the video is paused, play it.
              _controller.play();
            }
          });
        },
        // Display the correct icon depending on the state of the player.
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
      bottomNavigationBar: Row(children: [

        IconButton(
            icon: const Icon(Icons.gavel),
            iconSize: 30,
            color: Colors.blue,
            tooltip: 'Next',
            onPressed: () {
              int random = Random().nextInt(listVideoBase.length-1); //Suppe 1
              int randomMeme = Random().nextInt(listMemoto.length);
                     setState(() {
                if (!lockMemeState) {
                  memeLegende = listMemoto[randomMeme].memostock;
                }
                memoStockidRandom = listMemoto[randomMeme].memostockid;

                cetteVideo = Random().nextInt(listVideoBase.length);

                if (cetteVideo > listVideoBase.length) {
                  cetteVideo = 0;
                }
                _controller = VideoPlayerController.network(

                  'https://lamemopole.com/videopol/' +
                      listVideoBase[cetteVideo].photofilename +
                      "." +
                      listVideoBase[cetteVideo].photofiletype,
                );

                // Initialize the controller and store the Future for later use.
                _initializeVideoPlayerFuture = _controller.initialize();
                // Use the controller to loop the video.
                _controller.setLooping(true);
                _controller.play();

              });

            }),
      ]),
    );
  }



  Future getVideoBase() async {

    Uri url = Uri.parse(pathPHP + "readVIDEOBASE.php");
    getVideoBaseState = false;
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        listVideoBase =
            datamysql.map((xJson) => PhotoBase.fromJson(xJson)).toList();
        getVideoBaseState = true;
        //   cestCeluiLa = Random().nextInt(listPhotoBase.length);
        //getPhotoCat();
        feuVert = true;

      });
    } else {

      feuVert = false;
    }
  }
  Future getMemoto() async {
    Uri url = Uri.parse(pathPHP + "getMEMOTO.php");
    getMemotoState = false;
    getMemotoError = 0;
    http.Response response = await http.post(url);
    if (response.body.toString() == 'ERR_1001') {
      getMemotoError = 1001; //Not Found
    }

    if (response.statusCode == 200 && (getMemotoError != 1001)) {
      var datamysql = jsonDecode(response.body) as List;

      setState(() {
        getMemotoError = 0;
        listMemoto = datamysql.map((xJson) => Memoto.fromJson(xJson)).toList();
        getMemotoState = true;
      });
    } else {}
  }
  lockMeme() {
    setState(() {
      lockMemeState = !lockMemeState;
      if (lockMemeState) {
        mmIcon = thisIconclose;
      } else {
        mmIcon = thisIconopen;
      }
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
  Future createMemolikeVideo() async {
    Uri url = Uri.parse(pathPHP + "createMEMOLIKEVIDEO.php");

    var data = {
      "PHOTOID": listVideoBase[cetteVideo].photoid.toString(),
      "MEMOSTOCKID": memoStockidRandom.toString(),
      "MEMOLIKEUSER": myPseudo,
    };
http.Response response =  await http.post(url, body: data);
print ("response.statusCode"+response.statusCode.toString());
    //
    getRandom();
  }
  getRandom() {

    setState(() {
      int randomMeme = Random().nextInt(listMemoto.length - 1);

      if (!lockPhotoState) {
        cetteVideo = Random().nextInt(listVideoBase.length - 1);

      }


      if (!lockMemeState) {
        memeLegende = listMemoto[randomMeme].memostock;
        memoStockidRandom = listMemoto[randomMeme].memostockid;
      }
      visStar = true;
    });

  }
  getIndexFromPhotoId(_thatPhotoId) {
    int index = 0;
    for (PhotoBase _brocky in listVideoBase) {
      if (_brocky.photoid == _thatPhotoId) {
        return (index);
      }
      index++;
    }
    return (0);
  }

}
