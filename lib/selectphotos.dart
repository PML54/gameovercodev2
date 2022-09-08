import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gameover/configgamephl.dart';
import 'package:gameover/gamephlclass.dart';
import 'package:gameover/phlcommons.dart';
import 'package:http/http.dart' as http;

//<PMLV2>
class SelectPhotosPhl extends StatefulWidget {
  const SelectPhotosPhl({Key? key}) : super(key: key);

  @override
  State<SelectPhotosPhl> createState() => _SelectPhotosPhlState();
}

class _SelectPhotosPhlState extends State<SelectPhotosPhl> {
  bool feuVert = false;
  List<PhotoBase> listPhotoBase = [];
  List<PhotoBase> listPhotoBaseFiltered = [];
  List<PhotoBase> listPhotoBaseReduce = [];

  List<GamePhotoSelect> listGamePhotoSelect = [];
  int combienPhotos = 0;
  String thatGM = "xx";
  int thatGmid = 0;
  int getGamePhotoSelectError = 0;
  bool getGamePhotoSelectState = false;
  GameCommons myPerso = GameCommons("xxxx", 0, 0);

  List<int> photoidSelected = []; // retenues avec les Catégotire
  List<PhotoCat> listPhotoCat = [];
  bool getPhotoCatState = false;
  int getPhotoCatError = 0;
  bool getPhotoBaseState = false;
  int nbPhotoRandom = 0;
  int nbPhotoCat = 0;
  List<Icon> selIcon = [];
  Icon catIcon = const Icon(Icons.remove);
  bool boolCategory = true;

  //int cestCeluiLa = 0;

  @override
  Widget build(BuildContext context) {
    myPerso = ModalRoute.of(context)!.settings.arguments as GameCommons;
    thatGmid = myPerso.myUid;
    thatGM = myPerso.myPseudo;
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
                tooltip: 'Home',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                onPressed: () => {null},
                style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    textStyle: const TextStyle(
                        fontSize: 14,
                        backgroundColor: Colors.red,
                        fontWeight: FontWeight.bold)),
                child: Text('Game Master: ' + thatGM),
              ),
            ],
          ),
        ),
      ]),
      body: SafeArea(
        child: Row(children: <Widget>[
          getListView(),
          !boolCategory ? getListViewSelected() : getViewPhotoCat()

          //   getListView(),
        ]),
      ),
      bottomNavigationBar: Row(
        children: [
        IconButton(
            icon: const Icon(Icons.gavel),
            iconSize: 35,
            color: Colors.red,
            tooltip: 'Random',
            onPressed: () {
              randomSelection();

            }),

          IconButton(
              icon: const Icon(Icons.save),
              iconSize: 35,
              color: Colors.green,
              tooltip: 'Save Selection',
              onPressed: () {

                PhlCommons.nbFotosGame = 0;
                updateSelection();
              }),
          IconButton(
              icon: const Icon(Icons.insert_photo),
              iconSize: 35,
              color: Colors.blue,
              tooltip: 'Categories',
              onPressed: () {
                setState(() {
                  boolCategory = !boolCategory;
                });
              }),
          Text(' ' +
              combienPhotos.toString() +
              '/' +
              listPhotoBase.length.toString())
        ],
      ),
    ));
  }

  Future getGamePhotoSelect() async {
    // Lire TABLE   GAMEPHOTOSELECT  et mettre dans  listgetGamePhotoSelect
    Uri url = Uri.parse(pathPHP + "readGAMEPHOTOSELECT.php");

    var data = {
      //<TODO>
      "GAMECODE": PhlCommons.thisGameCode.toString(),
    };
    getGamePhotoSelectState = false;
    http.Response response = await http.post(url, body: data);
    getGamePhotoSelectError = 0;
    if (response.body.toString() == 'ERR_1001') {
      getGamePhotoSelectError = 1001;
    }

    if (response.statusCode == 200 && getGamePhotoSelectError == 0) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        getGamePhotoSelectState = true;
        listGamePhotoSelect =
            datamysql.map((xJson) => GamePhotoSelect.fromJson(xJson)).toList();
      });
    } else {}
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

  Expanded getListView() {
    if (!feuVert) return (const Expanded(child: Text("Je Joue ........")));
    setState(() {
      combienPhotos = listPhotoBaseFiltered.length;
    });
    var listView = ListView.builder(
        itemCount: listPhotoBaseFiltered.length,
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
                            color: listPhotoBaseFiltered[index].extraColor,
                            border: Border.all()),
                        child: Image.network(
                          "upload/" +
                              listPhotoBaseFiltered[index].photofilename +
                              "." +
                              listPhotoBaseFiltered[index].photofiletype,
                          width:
                              (listPhotoBaseFiltered[index].extraWidth) * 2.0,
                          height:
                              (listPhotoBaseFiltered[index].extraHeight) * 2.0,
                        )),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  listPhotoBaseFiltered[index].isSelected =
                      !listPhotoBaseFiltered[index].isSelected;
                  if (listPhotoBaseFiltered[index].isSelected) {
                    listPhotoBaseFiltered[index].extraColor = Colors.green;
                  } else {
                    listPhotoBaseFiltered[index].extraColor = Colors.grey;
                  }
                });
              });
        });

    return (Expanded(child: listView));
  }

  Expanded getListViewSelected() {
    setState(() {});

    if (!feuVert) return (const Expanded(child: Text(".......")));
    setState(() {
      listPhotoBaseReduce.clear();
      for (PhotoBase _brocky in listPhotoBase) {
        if (_brocky.isSelected) {
          listPhotoBaseReduce.add(_brocky);
        }
      }
    });
    var listView = ListView.builder(
        itemCount: listPhotoBaseReduce.length,
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
                        color: listPhotoBaseReduce[index].extraColor,
                        border: Border.all()),
                    child: Image.network(
                        "upload/" +
                            listPhotoBaseReduce[index].photofilename +
                            "." +
                            listPhotoBaseReduce[index].photofiletype,
                        width: listPhotoBaseReduce[index].extraWidth,
                        height: listPhotoBaseReduce[index].extraHeight),
                  )),
                ],
              ),
              onTap: () {
                setState(() {
                  listPhotoBaseReduce[index].isSelected =
                      !listPhotoBaseReduce[index].isSelected;
                  if (listPhotoBaseReduce[index].isSelected) {
                    listPhotoBaseReduce[index].extraColor = Colors.green;
                  } else {
                    listPhotoBaseReduce[index].extraColor = Colors.grey;
                  }
                });
              });
        });
    return (Expanded(child: listView));
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
        //   cestCeluiLa = Random().nextInt(listPhotoBase.length);
        getPhotoCat();
        feuVert = true;
      });
    } else {}
  }

  Future getPhotoCat() async {
    Uri url = Uri.parse(pathPHP + "getPHOTOCAT.php");
    getPhotoCatState = false;
    getPhotoCatError = 0;

    var data = {
      "PHOTOCAT": "BIDON", // Pas Utilisé
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
      _cathy.setSelected(0);
      _cathy.setNumber(_nbcat);
      _cathy.setphotoid(_thatid);
      _cathy.supMM();
    }
    initPhotoSelected();
  }

  initPhotoSelected() {
    photoidSelected.clear();
    listPhotoBaseFiltered.clear();
    for (PhotoCat _fotocat in listPhotoCat) {
      String _thatCode = _fotocat.photocat;

      if (_fotocat.selected == 1) {
        for (PhotoBase _fotobase in listPhotoBase) {
          if (_fotobase.photocat == _thatCode) {
            listPhotoBaseFiltered.add(_fotobase);
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
    getGamePhotoSelect();

    getPhotoBase();
    selIcon.clear();
    selIcon.add(const Icon(Icons.remove));
    selIcon.add(const Icon(Icons.add));
  }

  void updateSelection() async {
    String thisParam = "";
    PhlCommons.nbFotosGame = 0;
    int _gamecode = PhlCommons.thisGameCode;
    for (PhotoBase _brocky in listPhotoBase) {
      if (_brocky.isSelected) {
        PhlCommons.nbFotosGame++;
        thisParam = thisParam + "|" + _brocky.photoid.toString();
      }
    }
    Uri url = Uri.parse(pathPHP + "updateGAMEPHOTOSELECT.php");
    var data = {
      "GAMECODE": _gamecode.toString(),
      "GROUPSEL": thisParam,
    };
    await http.post(url, body: data);
    Navigator.pop(context);
  }

  void randomSelection() {
    setState(() {


      // On  en prend Un  Au Hasard
      int cestCeluiLa = Random().nextInt(listPhotoBaseFiltered.length);
     listPhotoBaseFiltered[cestCeluiLa].isSelected =true;
      listPhotoBaseReduce.clear();
      for (PhotoBase _brocky in listPhotoBase) {
        if (_brocky.isSelected) {
          listPhotoBaseReduce.add(_brocky);
        }
      }


    });
  }
}
