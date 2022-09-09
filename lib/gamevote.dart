// FAVORI
// 5 Juillet

// On Va boucler sur la TAble MEMEID

//  On prend la Partie   gameecode    concernée

//MEMEID   | int         | NO   | PRI | NULL    | auto_increment |
//PHOTOID  | int         | NO   |     | NULL    |                |
//GAMECODE | int         | NO   | MUL | NULL    |                |
// UID      | int         | NO   |     | NULL    |                |
// MEMETEXT | varchar(50) | YES  |     | NULL    |                |
//listMemoLike[cestCeluiLa].photofilename +
//listMemoLike[cestCeluiLa].photofiletype,

import 'dart:convert';
import 'dart:core';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:gameover/configgamephl.dart';
import 'package:gameover/gamephlclass.dart';
import 'package:gameover/phlcommons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

//<PMLV2>
// Ici  On entre avec Un gamecode

// Le 3 Aout . J'ai Viré le Timer <PHL>
class GameVote extends StatefulWidget {
  const GameVote({Key? key}) : super(key: key);

  @override
  State<GameVote> createState() => _GameVoteState();
}

class _GameVoteState extends State<GameVote> {
  String ipv4name = "**.**.**";
  int memoStockidRandom = 0;
  bool readGameLikeState = false;
  bool createGameVoteState = false;
  int readGameLikeError = 0;
  int getGameVoteError = 0;
  List<GameLike> listGameLike = [];

  bool readGameLikeVoteState = false;
  List<int> listCountEmo = [];
  List<CheckVotePlus> listCheckVote = [];

  List<GameByUser> myGames = [];

  int cestCeluiLa = 0;
  bool repaintPRL = true;

  bool booLike = false;

  final now = DateTime.now();

  double thatAverage = 0;
  late int myUid;

  //
  bool changeStatusGameUserState = false;
  bool getGamebyCodeState = false;
  int getGamebyCodeError = 0;
  List<Games> myGuGame = []; //  only one Games`
  //
  Duration countdownDuration = const Duration(seconds: 10000);
  int timerVoteGame = 0;

  @override
  Widget build(BuildContext context) {
    final myPerso = ModalRoute.of(context)!.settings.arguments as GameCommons;
    myUid = myPerso.myUid;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(actions: <Widget>[
          Expanded(
            child: Row(
              children: [
                ElevatedButton(
                    onPressed: () => {cleanExit()},
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        textStyle: const TextStyle(
                            fontSize: 14,
                            backgroundColor: Colors.blue,
                            fontWeight: FontWeight.bold)),
                    child: const Text('Save&Exit')),
                ElevatedButton(
                    onPressed: () => {null},
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        textStyle: const TextStyle(
                            fontSize: 14,
                            backgroundColor: Colors.green,
                            fontWeight: FontWeight.bold)),
                    child: Text(myPerso.myPseudo)),
                Text(PhlCommons.thisGameCode.toString()),
                Text(" Vote ->" + createGameVoteState.toString()),

                // Align(child: buildTime()),
              ],
            ),
          ),
        ]),
        body: readGameLikeState
            ? SafeArea(
                child: Column(children: <Widget>[
                  Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        listGameLike[cestCeluiLa].memetext,
                        style: GoogleFonts.averageSans(fontSize: 18.0),
                      )),
                  Container(
                    alignment: Alignment.center,
                    child: Image.network(
                      "upload/" +
                          listGameLike[cestCeluiLa].photofilename +
                          "." +
                          listGameLike[cestCeluiLa].photofiletype,
                    ),
                  ),
                  readGameLikeVoteState || true
                      ? Row(
                          children: <Widget>[
                            //🤣
                            Column(
                              children: [
                                TextButton(
                                  onPressed: () => {pressEmoticone(myUid, 1)},
                                  child: const Text(
                                    '🙁',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                                (listGameLike[cestCeluiLa].mynote == 1)
                                    ? const Text("1")
                                    : const Text("0"),
                              ],
                            ),
                            Column(
                              children: [
                                TextButton(
                                  onPressed: () => {pressEmoticone(myUid, 2)},
                                  child: const Text(
                                    '😐',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                                (listGameLike[cestCeluiLa].mynote == 2)
                                    ? const Text("1")
                                    : const Text("0"),
                              ],
                            ),
                            Column(
                              children: [
                                TextButton(
                                  onPressed: () => {pressEmoticone(myUid, 3)},
                                  child: const Text(
                                    '🙂',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                                (listGameLike[cestCeluiLa].mynote == 3)
                                    ? const Text("1")
                                    : const Text("0"),
                              ],
                            ),
                            Column(
                              children: [
                                TextButton(
                                  onPressed: () => {pressEmoticone(myUid, 4)},
                                  child: const Text(
                                    '😄',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                                (listGameLike[cestCeluiLa].mynote == 4)
                                    ? const Text("1")
                                    : const Text("0"),
                              ],
                            ),
                            Column(
                              children: [
                                TextButton(
                                  onPressed: () => {pressEmoticone(myUid, 5)},
                                  child: const Text(
                                    '😆',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                                (listGameLike[cestCeluiLa].mynote == 5)
                                    ? const Text("1")
                                    : const Text("0"),
                              ],
                            ),
                            Column(
                              children: [
                                TextButton(
                                  onPressed: () => {pressEmoticone(myUid, 6)},
                                  child: const Text(
                                    '🤣',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                                (listGameLike[cestCeluiLa].mynote == 6)
                                    ? const Text("1")
                                    : const Text("0"),
                              ],
                            )
                          ],
                        )
                      : const Text('...'),
                ]),
              )
            : const Text(''),
        bottomNavigationBar: Row(children: [
          IconButton(
              icon: const Icon(Icons.arrow_back),
              iconSize: 35,
              color: Colors.blue,
              tooltip: 'Précédent',
              onPressed: () {
                prevPRL();
              }),
          Text(
            (cestCeluiLa + 1).toString() + '/' + listGameLike.length.toString(),
            style: GoogleFonts.averageSans(fontSize: 18.0),
          ),
          IconButton(
              icon: const Icon(Icons.arrow_forward),
              iconSize: 35,
              color: Colors.blue,
              tooltip: 'Next',
              onPressed: () {
                nextPRL();
              }),
        ]),
      ),
    );
  }

  Future changeStatusGameUser(int _status) async {
    Uri url = Uri.parse(pathPHP + "changeStatusGameUser.php");
    changeStatusGameUserState = false;
    var data = {
      "GAMECODE": PhlCommons.thisGameCode.toString(),
      "UID": PhlCommons.thatUid.toString(),
      "GUSTATUS": (_status).toString(),
    };
    await http.post(url, body: data);
    changeStatusGameUserState = true;
  }

  void cleanExit() {
    changeStatusGameUser(4); //Voting

    Navigator.pop(context);
  }

  Future createGameVote(int _myUid, int _points) async {
    Uri url = Uri.parse(pathPHP + "createGameVote.php");
    setState(() {
      createGameVoteState = false;
    });

    var data = {
      "GAMECODE": PhlCommons.thisGameCode.toString(),
      "GVPOINTS": _points.toString(),
      "GVLAST": now.toString(),
      "MEMEID": listGameLike[cestCeluiLa].memeid.toString(),
      "UID": _myUid.toString()
    };
    var res = await http.post(url, body: data);
    if (res.statusCode == 200) {
      setState(() {
        createGameVoteState = true;
      });
    }
  }

  Future getGamebyCode() async {
    int _thisGameCode = PhlCommons.thisGameCode;
    bool gameCodeFound = true;
    Uri url = Uri.parse(pathPHP + "getGAMEBYCODE.php");
    var data = {
      "GAMECODE": _thisGameCode.toString(),
    };
    http.Response response = await http.post(url, body: data);
    if (response.body.toString() == 'ERR_1001') {
      gameCodeFound = false;
      getGamebyCodeState = false;
      getGamebyCodeError = 1001;
    } else {
      gameCodeFound = true;
    }
    if (response.statusCode == 200 && (gameCodeFound)) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        myGuGame = datamysql.map((xJson) => Games.fromJson(xJson)).toList();
        getGamebyCodeState = true;
        getGamebyCodeError = 0;
        // On le met à  la source
        timerVoteGame = myGuGame[0].gametimevote;
        countdownDuration = Duration(seconds: timerVoteGame);
      });
    } else {}
  }

  Future getIP() async {
    final ipv4 = await Ipify.ipv4();
    setState(() {
      ipv4name = ipv4;
    });
  }

  @override
  void initState() {
    super.initState();
    cestCeluiLa = 0;
    getIP();
    readGameLike(); // Seule Lecture  GameLike
    getGamebyCode(); // H-eu
    changeStatusGameUser(3); //Voting
    listCountEmo.clear();
    for (int i = 0; i < 6; i++) {
      listCountEmo.add(0);
    }

    setState(() {
      if (readGameLikeState) {
        if (readGameLikeVoteState) {
          repaintPRL = true;
        }
      }
    });
  }

  nextPRL() {
    setState(() {
      cestCeluiLa++;
      if (cestCeluiLa >= listGameLike.length) {
        cestCeluiLa = listGameLike.length - 1;
      }
      repaintPRL = true;
    });
  }

  pressEmoticone(int _myUid, int lequel) {
    if (listGameLike[cestCeluiLa].uid == _myUid) return;
    setState(() {
      if (listGameLike[cestCeluiLa].mynote == lequel) {
        listGameLike[cestCeluiLa].mynote = 0;
      } else {
        listGameLike[cestCeluiLa].mynote = lequel;
      }
      createGameVote(_myUid, lequel);
      //nextPRL();
    });
  }

  prevPRL() {
    setState(() {
      cestCeluiLa--;
      if (cestCeluiLa < 0) cestCeluiLa = 0;
      repaintPRL = true;
    });
  }

  Future readGameLike() async {
    Uri url = Uri.parse(pathPHP + "readGAMELIKE.php");
    readGameLikeState = false;
    var data = {
      "GAMECODE": PhlCommons.thisGameCode.toString(),
    };
    http.Response response = await http.post(url, body: data);
    if (response.body.toString() == 'ERR_1001') {
      readGameLikeError = 1001; //Not Found
    }
    if (response.statusCode == 200 && (readGameLikeError != 1001)) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        readGameLikeError = 0;
        listGameLike =
            datamysql.map((xJson) => GameLike.fromJson(xJson)).toList();
       // listGameLike.sort((a, b) => a.mynote.compareTo(b.mynote));

        // trier par Photoid
        listGameLike.shuffle();
        listGameLike.sort((a, b) => a.photoid.compareTo(b.photoid));
        readGameLikeState = true;
      });
    } else {}
  }
}
