import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:gameover/configgamephl.dart';
import 'package:gameover/gamephlclass.dart';
import 'package:gameover/gamephlplusclass.dart';
import 'package:gameover/phlcommons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

//<PMLV2>
// Ici  On entre avec Un gamecode
class GameVotePipol extends StatefulWidget {
  const GameVotePipol({Key? key}) : super(key: key);
  @override
  State<GameVotePipol> createState() => _GameVotePipolState();
}

class _GameVotePipolState extends State<GameVotePipol> {
  TextEditingController legendeController = TextEditingController();
  String mafoto = 'assets/oursmacron.png';
  bool resultGameVoteState = false;
  bool readGameLikeState = false;
  int readGameLikeError = 0;
  int getGameVoteError = 0;
  List<GameLike> listGameLike = [];
  bool readGameLikeVoteState = false;
  List<Pipole> listUidReceived = [];
  List<Pipole> listUidGiven = [];
  bool resultGameVoteUidGiven = false;
  bool resultGameVoteUidReceived = false;
  List<MemopolUsersReduce> listMemopolUsers = [];
  List<GameByUser> myGames = [];
  List<GameVotesResultMeme> listGameVotesResultMeme = [];
  int cestCeluiLa = 0;
  bool repaintPRL = true;
  bool booLike = false;
  final now = DateTime.now();
  late int myUid;
  String ordinal = "ème";
  bool selMemopolUsersState = false;

  @override
  Widget build(BuildContext context) {
    final myPerso = ModalRoute.of(context)!.settings.arguments as GameCommons;
    myUid = myPerso.myUid;
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(actions: <Widget>[
            Expanded(
              child: Row(children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
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
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    myPerso.myPseudo + " ",
                    style: GoogleFonts.averageSans(fontSize: 15.0),
                  ),
                ),
                Text(
                  PhlCommons.thisGameCode.toString(),
                  style: GoogleFonts.averageSans(fontSize: 15.0),
                ),
              ]),
            ),
          ]),
          body: SafeArea(
            child: Column(children: <Widget>[
              Text(
                "CLASSEMENT TOTAL DES POINTS",
                style: GoogleFonts.averageSans(fontSize: 20.0),
              ),
              getListUidReceived(),
              //  getListUidGiven(),
            ]),
          )),
    );
  }

  int getGivenWithUid(int _uid) {
    int onePoint = 0;

    for (Pipole _pipole in listUidGiven) {
      if (_pipole.uid == _uid) {
        onePoint = _pipole.cumul;
      }
    }
    return (onePoint);
  }

  Expanded getListUidGiven() {
    if (!resultGameVoteUidGiven) {
      return (const Expanded(child: Text(".............")));
    }
    var listView = ListView.builder(
        itemCount: listUidGiven.length,
        controller: ScrollController(),
        itemBuilder: (context, index) {
          return ListTile(
              dense: true,
              title: Row(
                children: [
                  CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Text(
                        getNameWithUid(listUidGiven[index].uid).toString(),
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      )),
                  Text(
                    " a donné " + listUidGiven[index].cumul.toString() + " pts",
                    style: TextStyle(
                        color: Colors.black,
                        // decoration:(Gamers[index].uprofile == 5) ? TextDecoration.underline :TextDecoration.none,
                        fontSize: 15),
                  ),
                ],
              ),
              onTap: () {
                setState(() {});
              });
        });
    return (Expanded(child: listView));
  }

  Expanded getListUidReceived() {
    if (!resultGameVoteUidReceived) {
      return (const Expanded(child: Text(".............")));
    }
    var listView = ListView.builder(
        itemCount: listUidReceived.length,
        controller: ScrollController(),
        itemBuilder: (context, index) {
          return ListTile(
              dense: true,
              title: Row(
                children: [
                  Text(
                      'N°' +
                          (index + 1).toString() +
                          " " +
                          getNameWithUid(listUidReceived[index].uid).toString(),
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                  Text(
                    ": " +
                        listUidReceived[index].cumul.toString() +
                        " pts! " +
                        "(" +
                        getGivenWithUid(listUidReceived[index].uid).toString() +
                        " pts donnés)",
                    style: TextStyle(
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                        fontSize: 16),
                  ),
                ],
              ),
              onTap: () {
                setState(() {});
              });
        });
    return (Expanded(child: listView));
  }

  String getNameWithUid(int _uid) {
    String thisParam = "xxx";

    for (MemopolUsersReduce _brocky in listMemopolUsers) {
      if (_brocky.uid == _uid) {
        thisParam = _brocky.uname;
      }
    }
    return (thisParam);
  }

  @override
  void initState() {
    super.initState();
    cestCeluiLa = 0;

    selMemopolUsers();
    setState(() {});
    resultUidReceived();
    resultUidGiven();
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

  Future resultUidGiven() async {
    Uri url = Uri.parse(pathPHP + "resultGameVoteUidGiven.php");
    resultGameVoteUidGiven = false;
    var data = {
      "GAMECODE": PhlCommons.thisGameCode.toString(),
    };
    http.Response response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        listUidGiven =
            datamysql.map((xJson) => Pipole.fromJson(xJson)).toList();
        resultGameVoteUidGiven = true;
      });
    } else {}
  } // /u20224

  Future resultUidReceived() async {
    Uri url = Uri.parse(pathPHP + "resultGameVoteUidReceived.php");
    resultGameVoteUidReceived = false;
    var data = {
      "GAMECODE": PhlCommons.thisGameCode.toString(),
    };
    http.Response response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        listUidReceived =
            datamysql.map((xJson) => Pipole.fromJson(xJson)).toList();
        resultGameVoteUidReceived = true;
        listUidReceived.sort((a, b) => b.cumul.compareTo(a.cumul));
      });
    } else {}
  } // /u20224

  Future selMemopolUsers() async {
    // Lire TABLE   GAMEPHOTOSELECT  et mettre dans  listgetGamePhotoSelect
    Uri url = Uri.parse(pathPHP + "selMEMOPOLUSERS.php");
    int selMemopolUsersError = 0;
    var data = {
      //<TODO>
      "GAMECODE": "PLUSTARD",
    };

    selMemopolUsersState = false;
    http.Response response = await http.post(url, body: data);
    selMemopolUsersError = 0;

    if (response.body.toString() == 'ERR_1001') {
      selMemopolUsersError = 1001;
    }

    if (response.statusCode == 200 && selMemopolUsersError == 0) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        selMemopolUsersState = true;
        listMemopolUsers = datamysql
            .map((xJson) => MemopolUsersReduce.fromJson(xJson))
            .toList();
      });
    } else {}
  }
}
