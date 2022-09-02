import 'dart:core';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:gameover/configgamephl.dart';
import 'package:gameover/phlcommons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

//<PMLV2>
class Memento extends StatefulWidget {
  const Memento({Key? key}) : super(key: key);

  @override
  State<Memento> createState() => _MementoState();
}

class _MementoState extends State<Memento> {
  var legendeController = TextEditingController();
  String mafoto = 'assets/oursmacron.png';
  bool myBool = false;
  String ipv4name = "**.**.**";
  String memeLegende = "";
  late int myUid;

  @override
  Widget build(BuildContext context) {
    final myPerso = ModalRoute.of(context)!.settings.arguments as GameCommons;
    myUid = myPerso.myUid;

    mafoto = 'assets/oursmacron.png';
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
              IconButton(
                  icon: const Icon(Icons.save),
                  iconSize: 35,
                  color: Colors.green,
                  tooltip: 'Save Selection',
                  onPressed: () {
                    createMemeSolo();
                  }),
              const Text(' SVP  Caption'),
            ],
          ),
        ),
      ]),

      body: SafeArea(
        child: Column(children: <Widget>[
          getget(),
        ]),
      ),
      //Container(child: getListViewReduce()),
      bottomNavigationBar: Visibility(
        visible: false,
        child: IconButton(
            icon: const Icon(Icons.save),
            iconSize: 35,
            color: Colors.green,
            tooltip: 'Save Selection',
            onPressed: () {}),
      ),
    ));
  }

  Future createMemeSolo() async {
    Uri url = Uri.parse(pathPHP + "createMEMESOLO.php");
    var data = {
      "MEMOCAT": myUid.toString(),
      "MEMOSTOCK": memeLegende,
    };

    if (memeLegende.length > 2 && memeLegende.length < 250) {
      http.Response response = await http.post(url, body: data);

      if (response.body.toString() == 'ERROR_OK') {
      } else {}
    }
  }

  Expanded getget() {
    setState(() {});
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(25.0),
      child: (Column(
        children: [
          Visibility(
            visible: true,
            child: TextField(
              controller: legendeController,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "",
              ),
              onChanged: (text) {
                setState(() {
                  memeLegende = text;
                });
              },
            ),
          ),
          Container(
              alignment: Alignment.bottomLeft,
              child: Text(
                memeLegende.length.toString() + " Caractères/ 250",
                style: GoogleFonts.averageSans(fontSize: 18.0),
              )),
        ],
      )),
    ));
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
    getIP();
  }
}
