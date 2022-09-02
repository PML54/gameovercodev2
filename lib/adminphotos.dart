import 'dart:convert';
import 'dart:core';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:gameover/configgamephl.dart';
import 'package:gameover/gamephlclass.dart';
import 'package:http/http.dart' as http;

//<PMLV2>
class AdminPhotos extends StatefulWidget {
  const AdminPhotos({Key? key}) : super(key: key);

  @override
  State<AdminPhotos> createState() => _AdminPhotosState();
}

class _AdminPhotosState extends State<AdminPhotos> {
  static bool getPhotoCatState = false;
  static bool getPhotoBaseState = false;
  bool isAdminConnected = false;

  TextEditingController legendeController = TextEditingController();
  int totalSeconds = 100;
  bool timeOut = false;
  bool boolCategory = false;

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
              IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.red,
                iconSize: 40.0,
                tooltip: 'Lock Memes',
                onPressed: () {
                  //lockMeme();
                },
              ),
              IconButton(
                icon: const Icon(Icons.error),
                color: Colors.red,
                iconSize: 30.0,
                tooltip: 'Lock Photos',
                onPressed: () {},
              ),
              Text(" " + listPhotoBaseWork[cestCeluiLa].photocat),
              Text(" " + listPhotoBaseWork[cestCeluiLa].photoid.toString())
            ],
          ),
        ),
      ]),
      body: SafeArea(
        child: Column(children: <Widget>[
          Visibility(
            visible: boolCategory,
            child: getViewPhotoCat(),
          ),
          getget(),
        ]),
      ),
      bottomNavigationBar: Row(
        children: [
          IconButton(
              icon: const Icon(Icons.insert_photo),
              iconSize: 35,
              color: Colors.greenAccent,
              tooltip: 'Categories',
              onPressed: () {
                setState(() {
                  boolCategory = !boolCategory;
                });
              }),
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

  Expanded getget() {
    if (!getPhotoBaseState) {
      return Expanded(
        child: Column(
          children: const [
            (Text('.......')),
          ],
        ),
      );
    }

    setState(() {
      if (repaintPRL) {
        repaintPRL = false;
      }
    });
    return Expanded(
        child: (Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: Stack(children: [
            Image.network(
              "upload/" +
                  listPhotoBaseWork[cestCeluiLa].photofilename +
                  "." +
                  listPhotoBaseWork[cestCeluiLa].photofiletype,
            ),
            Align(alignment: Alignment.topRight, child: Text("lamemopole.com")),
          ]),
        )
      ],
    )));
  }

  Future getIP() async {
    final ipv4 = await Ipify.ipv4();

    setState(() {
      ipv4name = ipv4;
    });
  }

  Future getPhotoBase() async {
    // Lire TABLE   PHOTOBASE et mettre dans  listPhotoBase

    Uri url = Uri.parse(pathPHP + "readPHOTOBASE.php");

    getPhotoBaseState = false;
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        listPhotoBase =
            datamysql.map((xJson) => PhotoBase.fromJson(xJson)).toList();
        getPhotoBaseState = true;
        cestCeluiLa = 0;
        getPhotoCat();
      });
    } else {}
  }

  Future getPhotoCat() async {
    Uri url = Uri.parse(pathPHP + "getPHOTOCAT.php");
    getPhotoCatState = false;
    getPhotoCatError = 0;

    var data = {
      "PHOTOCAT": "BDON",
    };
    http.Response response = await http.post(url, body: data);
    if (response.body.toString() == 'ERR_1001') {
      nbPhotoCat = 0;
      getPhotoCatError = 1001; //Not Found
    }
    if (response.statusCode == 200 && (getPhotoCatError != 1001)) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        getPhotoCatError = 0;
        listPhotoCat =
            datamysql.map((xJson) => PhotoCat.fromJson(xJson)).toList();
        getPhotoCatState = true;

        initPhotoCat(); // En cascade
      });
    } else {}
  }

  bool getStateCat(String lecode) {
    for (PhotoCat _brocky in listPhotoCat) {
      if (_brocky.photocat == lecode) {
        if (_brocky.selected == 1) {
          return (true);
        } else {
          return (false);
        }
      }
    }
    return (false);
  }

  Expanded getViewPhotoCat() {
    setState(() {});
    if (!getPhotoCatState | !getPhotoBaseState) {
      return (const Expanded(child: Text("............")));
    }
    var listView = ListView.builder(
        itemCount: listPhotoCat.length,
        controller: ScrollController(),
        itemBuilder: (context, index) {
          return ListTile(
              dense: true,
              title: Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Text(listPhotoCat[index].photocast),
                      selIcon[listPhotoCat[index].selected],
                    ],
                  )),
                ],
              ),
              onTap: () {
                setState(() {
                  if (listPhotoCat[index].selected == 1) {
                    listPhotoCat[index].selected = 0;
                  } else {
                    (listPhotoCat[index].selected = 1);
                  }
                  if (listPhotoCat[index].selected == 1) {
                    catIcon = const Icon(Icons.add);
                  } else {
                    catIcon = const Icon(Icons.remove);
                  }
                  initPhotoSelected();
                });
              });
        });

    return (Expanded(child: listView));
  }

  initPhotoCat() {
    int _nbcat = 0;
    int _thatid = 0;
    for (PhotoCat _cathy in listPhotoCat) {
      _nbcat = 0;
      String _thatCode = _cathy.photocat;
      for (PhotoBase _brocky in listPhotoBase) {
        if (_brocky.photocat == _thatCode) {
          _nbcat++;
          _thatid = _brocky.photoid;
        }
      }
      _cathy.setSelected(1);
      _cathy.setNumber(_nbcat);
      _cathy.setphotoid(_thatid);
      _cathy.supMM();
    }
    initPhotoSelected();
  }

  initPhotoSelected() {
    listPhotoBaseWork.clear();
    photoidSelected.clear();
    for (PhotoCat _fotocat in listPhotoCat) {
      String _thatCode = _fotocat.photocat;

      if (_fotocat.selected == 1) {
        for (PhotoBase _fotobase in listPhotoBase) {
          if (_fotobase.photocat == _thatCode) {
            photoidSelected.add(_fotobase.photoid);
            listPhotoBaseWork.add(_fotobase);
          }
        }
      }
    }
    setState(() {
      nbPhotoRandom = photoidSelected.length;
    });
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      getPhotoBase();

      getIP();
      selIcon.clear();
      selIcon.add(const Icon(Icons.remove));
      selIcon.add(const Icon(Icons.add));

      mmIcon = thisIconopen;
      phIcon = thisIconopen;

      lockPhotoState = false;

      listPhotoBaseWork.clear();
    });
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
      cestCeluiLa++;
      if (cestCeluiLa > listPhotoBaseWork.length) {
        cestCeluiLa--;
      }
      repaintPRL = true;
    });
  }

  prevPRL() {
    setState(() {
      cestCeluiLa--;
      if (cestCeluiLa < 0) cestCeluiLa = 0;

      repaintPRL = true;
    });
  }
}
