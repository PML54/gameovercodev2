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

import 'dart:core';
import 'package:flutter/material.dart';
//<PMLV2>

class GameHelp extends StatefulWidget {
  const GameHelp({Key? key}) : super(key: key);

  @override
  State<GameHelp> createState() => _GameHelpState();
}

class _GameHelpState extends State<GameHelp> {
  int cestCeluiLa = 1;
  bool repaintPRL = true;
  String monaide = "help/Help1.jpeg";

  @override
  Widget build(BuildContext context) {
/*
    final myPerso = ModalRoute
        .of(context)!
        .settings
        .arguments as GameCommons;
*/

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(actions: <Widget>[
          Row(children: [
            ElevatedButton(
                onPressed: () => {Navigator.pop(context)},
                child: const Text('Exit')),
          ])
        ]),
        body: Container(
          height: 500,
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height
                  //set minimum height equal to 100% of VH
                  ),
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Image.network(monaide),
        ),
        bottomNavigationBar: Row(children: [
          IconButton(
              icon: const Icon(Icons.arrow_back),
              iconSize: 35,
              color: Colors.blue,
              tooltip: 'Prev',
              onPressed: () {
                prevPRL();
              }),
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

  @override
  void initState() {
    super.initState();
    cestCeluiLa = 0;
  }

  nextPRL() {
    setState(() {
      cestCeluiLa++;
      if (cestCeluiLa > 7) cestCeluiLa = 1;

      monaide = "help/Help" + cestCeluiLa.toString() + ".jpeg";
    });
  }

  prevPRL() {
    setState(() {
      cestCeluiLa--;
      if (cestCeluiLa < 1) cestCeluiLa = 1;
      repaintPRL = true;

      monaide = "help/Help" + cestCeluiLa.toString() + ".jpeg";
    });
  }
}
