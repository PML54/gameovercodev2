import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:gameover/configgamephl.dart';
import 'package:gameover/gamehelp.dart';
import 'package:gameover/gamemanager.dart';
import 'package:gameover/gamephlclass.dart';
import 'package:gameover/gamephlplusclass.dart';
import 'package:gameover/gameusersingle.dart';
import 'package:gameover/gamevote.dart';
import 'package:gameover/gamevoteresultplus.dart';
import 'package:gameover/phlcommons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

//<PMLV2>
// A ce niveau On PAsse le Geme Users  à OFFLINE pour tous les Game
// Central Game
// On va lire les Record Audika  Poufr
// determiner ce ui'il est Juficieux de Lire
class GameSupervisor extends StatefulWidget {
  const GameSupervisor({Key? key}) : super(key: key);

  @override
  State<GameSupervisor> createState() => _GameSupervisorState();
}

class _GameSupervisorState extends State<GameSupervisor> {
  GameCommons myPerso = GameCommons("xxxx", 0, 0);
  GameAudika myAudikaGMU = GameAudika(
      audikaid: 0,
      codid: 1,
      lastid: 0,
      gamecode: 0,
      lastdate: DateTime.now().toString());
  GameAudika myAudikaGAME = GameAudika(
      audikaid: 0,
      codid: 2,
      lastid: 0,
      gamecode: 0,
      lastdate: DateTime.now().toString());
  bool actionAudikaGMU = false; // Si
  bool actionAudikaGAME = false; // Si true Relire les GAMes
  bool boolContinue = false;
  bool setGuOffGamesState = false;
  bool getGameUsersByCodeState = false;
  int getGameUsersByCodeError = 0;
  List<GameUsers> Gamers = [];
  List<GamersPlus> listGamersPlus = [];
  bool promoteGameState = false;
  bool isGmid = false;
  bool changeStateGameUserState = false;
  bool plusGamersState = false;
  bool checkAudikaState = false;
  int checkAudikaError = 0;
  List<GameAudika> listAudika = [];

  bool getGamePhotoSelectState = false;
  int getGamePhotoSelectError = -1;
  List<PhotoBase> listPhotoBaseGame = [];
  bool getGamebyUidState = false;
  int getGamebyUidError = 0;
  List<GameByUser> myGames = [];
  bool plusGamebyUidState = false;
  List<GamesPlus> myGamesStatus = [];

  String thatPseudo = PhlCommons.thatPseudo;
  int cestCeluiLa = 0;
  int thatGamer = 0;

  int takeThisGameCode = 0;
  String greeting = "";
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    myPerso = ModalRoute.of(context)!.settings.arguments as GameCommons;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(actions: <Widget>[
          Expanded(
            child: Row(
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        textStyle: const TextStyle(
                            fontSize: 14,
                            backgroundColor: Colors.red,
                            fontWeight: FontWeight.bold)),
                    child: const Text(' Exit GAME '),
                    onPressed: () {
                      _timer?.cancel();
                      changeStateGameUser(0);

                      Navigator.pop(context);
                    }),
                ElevatedButton(
                    onPressed: () => {null},
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        textStyle: TextStyle(
                            fontSize: 14,
                            backgroundColor: Colors.blue,
                            fontWeight: FontWeight.bold)),
                    child: Text(myPerso.myPseudo)),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameManager(),
                          settings: RouteSettings(
                            arguments: myPerso,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        textStyle: TextStyle(
                            fontSize: 14,
                            backgroundColor: Colors.blue,
                            fontWeight: FontWeight.bold)),
                    child: Text("New GAME")),
              ],
            ),
          ),
        ]),
        body: SafeArea(
          child: Row(children: <Widget>[
            getListGame(),
            Visibility(
                visible: takeThisGameCode > 0,
                child: Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                textStyle: TextStyle(
                                    fontSize: 12,
                                    backgroundColor: Colors.green,
                                    fontWeight: FontWeight.bold)),
                            child: Text(statusGame[PhlCommons.gameStatus]),
                            onPressed: () => {}),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              textStyle: TextStyle(
                                  fontSize: 10,
                                  backgroundColor: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          child: Text("Passer au statut suivant"),
                          onPressed: () => {
                                if (isGmid) {promoteGame()}
                              }),
                      getListGameUsers(),
                    ],
                  ),
                )),
            //getListView() <PML>
          ]),
        ),
        bottomNavigationBar: Row(
          //   visible: takeThisGameCode > 0,
          children: [
            Visibility(
              visible: PhlCommons.gameStatus == 1 && PhlCommons.thatStatus == 0,
              child: ElevatedButton(
                child: Text(
                  " Commentez ",
                  style: GoogleFonts.averageSans(fontSize: 16.0),
                ),
                onPressed: () {
                  PhlCommons.thisGameCode = takeThisGameCode;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GameUserSingle(),
                      settings: RouteSettings(
                        arguments: myPerso,
                      ),
                    ),
                  );
                },
              ),
            ),
            Visibility(
              visible: PhlCommons.gameStatus == 3 && PhlCommons.thatStatus < 3,
              child: ElevatedButton(
                child: Text(
                  " Votez ",
                  style: GoogleFonts.averageSans(fontSize: 16.0),
                ),
                onPressed: () {
                  PhlCommons.thisGameCode = takeThisGameCode;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameVote(),
                      settings: RouteSettings(
                        arguments: myPerso,
                      ),
                    ),
                  );
                },
              ),
            ),
            Visibility(
              visible: PhlCommons.gameStatus == 5,
              child: ElevatedButton(
                child: Text(
                  " Résultats ",
                  style: GoogleFonts.averageSans(fontSize: 16.0),
                ),
                onPressed: () {
                  PhlCommons.thisGameCode = takeThisGameCode;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameVoteResultPlus(),
                      settings: RouteSettings(
                        arguments: myPerso,
                      ),
                    ),
                  );
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.help_center),
              iconSize: 35,
              color: Colors.green,
              tooltip: 'Aide',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameHelp(),
                    settings: RouteSettings(
                      arguments: myPerso,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future changeStateGameUser(int _state) async {
    Uri url = Uri.parse(pathPHP + "changeStateGameUser.php");

    if (PhlCommons.thisGameCode == 0) {
      return;
    }
    // <PML> cause insta in display
    //    changeStateGameUserState = false;
    var data = {
      "GAMECODE": PhlCommons.thisGameCode.toString(),
      "UID": PhlCommons.thatUid.toString(),
      "GUSTATE": _state.toString(),
    };
    await http.post(url, body: data);
    changeStateGameUserState = true;
    //getGamebyUid();  // On l-relit les Games
  }

  Future checkAudika() async {
    bool gameCodeFound = true;
    Uri url = Uri.parse(pathPHP + "checkAUDIKA.php");
    var data = {
      "GAMECODE": PhlCommons.thisGameCode.toString(),
    };
    http.Response response = await http.post(url, body: data);
    if (response.body.toString() == 'ERR_1001') {
      gameCodeFound = false;
      checkAudikaState = false;
      checkAudikaError = 1001;
    } else {
      gameCodeFound = true;
    }
    if (response.statusCode == 200 && (gameCodeFound)) {
      var datamysql = jsonDecode(response.body) as List;

      listAudika =
          datamysql.map((xJson) => GameAudika.fromJson(xJson)).toList();

      checkAudikaState = true;
      checkAudikaError = 0;
      if (listAudika[0].lastid != myAudikaGMU.lastid) {}
    } else {}
  }

  checkBonhomme() {
    //  Apres Une MAj des  GamesUsers Et/ou Games
    //  On Va vérifier  si le User Connecté  à des Actions à faire
    // Pour cela
    // Ce sera Juste  une Indication  Par exemple
    // Game Action = ON
    // On balise tous les GAMES
    // On regarde  Status du Game avec celui du GameUser
    //  Si action on Allume la Lampe acton du Game
    // Voyon sil ya des changeents
    //
    // Step N°1 <TODO> Vérifier les booléens

    for (GameByUser _myGame in myGames) {
      //Games
      _myGame.uidaction = 0;

      for (GameUsers _gamer in Gamers) {
        setState(() {
          _gamer.uprofile = 0;
          if (_gamer.gamecode == _myGame.gamecode) {
            if (_gamer.uid == _myGame.gmid) {
              _gamer.uprofile = 5;
            }
          }
          if (_gamer.uid == PhlCommons.thatUid &&
              _gamer.gamecode == _myGame.gamecode) {
            _myGame.uidaction = 0;
            if (_myGame.gamestatus == 1 &&
                _gamer.gustatus == 1 &&
                _gamer.gamecode == _myGame.gamecode) {
              _myGame.uidaction = 1;
            }
            if (_myGame.gamestatus == 3 &&
                _gamer.gustatus < 3 &&
                _gamer.gamecode == _myGame.gamecode) {
              _myGame.uidaction = 2;
            }
            if (_myGame.gamestatus == 5 &&
                _gamer.gamecode == _myGame.gamecode) {
              _myGame.uidaction = 3;
            }
          }
        });
      }
    }
  }

  Future getGamebyUid() async {
    bool gameCodeFound = true;
    Uri url = Uri.parse(pathPHP + "getGAMEBYUID.php");
    var data = {
      "UID": PhlCommons.thatUid.toString(),
    };
    http.Response response = await http.post(url, body: data);
    if (response.body.toString() == 'ERR_1001') {
      gameCodeFound = false;
      getGamebyUidState = false;
      getGamebyUidError = 1001;
    } else {
      gameCodeFound = true;
    }

    if (response.statusCode == 200 && (gameCodeFound)) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        myGames = datamysql.map((xJson) => GameByUser.fromJson(xJson)).toList();
        PhlCommons.thisGameCode = myGames.last.gamecode;
        // ON prend le dernier  A revoit
      });

      getGamebyUidState = true;
      getGamebyUidError = 0;
    } else {}
  }

  Future getGameUsersByCode() async {
    int _thisGameCode = PhlCommons.thisGameCode;
    bool gameCodeFound = true;
    getGameUsersByCodeState = false;

    if (PhlCommons.thisGameCode == 0) return;
    Uri url = Uri.parse(pathPHP + "readGAMEUSERSBYCODE.php");
    var data = {
      "GAMECODE": _thisGameCode.toString(),
    };

    if (_thisGameCode == 0) return; // Ne debrait pas happen

    http.Response response = await http.post(url, body: data);
    if (response.body.toString() == 'ERR_1001') {
      gameCodeFound = false;
      getGameUsersByCodeState = false;
      getGameUsersByCodeError = 0;
    } else {
      gameCodeFound = true;
    }
    if (response.statusCode == 200 && (gameCodeFound)) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        Gamers = datamysql.map((xJson) => GameUsers.fromJson(xJson)).toList();
      });

      getGameUsersByCodeState = true;
      getGameUsersByCodeError = 0;
      // Trouvons le Gamer
      int jj = 0;

      // <PML>  A  revoir
      for (GameUsers _brocky in Gamers) {
        if (_brocky.uid == PhlCommons.thatUid) {
          setState(() {
            PhlCommons.thatStatus = _brocky.gustatus;
            PhlCommons.thatState = _brocky.gustate;
            thatGamer = jj;
          });
        }
        jj++;
      }
// On met dans chque Game  le statut du Gaer Actid
      for (GameUsers _gamer in Gamers) {
        if (_gamer.uid == PhlCommons.thatUid) {
          for (GameByUser _gamy in myGames) {
            setState(() {
              _gamy.gustatus = _gamer.gustatus;
            });
          }
        }
      }

      //
    } else {}
  }

  Expanded getListGame() {
    if (PhlCommons.gameNew == 1) {
      PhlCommons.gameNew = 0;
      getGamebyUid();
    }
    if (!getGamebyUidState) {
      return (const Expanded(child: Text(".............")));
    }
    var listView = ListView.builder(
        itemCount: myGames.length,
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
                            color: myGames[index].extraColor,
                            border: Border.all()),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(myGames[index].gamecode.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16))
                          ],
                        )),
                  ),
                  Visibility(
                    // Pas Bon
                    visible: (myGames[index].uidaction > 0),

                    child: IconButton(
                        icon: const Icon(Icons.directions_run_outlined),
                        iconSize: 25,
                        color: Colors.red,
                        tooltip: 'Action requise',
                        onPressed: () {
                          //  quelleAction(myGames[index].gamestatus);
                          quelleAction(myGames[index].uidaction);
                        }),
                  ),
                ],
              ),
              subtitle: Text(statusGame[(myGames[index].gamestatus)],
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Serif',
                    color: Colors.blueGrey,
                  )),
              onTap: () {
                setState(() {
                  myGames[index].isSelected = !myGames[index].isSelected;
                  isGmid = false;
                  if (myGames[index].isSelected) {
                    isGmid = false;
                    isGmid = (PhlCommons.thatUid == myGames[index].gmid);
                    cestCeluiLa = index;
                    takeThisGameCode = myGames[index].gamecode;
                    PhlCommons.thisGameCode = takeThisGameCode;
                    PhlCommons.gameStatus = myGames[index].gamestatus;
                    getGameUsersByCode(); // Maj des Gamers
                    changeStateGameUser(1); // <PML>  pas sur
                    checkBonhomme(); // <PML>  pas sur
                    myPerso.myGame = takeThisGameCode;
                    myGames[index].extraColor = Colors.green;
                    int jj = 0;
                    for (GameByUser _brocky in myGames) {
                      if (jj++ != index) {
                        _brocky.isSelected = false;
                        _brocky.extraColor = Colors.grey;
                      }
                    }
                  } else {
                    myGames[index].extraColor = Colors.grey;
                    if (PhlCommons.thisGameCode > 0) {
                      changeStateGameUser(0);
                    } // on cancel le dernier
                    PhlCommons.thisGameCode = 0;
                  }
                });
              });
        });
    return (Expanded(child: listView));
  }

  Expanded getListGameUsers() {
    if (!getGameUsersByCodeState) {
      return (const Expanded(child: Text(".............")));
    }
    var listView = ListView.builder(
        itemCount: Gamers.length,
        controller: ScrollController(),
        itemBuilder: (context, index) {
          return ListTile(
              dense: true,
              title: Row(
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: (Gamers[index].gustate == 1)
                                ? Colors.blueGrey
                                : Colors.grey,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            textStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                backgroundColor: (Gamers[index].gustate == 1)
                                    ? Colors.blueGrey
                                    : Colors.grey,
                                //    : ((Gamers[index].gustatus >=2 ) ? Colors.blue:Colors.grey),
                                fontWeight: FontWeight.bold)),
                        child: Text(
                            Gamers[index].uname +
                                " " +
                                statusGU[Gamers[index].gustatus],
                            style: TextStyle(
                                color: (Gamers[index].gustate == 1)
                                    ? Colors.black
                                    : Colors.black,
                                // decoration:(Gamers[index].uprofile == 5) ? TextDecoration.underline :TextDecoration.none,
                                fontSize:
                                    (Gamers[index].uprofile == 5) ? 14 : 14)),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () {
                setState(() {});
              });
        });
    return (Expanded(child: listView));
  }

  @override
  void initState() {
    super.initState();
    getGamebyUid(); //     myGames
    setGuOffGames();
    getGameUsersByCode(); //  Gamers =
    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      setState(() {
        greeting = "Check ${DateTime.now().second}";

        plusGamebyUid(); //   update S tatus   myGames
        if (getGameUsersByCodeState) plusGamers(); //  Gamers
      });
    });
  }

  Future plusGamebyUid() async {
    bool gameUidFound = true;
    plusGamebyUidState = false;
    if (PhlCommons.thatUid == 0) return;
    Uri url = Uri.parse(pathPHP + "plusGAMEBYUID.php");
    var data = {
      "UID": PhlCommons.thatUid.toString(),
    };
    http.Response response = await http.post(url, body: data);
    if (response.body.toString() == 'ERR_1001') {
      gameUidFound = false;
      plusGamebyUidState = false;
    } else {
      gameUidFound = true;
    }
    if (response.statusCode == 200 && (gameUidFound)) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        myGamesStatus =
            datamysql.map((xJson) => GamesPlus.fromJson(xJson)).toList();
      });
      plusGamebyUidState = true;
      // Voyon sil ya des changeents
      for (GameByUser _gameActif in myGames) {
        for (GamesPlus _gameRelu in myGamesStatus) {
          if (_gameRelu.gamecode == _gameActif.gamecode) {
            if (_gameActif.gamestatus != _gameRelu.gamestatus) {
              setState(() {
                _gameActif.gamestatus = _gameRelu.gamestatus;
                if (_gameActif.gamecode == PhlCommons.thisGameCode) {
                  PhlCommons.gameStatus = _gameActif.gamestatus;
                }
              });
            }
          }
        }
      }
      checkBonhomme();
    }
  }

  Future plusGamers() async {
    bool gameCodeFound = true;
    plusGamersState = false;
    if (PhlCommons.thatUid == 0) return;
    if (PhlCommons.thisGameCode == 0) return;

    Uri url = Uri.parse(pathPHP + "plusreadGAMEUSERSBYCODE.php");
    var data = {
      "GAMECODE": PhlCommons.thisGameCode.toString(),
    };

    http.Response response = await http.post(url, body: data);
    if (response.body.toString() == 'ERR_1001') {
      plusGamersState = false;
      gameCodeFound = false;
    }

    if (response.statusCode == 200 && gameCodeFound == true) {
      var datamysql = jsonDecode(response.body) as List;

      setState(() {
        listGamersPlus =
            datamysql.map((xJson) => GamersPlus.fromJson(xJson)).toList();
      });
      plusGamersState = true;
      // Voyon sil ya des changeents

      /*
      myGames[index].gamestatus

       */
      for (GameUsers _gamuser in Gamers) {
        for (GamersPlus _gamuserelu in listGamersPlus) {
          if (_gamuser.uid == _gamuserelu.uid) {
            setState(() {
              _gamuser.gustatus = _gamuserelu.gustatus;
            });
          }
        }
      }

      checkBonhomme();
    }
  }

  Future promoteGame() async {
    promoteGameState = false;
    int _status = myGames[cestCeluiLa].gamestatus;
    _status = _status + 1;
    if (_status == 6) _status = 0;
    if (_status == 4) _status = 5; // Suppression  Fin des Votes
    if (_status == 2) _status = 3; // Suppression  Fin des Votes
    /*   Attendre Retour <PML>
      myGames[cestCeluiLa].gamestatus = _status;
      PhlCommons.gameStatus = _status;
 */

    Uri url = Uri.parse(pathPHP + "promoteGAME.php");
    var data = {
      "GAMECODE": PhlCommons.thisGameCode.toString(),
      "GAMESTATUS": _status.toString(),
      "GAMEDATE": DateTime.now().toString(),
    };
    http.Response response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      setState(() {
        myGames[cestCeluiLa].gamestatus = _status;
        PhlCommons.gameStatus = _status;
      });

      promoteGameState = true;
    } else {}
  }

  quelleAction(int _laquelle) {
    PhlCommons.thisGameCode = takeThisGameCode;
    if (_laquelle == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const GameUserSingle(),
          settings: RouteSettings(
            arguments: myPerso,
          ),
        ),
      );
    }

    if (_laquelle == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameVote(),
          settings: RouteSettings(
            arguments: myPerso,
          ),
        ),
      );
    }

    if (_laquelle == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameVoteResultPlus(),
          settings: RouteSettings(
            arguments: myPerso,
          ),
        ),
      );
    }
  }

  Future setGuOffGames() async {
    Uri url = Uri.parse(pathPHP + "setGUOFFGAME.php");
    var data = {
      "UID": PhlCommons.thatUid.toString(),
    };
    http.Response response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      setGuOffGamesState = true;
    } else {}
  }
}
