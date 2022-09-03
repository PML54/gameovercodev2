import 'dart:convert';
import 'dart:core';
import 'dart:math';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:gameover/configgamephl.dart';
import 'package:gameover/gamephlclass.dart';
import 'package:gameover/phlcommons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

//<PMLV2>
class RandoMeme extends StatefulWidget {
  const RandoMeme({Key? key}) : super(key: key);

  @override
  State<RandoMeme> createState() => _RandoMemeState();
}

class _RandoMemeState extends State<RandoMeme> {
  static bool getPhotoCatState = false;
  static bool getPhotoBaseState = false;
  static bool boolTexfield = false;
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
  List<Memoto> listMemoto = [];
  bool getMemotoState = false;
  int getMemotoError = -1;
  List<Icon> selIcon = [];
  Icon catIcon = const Icon(Icons.remove);
  int nbPhotoRandom = 0;
  int photoIdRandom = 0;
  int memoStockidRandom = 0;
  int cestCeluiLa = 0;
  String memeLegende = "";
  String memeLegendeUser = "";
  String ipv4name = "**.**.**";

  Icon thisIconclose = const Icon(Icons.lock_rounded);
  Icon thisIconopen = const Icon(Icons.lock_open_rounded);
  bool lockMemeState = true;
  bool lockPhotoState = true;
  Icon mmIcon = const Icon(Icons.lock_open_rounded);
  Icon phIcon = const Icon(Icons.lock_open_rounded);

  //
  // Strockage Interne
  List<PhotoRandomLive> listPhotoRandomLive = []; //PRL
  int thatPRL = 0;
  bool repaintPRL = false;
  bool visStar = true;
  late int myUid;
  late String myPseudo;

  @override
  Widget build(BuildContext context) {
    final myPerso = ModalRoute.of(context)!.settings.arguments as GameCommons;
    myUid = myPerso.myUid;
    myPseudo = myPerso.myPseudo;

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
                    createMemolike();
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                color: Colors.deepPurpleAccent,
                iconSize: 35.0,
                tooltip: 'Save Meme',
                onPressed: () {
                  createMemeSolo();
                  //
                },
              ),
              Text(photoIdRandom.toString()),
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
              icon: const Icon(Icons.message_outlined),
              iconSize: 35,
              color: Colors.blue,
              tooltip: 'Caption',
              onPressed: () {
                setState(() {
                  boolTexfield = !boolTexfield;
                });
                //stopTimer();
              }),
          IconButton(
              icon: const Icon(Icons.gavel),
              iconSize: 50,
              color: Colors.red,
              tooltip: 'Photo Random',
              onPressed: () {
                setState(() {
                  int random = Random().nextInt(nbPhotoRandom); //Suppe 1
                  int randomMeme = Random().nextInt(listMemoto.length);

                  photoIdRandom = photoidSelected[random];
                  boolCategory = false;
                  if (!lockPhotoState) {
                    cestCeluiLa = getIndexFromPhotoId(photoIdRandom);
                  }
                  if (!lockMemeState) {
                    memeLegende = listMemoto[randomMeme].memostock;
                  }
                  memoStockidRandom = listMemoto[randomMeme].memostockid;
                  legendeController.text = memeLegendeUser;
                  legendeController.text = memeLegende;
                  visStar = true;
                  //legendeController.text =""; // Test
                  savePRL(); // Ajout pour toutes
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

  Future createMemeSolo() async {
    Uri url = Uri.parse(pathPHP + "createMEMESOLO.php");
    var data = {
      "MEMOCAT": myPseudo,
      "MEMOSTOCK": memeLegendeUser,
    };
    if (memeLegendeUser.length > 2 && memeLegendeUser.length < 250) {
      await http.post(url, body: data);
    }

    setState(() {
      memeLegendeUser = "";
      legendeController.text = "";
    });

    //<TODO>  relecture
  }

  Future createMemolike() async {
    Uri url = Uri.parse(pathPHP + "createMEMOLIKE.php");

    var data = {
      "PHOTOID": photoIdRandom.toString(),
      "MEMOSTOCKID": memoStockidRandom.toString(),
      "MEMOLIKEUSER": myPseudo,
    };

    await http.post(url, body: data);

    //
    setState(() {
      int random = Random().nextInt(nbPhotoRandom - 1);
      int randomMeme = Random().nextInt(listMemoto.length - 1);
      photoIdRandom = photoidSelected[random];
      boolCategory = false;
      if (!lockPhotoState) cestCeluiLa = getIndexFromPhotoId(photoIdRandom);
      if (!lockMemeState) memeLegende = listMemoto[randomMeme].memostock;
      memoStockidRandom = listMemoto[randomMeme].memostockid;
      legendeController.text = memeLegendeUser;
      legendeController.text = memeLegende;
      visStar = true;
    });
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
        legendeController.text = memeLegende;
        legendeController.text = ""; // Test
        //cestCeluiLa =thatPRL;
        repaintPRL = false;
      }
    });
    return Expanded(
        child: (Column(
      children: [
        Visibility(
          visible: boolTexfield,
          child: TextField(
            controller: legendeController,
            keyboardType: TextInputType.multiline,
            maxLines: 2,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "",
            ),
            onChanged: (text) {
              setState(() {
                memeLegendeUser = text;
                if (memeLegendeUser.isNotEmpty) memeLegende = memeLegendeUser;
              });
            },
          ),
        ),
        Container(
            alignment: Alignment.bottomLeft,
            child: Text(
              memeLegende,
              style: GoogleFonts.averageSans(fontSize: 18.0),
            )),
        Container(
          alignment: Alignment.center,
          child: Image.network(
            "upload/" +
                listPhotoBase[cestCeluiLa].photofilename +
                "." +
                listPhotoBase[cestCeluiLa].photofiletype,
          ),
        ),
      ],
    )));
  }

  getIndexFromPhotoId(_thatPhotoId) {
    int index = 0;
    for (PhotoBase _brocky in listPhotoBase) {
      if (_brocky.photoid == _thatPhotoId) {
        return (index);
      }
      index++;
    }
    return (0);
  }

  Future getIP() async {
    final ipv4 = await Ipify.ipv4();

    setState(() {
      ipv4name = ipv4;
    });
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
        cestCeluiLa = Random().nextInt(listPhotoBase.length);
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

  Expanded getViewPhotoCat() {
    setState(() {});
    if (!getPhotoCatState | !getPhotoBaseState) {
      return (const Expanded(child: Text("............")));
    }
    var listView = ListView.builder(
        itemCount: listPhotoCat.length,
        controller: ScrollController(),
        //scrollDirection:  Axis.horizontal,
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
    photoidSelected.clear();
    for (PhotoCat _fotocat in listPhotoCat) {
      String _thatCode = _fotocat.photocat;

      if (_fotocat.selected == 1) {
        for (PhotoBase _fotobase in listPhotoBase) {
          if (_fotobase.photocat == _thatCode) {
            photoidSelected.add(_fotobase.photoid);
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
      // Doute sur CRTL fin
      getMemoto();
      getIP();
      selIcon.clear();
      selIcon.add(const Icon(Icons.remove));
      selIcon.add(const Icon(Icons.add));
      listPhotoRandomLive.clear();

      thatPRL = 0;

      mmIcon = thisIconopen;
      phIcon = thisIconopen;
      lockMemeState = false;
      lockPhotoState = false;
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
      thatPRL++;
      if (thatPRL > listPhotoRandomLive.length - 1) {
        thatPRL = listPhotoRandomLive.length - 1;
      }
      photoIdRandom = listPhotoRandomLive[thatPRL].photoid;
      cestCeluiLa = getIndexFromPhotoId(photoIdRandom);

      memeLegende = listPhotoRandomLive[thatPRL].photomemelive;

      repaintPRL = true;
      boolTexfield = false;
      visStar = false;
    });
  }

  prevPRL() {
    setState(() {
      thatPRL--;
      if (thatPRL < 0) thatPRL = 0;
      photoIdRandom = listPhotoRandomLive[thatPRL].photoid;
      cestCeluiLa = getIndexFromPhotoId(photoIdRandom);

      memeLegende = listPhotoRandomLive[thatPRL].photomemelive;

      repaintPRL = true;
      boolTexfield = false;
      visStar = false;
    });
  }

  savePRL() {
    setState(() {
      PhotoRandomLive _thatPRL =
          PhotoRandomLive(photoid: photoIdRandom, photomemelive: memeLegende);
      listPhotoRandomLive.add(_thatPRL);
      // Fermer la fenetre

      boolTexfield = false;
      thatPRL++;
    });
  }
}
