import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:gameover/configgamephl.dart';
import 'package:gameover/gamephlclass.dart';
import 'package:http/http.dart' as http;

//<PMLV2>
class AdminGames extends StatefulWidget {
  const AdminGames({Key? key}) : super(key: key);

  @override
  State<AdminGames> createState() => _AdminGamesState();
}

class _AdminGamesState extends State<AdminGames> {
  bool isAdminConnected = false;
  bool archiveGameState = false;
  bool getAllGamesState = true;
  int getAllGamesError = 0;

  bool msgDelete = false;

  int cestCeluiLa = 0;
  List<Games> myGames = [];
  Icon thisIconclose = const Icon(Icons.lock_rounded);
  Icon thisIconopen = const Icon(Icons.lock_open_rounded);
  bool lockMemeState = true;
  bool lockPhotoState = true;
  Icon mmIcon = const Icon(Icons.lock_open_rounded);
  Icon phIcon = const Icon(Icons.lock_open_rounded);
  bool repaintPRL = false;
  bool visStar = true;

  Future archiveGame() async {
    Uri url = Uri.parse(pathPHP + "deleteMEMOTO.php");

    archiveGameState = false;
    var data = {"GAMEID": "1"};
    http.Response response = await http.post(url, body: data);
    if (response.statusCode == 200) {
    } else {}
  }

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
                      primary: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      textStyle: const TextStyle(
                          fontSize: 14,
                          backgroundColor: Colors.blue,
                          fontWeight: FontWeight.bold)),
                  child: const Text('Exit')),
              IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.red,
                iconSize: 40.0,
                tooltip: ' ',
                onPressed: () {
                  setState(() {
                    msgDelete = true;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton(
                  onPressed: () => {},
                  style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      textStyle: const TextStyle(
                          fontSize: 14,
                          backgroundColor: Colors.green,
                          fontWeight: FontWeight.bold)),
                  child: Text("Caption N°"),
                ),
              ),
              Visibility(
                visible: msgDelete,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    onPressed: () {
                      msgDelete = false;
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        textStyle: const TextStyle(
                            fontSize: 14,
                            backgroundColor: Colors.black,
                            fontWeight: FontWeight.bold)),
                    child: const Text("Sure to  Delete Caption   " "??"),
                  ),
                ),
              ),
              Visibility(
                visible: msgDelete,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      msgDelete = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      textStyle: const TextStyle(
                          fontSize: 14,
                          backgroundColor: Colors.red,
                          fontWeight: FontWeight.bold)),
                  child: Text("Yes ?"),
                ),
              ),
              Visibility(
                visible: msgDelete,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        msgDelete = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        textStyle: const TextStyle(
                            fontSize: 14,
                            backgroundColor: Colors.black,
                            fontWeight: FontWeight.bold)),
                    child: Text("No ?"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
      body: SafeArea(
        child: Column(children: const <Widget>[]),
      ),
    ));
  }

  Future getAllGames() async {
    bool gameCodeFound = true;
    Uri url = Uri.parse(pathPHP + "getALLGAMES.php");
    var data = {
      "UID": "FAKE",
    };
    getAllGamesState = false;
    http.Response response = await http.post(url, body: data);
    if (response.body.toString() == 'ERR_1001') {
      gameCodeFound = false;
      getAllGamesState = false;
      getAllGamesError = 1001;
    } else {
      gameCodeFound = true;
    }

    if (response.statusCode == 200 && (gameCodeFound)) {
      var datamysql = jsonDecode(response.body) as List;

      myGames = datamysql.map((xJson) => Games.fromJson(xJson)).toList();

      getAllGamesState = true;
      getAllGamesError = 0;
    } else {}
  }

  Expanded getViewGames() {
    var listView = ListView.builder(
        itemCount: myGames.length,
        controller: ScrollController(),
        itemBuilder: (context, index) {
          return ListTile(
              dense: true,
              title: Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Text(myGames[index].gamecode.toString() +
                          '->' +
                          myGames[index].gmid.toString()),
                    ],
                  )),
                ],
              ),
              onTap: () {
                setState(() {
                  //     ceMemoto = listMemoto[index].memostockid;
                });
              });
        });

    return (Expanded(child: listView));
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      getAllGames();
    });
  }
}
