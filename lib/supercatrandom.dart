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
class SuperCatRandom extends StatefulWidget {
  const SuperCatRandom({Key? key}) : super(key: key);
  @override
  State<SuperCatRandom> createState() => _SuperCatRandomState();
}

class _SuperCatRandomState extends State<SuperCatRandom> {
  static bool getPhotoBaseState = false;
  static bool boolTexfield = false;
  TextEditingController legendeController = TextEditingController();
  int totalSeconds = 100;
  bool timeOut = false;
  bool boolOptions = true;
  int heightFoto = 1;
  int widthFoto = 1;
  double ratioFoto = 1.0;
  bool boolCategory = false;
  bool boolDisplay = true;
  int getPhotoCatError = -1;
  bool getSuperCatState = false;
  int nbPhotoCat = 0;
  int getPhotoBaseError = -1;
  List<int> photoidSelected = []; // retenues avec les Catégotire
  // List<PhotoCat> listPhotoCat = [];
  List<SurCat> listSurCat = [];
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
  String ipv4name = "";

  Icon thisIconclose = const Icon(Icons.lock_rounded);
  Icon thisIconopen = const Icon(Icons.lock_open_rounded);
  bool lockMemeState = true;

  bool lockPhotoState = true;
  Icon mmIcon = const Icon(Icons.lock_open_rounded);
  Icon phIcon = const Icon(Icons.lock_open_rounded);

  // Stockage Interne
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
                iconSize: 25.0,
                tooltip: 'Lock Memes',
                onPressed: () {
                  lockMeme();
                },
              ),
              IconButton(
                icon: phIcon,
                color: Colors.black,
                iconSize: 25.0,
                tooltip: 'Lock Photos',
                onPressed: () {
                  lockPhoto();
                },
              ),
              Text(nbPhotoRandom.toString()),
              Visibility(
                visible: visStar,
                child: IconButton(
                  icon: const Icon(Icons.star),
                  color: Colors.red,
                  iconSize: 25.0,
                  tooltip: 'Favori',
                  onPressed: () {
                    createMemolike();
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                color: Colors.deepPurpleAccent,
                iconSize: 25.0,
                tooltip: 'Save Meme',
                onPressed: () {
                  createMemeSolo();
                  //
                },
              ),

              // Text("<"+ widthFoto.toString()+"/"+heightFoto.toString() + '='+ratioFoto.toStringAsPrecision(2)+">"),

              Text("<" +
                  widthFoto.toString() +
                  "/" +
                  heightFoto.toString() +
                  '>'),
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
          if (boolOptions) dispParams(),
        ]),
      ),
      bottomNavigationBar: Row(
        children: [
          IconButton(
              icon: const Icon(Icons.insert_photo),
              iconSize: 30,
              color: Colors.greenAccent,
              tooltip: 'Categories',
              onPressed: () {
                setState(() {
                  boolCategory = !boolCategory;
                  if (!boolCategory) boolDisplay = true;
                  boolTexfield = false; // <PML>  a verifier
                });
              }),
          IconButton(
              icon: const Icon(Icons.message_outlined),
              iconSize: 30,
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
              iconSize: 30,
              color: Colors.red,
              tooltip: 'Photo Random',
              onPressed: () {
                randomMarteau();
              }),
          IconButton(
              icon: const Icon(Icons.arrow_back),
              iconSize: 30,
              color: Colors.blue,
              tooltip: 'Prev',
              onPressed: () {
                prevPRL();
                //createMeme();
                //stopTimer();
              }),
          IconButton(
              icon: const Icon(Icons.arrow_forward),
              iconSize: 30,
              color: Colors.blue,
              tooltip: 'Next',
              onPressed: () {
                nextPRL();
              }),
          IconButton(
              icon: const Icon(Icons.restaurant_menu),
              iconSize: 30,
              color: Colors.purpleAccent,
              tooltip: 'Options Game',
              onPressed: () {
                setState(() {
                  boolOptions = !boolOptions;
                });
              }),
        ],
      ),
    ));
  }

  Future createMemeSolo() async {
    Uri url = Uri.parse(pathPHP + "createMEMESOLO.php");
    String _myPseudo = myPseudo;

    if (_myPseudo.length < 2) {
      _myPseudo = "GADGET";
      if (ipv4name.length > 2) {
        _myPseudo = ipv4name;
      }
    }
    var data = {
      "MEMOCAT": _myPseudo,
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

  dispParams() {
    return Expanded(
        child: Visibility(
      visible: boolOptions,
      child: Container(
        child: (Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        textStyle: const TextStyle(
                            fontSize: 15,
                            backgroundColor: Colors.red,
                            fontWeight: FontWeight.bold)),
                    child: Text('    Random Meme        '),
                    onPressed: () {
                      randomMarteau();
                    }),
                IconButton(
                    icon: const Icon(Icons.gavel),
                    iconSize: 30,
                    color: Colors.red,
                    tooltip: 'Photo Random',
                    onPressed: () {
                      randomMarteau();
                    }),
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        textStyle: const TextStyle(
                            fontSize: 14,
                            backgroundColor: Colors.green,
                            fontWeight: FontWeight.bold)),
                    child: Text('Category Filter:'),
                    onPressed: () {
                      setState(() {
                        boolCategory = !boolCategory;
                        if (!boolCategory) boolDisplay = true;
                      });
                    }),
                IconButton(
                    icon: const Icon(Icons.insert_photo),
                    iconSize: 30,
                    color: Colors.green,
                    tooltip: 'Categories',
                    onPressed: () {
                      setState(() {
                        boolCategory = !boolCategory;
                        if (!boolCategory) boolDisplay = true;
                        boolTexfield = false; // <PML>  a verifier
                      });
                    }),
                SizedBox(width: 10, height: 30),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        textStyle: const TextStyle(
                            fontSize: 14,
                            backgroundColor: Colors.blue,
                            fontWeight: FontWeight.bold)),
                    child: Text('Caption Perso: '),
                    onPressed: () {
                      setState(() {
                        boolTexfield = !boolTexfield;
                      });
                      //stopTimer();
                    }),
                IconButton(
                    icon: const Icon(Icons.message_outlined),
                    iconSize: 30,
                    color: Colors.blue,
                    tooltip: 'Caption',
                    onPressed: () {
                      setState(() {
                        boolTexfield = !boolTexfield;
                      });
                      //stopTimer();
                    }),
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      textStyle: const TextStyle(
                          fontSize: 14,
                          backgroundColor: Colors.black,
                          fontWeight: FontWeight.bold)),
                  child: Text('Caption Lock:  '),
                  onPressed: () {
                    lockMeme();
                  },
                ),
                IconButton(
                  icon: mmIcon,
                  color: Colors.black,
                  iconSize: 30.0,
                  tooltip: 'Lock Memes',
                  onPressed: () {
                    lockMeme();
                  },
                ),
                SizedBox(width: 10, height: 30),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        textStyle: const TextStyle(
                            fontSize: 14,
                            backgroundColor: Colors.black,
                            fontWeight: FontWeight.bold)),
                    child: Text('Template Lock: '),
                    onPressed: () => {lockPhoto()}),
                IconButton(
                  icon: phIcon,
                  color: Colors.black,
                  iconSize: 30.0,
                  tooltip: 'Lock Photos',
                  onPressed: () {
                    lockPhoto();
                  },
                ),
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.purpleAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        textStyle: const TextStyle(
                            fontSize: 14,
                            backgroundColor: Colors.purpleAccent,
                            fontWeight: FontWeight.bold)),
                    child: Text("Masquer Paramètres"),
                    onPressed: () {
                      setState(() {
                        boolOptions = !boolOptions;
                      });
                    }),
                IconButton(
                    icon: const Icon(Icons.restaurant_menu),
                    iconSize: 30,
                    color: Colors.purpleAccent,
                    tooltip: 'Options Game',
                    onPressed: () {
                      setState(() {
                        boolOptions = !boolOptions;
                      });
                    }),
              ],
            ),
          ],
        )),
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
          ),
        ),
        Visibility(
          visible: boolDisplay,
          child: Container(
            alignment: Alignment.center,
            child: Image.network(
              "upload/" +
                  listPhotoBase[cestCeluiLa].photofilename +
                  "." +
                  listPhotoBase[cestCeluiLa].photofiletype,
            ),
          ),
        )
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

        //<PHL> par defaur 1st
        int randomMeme = Random().nextInt(listMemoto.length);
        memeLegende = listMemoto[randomMeme].memostock;
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
      });
    } else {
      print(" Should never Happen");
    }

    getSuperCat(PhlCommons.random);
  }

  Future getSuperCat(_supercode) async {
    Uri url = Uri.parse(pathPHP + "getSUPERCAT.php");
    getSuperCatState = false;
    int getSuperCatError = 0;
    String _postsupercode = "NORMAL"; // Modfif <PHL>
    if (_supercode == 2) {
      _postsupercode = "FILM";
    }
    var data = {
      "SURCAT": _postsupercode,
    };
    http.Response response = await http.post(url, body: data);
    if (response.body.toString() == 'ERR_1001') {
      getSuperCatError = 1001; //Not Found
    }
    if (response.statusCode == 200 && (getSuperCatError != 1001)) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        getSuperCatError = 0;
        listSurCat = datamysql.map((xJson) => SurCat.fromJson(xJson)).toList();
        getSuperCatState = true;

        initPhotoSurCat();
      });
    } else {}
  }

  Expanded getViewPhotoCat() {
    if (!getSuperCatState | !getPhotoBaseState) {
      return (const Expanded(child: Text("............")));
    }
    var listView = ListView.builder(
        itemCount: listSurCat.length,
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
                      Text(listSurCat[index].catred),
                      selIcon[listSurCat[index].selected],
                    ],
                  )),
                ],
              ),
              onTap: () {
                setState(() {
                  if (listSurCat[index].selected == 1) {
                    listSurCat[index].selected = 0;
                  } else {
                    (listSurCat[index].selected = 1);
                  }
                  if (listSurCat[index].selected == 1) {
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

  initPhotoSelected() {
    photoidSelected.clear();
    for (SurCat _fotocat in listSurCat) {
      String _thatCode = _fotocat.catfull;
      //  _fotocat.selected =0;

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

  initPhotoSelectedSuperCat() {
    photoidSelected.clear();
    for (SurCat _fotocat in listSurCat) {
      String _thatCode = _fotocat.catfull;
      _fotocat.selected = 1;
      /* if ((_fotocat.surcat == "FILM") ) _fotocat.selected = 1;
      if ((_fotocat.surcat == "NORMAL") ) _fotocat.selected = 1;*/
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

  initPhotoSurCat() {
    int _nbcat = 0;
    int _thatid = 0;

    for (SurCat _cathy in listSurCat) {
      _nbcat = 0;
      String _thatCode = _cathy.catfull;
      for (PhotoBase _brocky in listPhotoBase) {
        if (_brocky.photocat == _thatCode) {
          _nbcat++;
          _thatid = _brocky.photoid;
        }
      }

      // Selected by Defauly
      // Et on Compte
      _cathy.setSelected(1);
      _cathy.setNumber(_nbcat);
      _cathy.setphotoid(_thatid);
    }
    initPhotoSelected();
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      getPhotoBase();
      //  getSuperCat();

      getMemoto(); // Memes
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
      if (listSurCat[index].selected == 1) {
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

  randomMarteau() {
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

      heightFoto = listPhotoBase[cestCeluiLa].photoheight;
      widthFoto = listPhotoBase[cestCeluiLa].photowidth;
      ratioFoto = widthFoto / heightFoto;

      //legendeController.text =""; // Test
      savePRL(); // Ajout pour toutes
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
