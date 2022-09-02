import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:gameover/configgamephl.dart';
import 'package:gameover/gamephlclass.dart';
import 'package:http/http.dart' as http;
//<PMLV2>
class AdminMemotos extends StatefulWidget {
  const AdminMemotos({Key? key}) : super(key: key);

  @override
  State<AdminMemotos> createState() => _AdminMemotosState();
}

class _AdminMemotosState extends State<AdminMemotos> {
  bool isAdminConnected = false;

  List<Memoto> listMemoto = [];
  bool getMemotoState = false;
  bool deleteMemotoState = false;
  bool msgDelete = false;
  int getMemotoError = -1;

  int ceMemoto = 0;
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
                  child: Text("Caption N°" + ceMemoto.toString()),
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
                    child: Text("Sure to  Delete Caption   " +
                        ceMemoto.toString() +
                        "??"),
                  ),
                ),
              ),
              Visibility(
                visible: msgDelete,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      msgDelete = false;
                      deleteMemoto();
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
        child: Column(children: <Widget>[
          getViewMemotos(),
        ]),
      ),
    ));
  }

  Future deleteMemoto() async {
    Uri url = Uri.parse(pathPHP + "deleteMEMOTO.php");

    if (ceMemoto == 0) {
      return;
    }
    deleteMemotoState = false;
    var data = {"MEMOSTOCKID": ceMemoto.toString()};
    http.Response response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      getMemoto();
    } else {}
  }

  Future getMemoto() async {
    Uri url = Uri.parse(pathPHP + "cleanMEMOTO.php");
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

  Expanded getViewMemotos() {
    var listView = ListView.builder(
        itemCount: listMemoto.length,
        controller: ScrollController(),
        itemBuilder: (context, index) {
          return ListTile(
              dense: true,
              title: Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Text(listMemoto[index].memostockid.toString() +
                          '->' +
                          listMemoto[index].memostock),
                    ],
                  )),
                ],
              ),
              onTap: () {
                setState(() {
                  ceMemoto = listMemoto[index].memostockid;
                });
              });
        });

    return (Expanded(child: listView));
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      getMemoto();
    });
  }
}
