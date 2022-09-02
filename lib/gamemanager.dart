import 'dart:convert';
import 'dart:core';
import 'dart:math';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:gameover/configgamephl.dart';
import 'package:gameover/gamephlclass.dart';
import 'package:gameover/phlcommons.dart';
import 'package:gameover/selectgamers.dart';
import 'package:gameover/selectphotos.dart';
import 'package:http/http.dart' as http;

//<PMLV2>
class ButtonWidget extends StatelessWidget {
  final String text;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onClicked;

  const ButtonWidget(
      {Key? key,
      required this.text,
      required this.onClicked,
      this.color = Colors.white,
      this.backgroundColor = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
      onPressed: onClicked,
      child: Text(
        text,
        style: TextStyle(fontSize: 20, color: color),
      ));
}

class GameManager extends StatefulWidget {
  const GameManager({Key? key}) : super(key: key);

  @override
  State<GameManager> createState() => _GameManagerState();
}

class _GameManagerState extends State<GameManager> {
  GameCommons myPerso = GameCommons("xxxx", 0, 0);
  bool myBool = false;
  bool isGameActif = false; // Pas de Game Acfig
  bool isPublic = true;
  bool isGameValidated = false;
  int nbGmGames = 0; //: Nb de Games pour cr GameGM
  List<Games> listGmGames = []; // Games of that _GM connected
  TextEditingController gameNameController = TextEditingController();
  TextEditingController gameNbGamersController = TextEditingController();
  String thatGameName = ""; //<TODO>
  int thatGameCode = 0;
  String thatGM = "xx";
  int thatGmid = 0;
  double nbGamers = 1;
  double nbPhotos = 1;
  double nbSecMeme = 20;
  double nbSecVote = 30;
  String dispNbFotosGame = "0";
  String thatGameCodeString = "";
  bool timeOut = false;
  bool getGmGamesState = false;
  int getGmGamesError = -1;
  bool createGameState = false;
  int createGameError = -1;

  @override
  Widget build(BuildContext context) {
    // Attention mal  placé
    myPerso = ModalRoute.of(context)!.settings.arguments as GameCommons;
    gameNameController.text = thatGameCodeString;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: thatGM,
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
                  ElevatedButton(
                    onPressed: () => {null},
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 10),
                        textStyle: const TextStyle(
                            fontSize: 10,
                            backgroundColor: Colors.blue,
                            fontWeight: FontWeight.bold)),
                    child: Text('' + myPerso.myPseudo + " ",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                        )),
                  ),
                  Row(
                    children: [
                      Tooltip(
                        message: 'Copy',
                        child: ElevatedButton(
                            onPressed: () =>
                                {copyClipBoard(thatGameCodeString)},
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                textStyle: const TextStyle(
                                    fontSize: 14,
                                    backgroundColor: Colors.blue,
                                    fontWeight: FontWeight.bold)),
                            child: Text(thatGameCodeString,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.normal,
                                ))),
                      ),
                      Visibility(
                        visible: isGameValidated,
                        child: const Text(" is READY",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                            )),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ]),
          //  ECRAN PRINCIP
          body: Container(
            constraints:
                BoxConstraints(minHeight: MediaQuery.of(context).size.height
                    //set minimum height equal to 100% of VH
                    ),
            width: MediaQuery.of(context).size.width,
            //make width of outer wrapper to 100%
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.orange,
                  Colors.deepOrangeAccent,
                  Colors.red,
                  Colors.redAccent,
                ],
              ),
            ),
            //show linear gradient background of page
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [
                SafeArea(
                  child: Column(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          ElevatedButton(
                              onPressed: () => {overSelectPhotosPhl()},
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  textStyle: const TextStyle(
                                      fontSize: 20,
                                      backgroundColor: Colors.blue,
                                      fontWeight: FontWeight.bold)),
                              child: const Text('Photos')),
                          PhlCommons.nbFotosGame > 0
                              ? Text(
                                  "  " +
                                      PhlCommons.nbFotosGame.toString() +
                                      " Photos Choisies",
                                  style: TextStyle(fontSize: 22))
                              : Text(""),
                        ],
                      ),
                    ),
                    Padding(
                      // Slider N°1 Gamers
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          ElevatedButton(
                              onPressed: () => {overSelectGamersPhl()},
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  textStyle: const TextStyle(
                                      fontSize: 20,
                                      backgroundColor: Colors.blue,
                                      fontWeight: FontWeight.bold)),
                              child: const Text('Gamers')),
                          PhlCommons.nbGamersGame > 0
                              ? Text(
                                  "  " +
                                      PhlCommons.nbGamersGame.toString() +
                                      " Gamers",
                                  style: TextStyle(fontSize: 22))
                              : Text(""),
                        ],
                      ),
                    ),
                    Padding(
                      // Slider N° 3   Sec/Mem
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          ElevatedButton(
                              onPressed: () => {null},
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  textStyle: const TextStyle(
                                      fontSize: 20,
                                      backgroundColor: Colors.blue,
                                      fontWeight: FontWeight.bold)),
                              child: Text("Meming time = " +
                                  nbSecMeme.toString() +
                                  " s")),
                          //   Text( "Meming time = " + nbSecMeme.toString() + " s"),
                          Slider(
                            label:
                                'Temps total accordé pour légender TOUTES les photos choisies',
                            activeColor: Colors.orange,
                            divisions: 20,
                            min: 20,
                            max: 420,
                            value: nbSecMeme,
                            onChanged: (double newValue) {
                              setState(() {
                                newValue = newValue.round() as double;
                                if (newValue != nbSecMeme) nbSecMeme = newValue;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    /*       Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          ElevatedButton(
                              onPressed: () => {null},
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  textStyle: const TextStyle(
                                      fontSize: 20,
                                      backgroundColor: Colors.blue,
                                      fontWeight: FontWeight.bold)),
                              child: Text("Voting Time = " +
                                  nbSecVote.toString() +
                                  " s")),
                          Slider(
                            label:
                                'Temps total accordé pour voter pour TOUS les memes',
                            activeColor: Colors.orange,
                            divisions: 20,
                            min: 10,
                            max: 110,
                            value: nbSecVote,
                            onChanged: (double newValue) {
                              setState(() {
                                newValue = newValue.round() as double;
                                if (newValue != nbSecVote) nbSecVote = newValue;
                              });
                            },
                          ),
                        ],
                      ),
                    ),*/
                    Visibility(
                      visible: !isGameValidated,
                      child: Row(
                        children: [
                          Visibility(
                            visible: isValidatedOk(),
                            child: Center(
                              child: ElevatedButton(
                                onPressed: () => {newGame()},
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 10),
                                    textStyle: const TextStyle(
                                        fontSize: 10,
                                        backgroundColor: Colors.green,
                                        fontWeight: FontWeight.bold)),
                                child: const Text('SAVE',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    )),
                              ),
                            ),
                            //createGameState
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ));
  }

  copyClipBoard(String copire) {
    //  Clipboard.setData(ClipboardData(text: "your text"));
    FlutterClipboard.copy(copire).then((value) => print('copied'));
  }

  Expanded dispMyGames() {

    setState(() {});
    if (listGmGames.isEmpty) {
      return (const Expanded(child: Text(' No GAMES !!! for GM')));
    }
    var listView = ListView.builder(
        itemCount: listGmGames.length,
        controller: ScrollController(),
        itemBuilder: (context, index) {
          return ListTile(
              dense: true,
              title: Row(children: [
                Text(listGmGames[index].gamename +
                    ":" +
                    listGmGames[index].gamecode.toString() +
                    " " +
                    statusGame[listGmGames[index].gamestatus])
              ]),
              onTap: () {
                setState(() {});
              });
        });
    return (Expanded(child: listView));
  }

  genCodeGame() {
    var rng = Random();
    var rand1 = rng.nextInt(8) + 1;
    var rand2 = rng.nextInt(1000000);
    setState(() {
      thatGameCode = rand1 * 10000000 + rand2;
      thatGameCodeString = thatGameCode.toString();

      thatGameName = thatGameCode.toString();
    });
  }

  Future getGmGames() async {
    Uri url = Uri.parse(pathPHP + "getGMGAMES.php");
    var data = {
      "GMID": "2",
    };
    getGmGamesState = false;
    getGmGamesError = -1;
    http.Response response = await http.post(url, body: data);

    if (response.body.toString() == 'ERR_1001') {
      nbGmGames = 0;
      getGmGamesError = 1001; //Not Found

    }

    if (response.statusCode == 200 && (getGmGamesError != 1001)) {
      var datamysql = jsonDecode(response.body) as List;
      getGmGamesError = 0;
      setState(() {
        getGmGamesError = 0;

        listGmGames = datamysql.map((xJson) => Games.fromJson(xJson)).toList();

        getGmGamesState = true;
      });
    } else {}
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      genCodeGame();
      PhlCommons.thisGameCode = thatGameCode;
      PhlCommons.nbFotosGame = 0;
      PhlCommons.nbGamersGame = 0;
    });
  }

  bool isValidatedOk() {
    //PhlCommons.nbFotosGame
    bool _isOK = false;
    _isOK = (PhlCommons.nbFotosGame > 0) &&
        (PhlCommons.nbGamersGame > 0) &&
        !isGameValidated;

    return (_isOK);
  }

  majCommonGame(
      int _gameCode,
      int _gameMode,
      int _gameStatus,
      String _gameName,
      String _gameDate,
      int _gmid,
      int _gameNbGamers,
      int _gameNbPhotos,
      int _gameNbGamersActifs,
      int _gameFilter,
      int _gameTimeMeme,
      int _gameTimeVote,
      int _gameTimer,
      int _gameOpen) {
    PhlCommons.gameActif.gamecode = _gameCode;
    PhlCommons.gameActif.gamemode = _gameMode;
    PhlCommons.gameActif.gamestatus = _gameStatus;
    PhlCommons.gameActif.gamename = _gameName;
    PhlCommons.gameActif.gamedate = _gameDate;
    PhlCommons.gameActif.gmid = _gmid;
    PhlCommons.gameActif.gamenbgamers = _gameNbGamers;
    PhlCommons.gameActif.gamenbphotos = _gameNbPhotos;
    PhlCommons.gameActif.gamenbgamersactifs = _gameNbGamersActifs;
    PhlCommons.gameActif.gamefilter = _gameFilter;
    PhlCommons.gameActif.gametimememe = _gameTimeMeme;
    PhlCommons.gameActif.gametimevote = _gameTimeVote;
    PhlCommons.gameActif.gametimer = _gameTimer;
    PhlCommons.gameActif.gameopen = _gameOpen;
  }

  Future newGame() async {
    int _gameStatus = 0; // PHOTOCLOSED
    int _gameNbGamersActifs = 0;
    int _gameFilter = 0;
    int _thatMode = 0;
    int _gameTimer = 0;
    int _gameOpen = 0;
    if (isPublic) _thatMode = 1;
    isGameValidated = true; // OK on a preque valid
    String _today = DateTime.now().toString();

    majCommonGame(
      thatGameCode,
      _thatMode,
      _gameStatus,
      thatGameName,
      _today,
      myPerso.myUid,
      nbGamers.toInt(),
      nbPhotos.toInt(),
      _gameNbGamersActifs,
      _gameFilter,
      nbSecMeme.toInt(),
      nbSecVote.toInt(),
      _gameTimer,
      _gameOpen,
    );
    Uri url = Uri.parse(pathPHP + "createGAME.php");
    createGameState = false;
    createGameError = -1;
// onforce status à Zero
    int _forceStatus = 1; // <PHL> Request
    var data = {
      "GAMECODE": PhlCommons.gameActif.gamecode.toString(),
      "GAMEMODE": PhlCommons.gameActif.gamemode.toString(),
      "GAMESTATUS": _forceStatus.toString(),
      "GAMENAME": PhlCommons.gameActif.gamename,
      "GAMEDATE": PhlCommons.gameActif.gamedate,
      "GMID": myPerso.myUid.toString(),
      // Garde UID de celui qui se connecte Pas de Doublons
      "GAMENBGAMERS": PhlCommons.nbGamersGame.toString(),
      "GAMENBPHOTOS": PhlCommons.nbFotosGame.toString(),
      "GAMENBGAMERSACTIFS": PhlCommons.gameActif.gamenbgamersactifs.toString(),
      "GAMEFILTER": PhlCommons.gameActif.gamefilter.toString(),
      "GAMETIMEMEME": PhlCommons.gameActif.gametimememe.toString(),
      "GAMETIMEVOTE": PhlCommons.gameActif.gametimevote.toString(),
      "GAMETIMER": PhlCommons.gameActif.gametimer.toString(),
      "GAMEOPEN": PhlCommons.gameActif.gameopen.toString(),
    };
    var response = await http.post(url, body: data);

    if (response.body.toString() == 'ERR_1001') {
      nbGmGames = 0;
      createGameState = false;
      createGameError = 1001;
    }

    if (response.statusCode == 200 && (createGameError != 1001)) {
      var datamysql = jsonDecode(response.body) as List;
      createGameError = 0;
      setState(() {
        createGameError = 0;
        listGmGames = datamysql.map((xJson) => Games.fromJson(xJson)).toList();
        createGameState = true;

        // On vient de creer UN GAME
        // ON lindique à l'appelant

        PhlCommons.gameNew = 1;
      });
    } else {}
    //  getGmGames();
  }

  Future overSelectGamersPhl() async {
    await (Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectGamers(),
        settings: RouteSettings(
          arguments: myPerso,
        ),
      ),
    ));
    setState(() {
      dispNbFotosGame = PhlCommons.nbFotosGame.toString(); // <TODO>
    });
  }

  Future overSelectPhotosPhl() async {
    await (Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectPhotosPhl(),
        settings: RouteSettings(
          arguments: myPerso,
        ),
      ),
    ));
    setState(() {
      dispNbFotosGame = PhlCommons.nbFotosGame.toString(); // <TODO>
    });
  }
}
