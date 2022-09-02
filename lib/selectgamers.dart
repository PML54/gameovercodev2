import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:gameover/configgamephl.dart';
import 'package:gameover/gamephlclass.dart';
import 'package:gameover/phlcommons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

//<PMLV2>
// Creer une Liste de GUID Parmi les Gens qui on un compte
class SelectGamers extends StatefulWidget {
  const SelectGamers({Key? key}) : super(key: key);

  @override
  State<SelectGamers> createState() => _SelectGamersState();
}

class _SelectGamersState extends State<SelectGamers> {
  bool selMemopolUsersState = false;
  int selMemopolUsersError = 0;
  List<MemopolUsersReduce> listMemopolUsers = [];
  List<MemopolUsersReduce> listMemopolUsersReduce = [];
  List<GamePhotoSelect> listGamePhotoSelect = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(actions: <Widget>[
        Expanded(
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.black,
                iconSize: 30.0,
                tooltip: ' Home',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ]),
      body: SafeArea(
        child: Row(children: <Widget>[
          getListView(),
          getListViewSelected(),

          //   getListView(),
        ]),
      ),
      bottomNavigationBar: IconButton(
          icon: const Icon(Icons.save),
          iconSize: 35,
          color: Colors.red,
          tooltip: 'Save Selection',
          onPressed: () {
            PhlCommons.nbGamersGame = listMemopolUsersReduce.length;
            updateSelectionGamers();
          }),
    ));
  }

  Expanded getListView() {
    setState(() {});

    if (!selMemopolUsersState) {
      return (const Expanded(child: Text("Je Joue ........")));
    }
    var listView = ListView.builder(
        itemCount: listMemopolUsers.length,
        controller: ScrollController(),
        itemBuilder: (context, index) {
          return ListTile(
              dense: true,
              title: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(2.0),
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                          color: listMemopolUsers[index].extraColor,
                          border: Border.all()),
                      child: Text(
                        listMemopolUsers[index].uname,
                        style: GoogleFonts.averageSans(fontSize: 15.0),
                      ),
                    ),
                  )
                ],
              ),
              onTap: () {
                setState(() {
                  listMemopolUsers[index].isSelected =
                      !listMemopolUsers[index].isSelected;
                  if (listMemopolUsers[index].isSelected) {
                    listMemopolUsers[index].extraColor = Colors.green;
                  } else {
                    listMemopolUsers[index].extraColor = Colors.grey;
                  }
                });
              });
        });

    return (Expanded(child: listView));
  }

  Expanded getListViewSelected() {
    setState(() {});
    if (!selMemopolUsersState) return (const Expanded(child: Text(".......")));
    setState(() {
      listMemopolUsersReduce.clear();
      for (MemopolUsersReduce _brocky in listMemopolUsers) {
        if (_brocky.isSelected || _brocky.uid == PhlCommons.thatUid) {
          listMemopolUsersReduce.add(_brocky);
        }
      }
    });
    var listView = ListView.builder(
        itemCount: listMemopolUsersReduce.length,
        controller: ScrollController(),
        itemBuilder: (context, index) {
          return ListTile(
              dense: true,
              title: Row(
                children: [
                  Expanded(
                      child: Container(
                    margin: const EdgeInsets.all(2.0),
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                        color: listMemopolUsersReduce[index].extraColor,
                        border: Border.all()),
                    child: Text(listMemopolUsersReduce[index].uname,
                        style: GoogleFonts.averageSans(fontSize: 15.0)),
                  )),
                ],
              ),
              onTap: () {
                setState(() {
                  listMemopolUsersReduce[index].isSelected =
                      !listMemopolUsersReduce[index].isSelected;
                  if (listMemopolUsersReduce[index].isSelected) {
                    listMemopolUsersReduce[index].extraColor = Colors.green;
                  } else {
                    listMemopolUsersReduce[index].extraColor = Colors.grey;
                  }
                });
              });
        });
    return (Expanded(child: listView));
  }

  @override
  void initState() {
    super.initState();
    selMemopolUsers();
  }

  Future selMemopolUsers() async {
    // Lire TABLE   GAMEPHOTOSELECT  et mettre dans  listgetGamePhotoSelect
    Uri url = Uri.parse(pathPHP + "selMEMOPOLUSERS.php");

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

  void updateSelectionGamers() async {
    String thisParam = "";
    int _gamecode = PhlCommons.thisGameCode;
    for (MemopolUsersReduce _brocky in listMemopolUsers) {
      if (_brocky.isSelected || _brocky.uid == PhlCommons.thatUid) {
        thisParam = thisParam + "|" + _brocky.uid.toString();
      }
    }

    Uri url = Uri.parse(pathPHP + "updateGAMEGAMERSSELECT.php");
    var data = {
      //<TODO>
      "GAMECODE": _gamecode.toString(),
      "GROUPSEL": thisParam,
    };
    await http.post(url, body: data);
    Navigator.pop(context);
  }
}
