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
import 'package:flutter/material.dart';
import 'package:gameover/configgamephl.dart';
import 'package:gameover/gamevotepipol.dart';
import 'package:gameover/gamephlclass.dart';
import 'package:gameover/phlcommons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

//<PMLV2>
// Ici  On entre avec Un gamecode
class GameVoteResultPlus extends StatefulWidget {
  const GameVoteResultPlus({Key? key}) : super(key: key);

  @override
  State<GameVoteResultPlus> createState() => _GameVoteResultPlusState();
}

class _GameVoteResultPlusState extends State<GameVoteResultPlus> {
  TextEditingController legendeController = TextEditingController();
  String mafoto = 'assets/oursmacron.png';
  bool resultGameVoteState = false;
  bool readGameLikeState = false;
  int readGameLikeError = 0;
  int getGameVoteError = 0;
  List<GameLike> listGameLike = [];
  bool readGameLikeVoteState = false;

  List<GameByUser> myGames = [];
  List<GameVotesResultMeme> listGameVotesResultMeme = [];
  int cestCeluiLa = 0;
  bool repaintPRL = true;
  bool booLike = false;
  final now = DateTime.now();
  late int myUid;
  String ordinal = "ème";

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
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    myPerso.myPseudo + " ",
                    style: GoogleFonts.averageSans(fontSize: 20.0),
                  ),
                ),
                Text(
                  PhlCommons.thisGameCode.toString(),
                  style: GoogleFonts.averageSans(fontSize: 20.0),
                ),
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
                  Center(
                      child: Row(
                    children: [
                      listGameLike.length - cestCeluiLa < 4
                          ? Text(
                              medals[listGameLike.length - cestCeluiLa],
                              style: const TextStyle(
                                  fontSize: 45, color: Colors.black),
                            )
                          : Text(''),
                      Text(
                        "Le Meme de " +
                            listGameLike[cestCeluiLa].uname +
                            ' est ' +
                            (listGameLike.length - cestCeluiLa).toString() +
                            ordinal +
                            " sur " +
                            listGameLike.length.toString() +
                            ' avec ' +
                            listGameLike[cestCeluiLa].mynote.toString() +
                            " Points !",
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  )),
                ]),
              )
            : const Text(''),
        bottomNavigationBar: Row(children: [
          IconButton(
              icon: const Icon(Icons.arrow_back),
              iconSize: 35,
              color: Colors.blue,
              tooltip: 'Prev',
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
          ElevatedButton(
            child: Text(
              " Best Candidates",
              style: GoogleFonts.averageSans(fontSize: 16.0),
            ),
            onPressed: () {
              //  PhlCommons.thisGameCode =  GameCode;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameVotePipol(),
                  settings: RouteSettings(
                    arguments: myPerso,
                  ),
                ),
              );
            },
          ),
        ]),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    cestCeluiLa = 0;
    readGameLike(); // Seule Lecture
    // resultGameVote();
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
      if (cestCeluiLa == listGameLike.length - 1) {
        ordinal = "er";
      } else {
        ordinal = "ème";
      }

      repaintPRL = true;
    });
  }

  prevPRL() {
    setState(() {
      cestCeluiLa--;
      if (cestCeluiLa < 0) cestCeluiLa = 0;
      if (cestCeluiLa == listGameLike.length - 1) {
        ordinal = "er";
      } else {
        ordinal = "ème";
      }
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
        readGameLikeState = true;

        resultGameVote();
      });
    } else {}
  }

  Future resultGameVote() async {
    Uri url = Uri.parse(pathPHP + "resultGameVote.php");
    resultGameVoteState = false;

    var data = {
      "GAMECODE": PhlCommons.thisGameCode.toString(),
    };

    http.Response response = await http.post(url, body: data);

    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        listGameVotesResultMeme = datamysql
            .map((xJson) => GameVotesResultMeme.fromJson(xJson))
            .toList();
        resultGameVoteState = true;

        // Mise a Joir  des notes <TODO>
        for (GameVotesResultMeme _thisVote in listGameVotesResultMeme) {
          for (GameLike _gamelike in listGameLike) {
            if (_gamelike.memeid == _thisVote.memeid) {
              _gamelike.mynote = _thisVote.sumg;
            }
          }
        }
        listGameLike.sort((a, b) => a.mynote.compareTo(b.mynote));
      });
    } else {}
  } // /u20224
}
