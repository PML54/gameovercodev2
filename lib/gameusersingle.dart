import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:gameover/configgamephl.dart';
import 'package:gameover/gamephlclass.dart';
import 'package:gameover/phlcommons.dart';
import 'package:http/http.dart' as http;

//<PMLV2>
class GameUserSingle extends StatefulWidget {
  const GameUserSingle({Key? key}) : super(key: key);

  @override
  State<GameUserSingle> createState() => _GameUserSingleState();
}

class _GameUserSingleState extends State<GameUserSingle> {
  GameCommons myPerso = GameCommons("xxxx", 0, 0);

  bool myBool = false;
  bool feuOrange = true;
  List<Games> myGuGame = []; //  only one Games
  bool getGamePhotoSelectState = false;
  int getGamePhotoSelectError = -1;
  List<PhotoBase> listPhotoBase = [];
  bool getGameUserState = false;
  int getGameUserError = -1;
  List<GameUsers> listGuy = [];
  bool getMemeUserState = false;
  int getMemeUserError = -1;
  List<Memes> myGuMeme = [];
  bool getGamebyUidState = false;
  int getGamebyUidError = 0;
  List<GameByUser> myGames = [];
  bool createMemeState = false;
  int createMemeError = -1;
  int totalSeconds = 0;
  TextEditingController legendeController = TextEditingController();
  String thatPseudo = PhlCommons.thatPseudo;
  String memeLegende = "";
  bool timeOut = false;

  int cestCeluiLa = 0;
  bool getGamebyCodeState = false;
  int getGamebyCodeError = 0;
  bool changeStatusGameUserState = false;
  bool changeStateGameUserState = false;
  bool chronoStart = false;
  Duration countdownDuration = const Duration(seconds: 10000);
  int timerMemeGame = 0;

  //Duration countdownDuration = Duration();
  Duration duration = const Duration();
  Timer? timer;
  bool countDown = true;
  Color colorCounter = Colors.green;

  void addTime() {
    final addSeconds = countDown ? -1 : 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0) {
        timer?.cancel();
        timeOut = true;
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

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
                  child: const Text('Exit'),
                  onPressed: () {
                    // createMeme();
                    changeStatusGameUser(2);
                    stopTimer();
                    Navigator.pop(context);
                  }),
              ElevatedButton(
                  onPressed: () => {null},
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      textStyle: const TextStyle(
                          fontSize: 14,
                          backgroundColor: Colors.green,
                          fontWeight: FontWeight.bold)),
                  child: Text(myPerso.myPseudo)),
              Text(PhlCommons.thisGameCode.toString()),
              Visibility(
                visible:
                    chronoStart && getGamebyCodeState && totalSeconds < 9900,
                child: Text('->' + totalSeconds.toString() + 's',
                    style: TextStyle(
                        color: (totalSeconds < 10) ? Colors.red : Colors.white,
                        fontSize: 18)),
              )
            ],
          ),
        ),
      ]),
      body: SafeArea(
        child: Row(children: <Widget>[
          Align(child: buildTime()),
          getget(),
          getListView(),
        ]),
      ),
    ));
  }

  buildTime() {
    setState(() {
      totalSeconds = duration.inSeconds;
      if (totalSeconds < 10) colorCounter = Colors.red;
    });
    if (totalSeconds <= 1) {
      createMeme();
      stopTimer();
      changeStatusGameUser(2); //MEME CLOSED
      Navigator.pop(context);
    }
  }

  Future changeStateGameUser(int _state) async {
    Uri url = Uri.parse(pathPHP + "changeStateGameUser.php");
    changeStateGameUserState = false;
    var data = {
      "GAMECODE": PhlCommons.thisGameCode.toString(),
      "UID": PhlCommons.thatUid.toString(),
      "GUSTATE": (_state).toString(),
    };
    await http.post(url, body: data);
    changeStateGameUserState = true;
  }

  Future changeStatusGameUser(int _status) async {
    Uri url = Uri.parse(pathPHP + "changeStatusGameUser.php");
    changeStatusGameUserState = false;
    var data = {
      "GAMECODE": PhlCommons.thisGameCode.toString(),
      "UID": PhlCommons.thatUid.toString(),
      "GUSTATUS": (_status).toString(),
    };
    await http.post(url, body: data);
    PhlCommons.thatStatus = _status;
    changeStatusGameUserState = true;
  }

  Future createMeme() async {
    createMemeState = false;
    Uri url = Uri.parse(pathPHP + "createMEME.php");

    PhotoBase _brocky = listPhotoBase[cestCeluiLa];

    var data = {
      "PHOTOID": _brocky.photoid.toString(),
      "GAMECODE": PhlCommons.thisGameCode.toString(),
      "UID": PhlCommons.thatUid.toString(),
      "MEMETEXT": _brocky.memetempo,
    };

    if (_brocky.memetempo.length > 1) {
      http.Response response = await http.post(url, body: data);

      if (response.statusCode == 200) {
        setState(() {
          createMemeState = true;
        });
      }
    }
  }

  @override
  void dispose() {
    legendeController.dispose();
    super.dispose();
  }

  Future getGamebyCode() async {
    int _thisGameCode = PhlCommons.thisGameCode;
    bool gameCodeFound = true;
    Uri url = Uri.parse(pathPHP + "getGAMEBYCODE.php");
    var data = {
      "GAMECODE": _thisGameCode.toString(),
    };
    http.Response response = await http.post(url, body: data);
    if (response.body.toString() == 'ERR_1001') {
      gameCodeFound = false;
      getGamebyCodeState = false;
      getGamebyCodeError = 1001;
    } else {
      gameCodeFound = true;
    }
    if (response.statusCode == 200 && (gameCodeFound)) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        myGuGame = datamysql.map((xJson) => Games.fromJson(xJson)).toList();
        getGamebyCodeState = true;
        getGamebyCodeError = 0;
        // On le met à  la source
        timerMemeGame = myGuGame[0].gametimememe;
        //countdownDuration = const Duration(seconds: 100);
        countdownDuration = Duration(seconds: timerMemeGame);
        getGamePhotoSelect(); // Il faut le GameCore
      });
    } else {}
  }

  Future getGamebyUid() async {
    Uri url = Uri.parse(pathPHP + "getGAMEBYUID.php");
    var data = {
      "UID": PhlCommons.thatUid.toString(),
    };
    http.Response response = await http.post(url, body: data);
    if (response.body.toString() == 'ERR_1001') {
      getGamebyUidState = false;
      getGamebyUidError = 1001;
    }
    if (response.statusCode == 200 && (getGamebyUidError != 1001)) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        myGames = datamysql.map((xJson) => GameByUser.fromJson(xJson)).toList();

        //PhlCommons.thisGameCode = myGames.last.gamecode;
        getGamePhotoSelect(); // Il faut le GameCore
        getGamebyCode(); // H-eu
        getGamebyUidState = true;
        getGamebyUidError = 0;
      });
    } else {}
  }

  Future getGamePhotoSelect() async {
    getGamePhotoSelectState = false;
    getGamePhotoSelectError = -1;
    Uri url = Uri.parse(pathPHP + "getGAMEPHOTOS.php");

    var data = {
      "GAMECODE": PhlCommons.thisGameCode.toString(),
    };
    http.Response response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        listPhotoBase =
            datamysql.map((xJson) => PhotoBase.fromJson(xJson)).toList();
        getGamePhotoSelectState = true;
        getGamePhotoSelectError = 0;
        // On Empie c'est bon
        getMemeUser();
      });
    } else {
      getGamePhotoSelectError = 2001;
    }
  }

  Expanded getget() {
    if (!getGamebyUidState ||
        !getGamePhotoSelectState ||
        PhlCommons.thatStatus >= 4) {
      return Expanded(
        child: Column(
          children: const [
            (Text('Wait Wait ....')),
          ],
        ),
      );
    }

    setState(() {
      legendeController.text = listPhotoBase[cestCeluiLa].memetempo;
      legendeController.selection = TextSelection.fromPosition(
          TextPosition(offset: legendeController.text.length));
    });
    return Expanded(
        child: (Column(
      children: [
        TextField(
          controller: legendeController,
          keyboardType: TextInputType.multiline,
          maxLines: 2,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Meme?",
          ),
          onChanged: (text) {
            setState(() {
              memeLegende = text;
              legendeController.text = memeLegende;
              legendeController.selection = TextSelection.fromPosition(
                  TextPosition(offset: legendeController.text.length));
              listPhotoBase[cestCeluiLa].memetempo = memeLegende;
            });
          },
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                textStyle: const TextStyle(
                    fontSize: 14,
                    backgroundColor: Colors.green,
                    fontWeight: FontWeight.bold)),
            child: Text('SAVE & NEXT'),
            onPressed: () {
              setState(() {
                createMeme();
                cestCeluiLa++;
                if (cestCeluiLa >= listPhotoBase.length) cestCeluiLa = 0;
              });
            }),
        Image.network(
          "upload/" +
              listPhotoBase[cestCeluiLa].photofilename +
              "." +
              listPhotoBase[cestCeluiLa].photofiletype,
          width: (listPhotoBase[cestCeluiLa].extraWidth * 2),
          height: (listPhotoBase[cestCeluiLa].extraHeight * 2),
        ),
      ],
    )));
  }

  Expanded getListView() {
    setState(() {});
    if (!getGamebyUidState || !getGamePhotoSelectState) {
      return (const Expanded(child: Text(".............")));
    }
    //
    if (feuOrange) {
      setState(() {
        //
        timerMemeGame = myGuGame[0].gametimememe;
        countDown = true;
        countdownDuration = Duration(seconds: timerMemeGame);
        duration = Duration(seconds: timerMemeGame);
        reset();

        startTimer();
        chronoStart = true;
        feuOrange = false;

        //
      });
    }
    var listView = ListView.builder(
        itemCount: listPhotoBase.length,
        controller: ScrollController(),
        itemBuilder: (context, index) {
          return ListTile(
              dense: true,
              title: Row(
                children: [
                  Expanded(
                    child: Image.network(
                      "upload/" +
                          listPhotoBase[index].photofilename +
                          "." +
                          listPhotoBase[index].photofiletype,
                      /*width: (listPhotoBase[index].extraWidth),
                            height: (listPhotoBase[index].extraHeight),*/
                    ),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  cestCeluiLa = index;
                });
              });
        });
    return (Expanded(child: listView));
  }

  Future getMemeUser() async {
    getMemeUserState = false;
    getMemeUserError = -1;
    Uri url = Uri.parse(pathPHP + "getMEMEBYUSER.php");
    var data = {
      "GAMECODE": PhlCommons.thisGameCode.toString(),
      "UID": PhlCommons.thatUid.toString(),
    };
    http.Response response = await http.post(url, body: data);
    if (response.body.toString() == 'ERR_1001') {
      getMemeUserError = 1001;
    }
    if (response.statusCode == 200 && (getMemeUserError != 1001)) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        myGuMeme = datamysql.map((xJson) => Memes.fromJson(xJson)).toList();
        getMemeUserState = true;
      });
    } else {}
  }

  @override
  void initState() {
    super.initState();

    getGamebyUidState = true;
    getGamebyCode(); // H-eu
    reset();
    changeStateGameUser(1);

    changeStatusGameUser(1); //MEMING
  }

  void reset() {
    if (countDown) {
      setState(() => duration = countdownDuration);
      duration = countdownDuration;
    } else {
      setState(() => duration = const Duration());
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    setState(() => timer?.cancel());
  }
}
