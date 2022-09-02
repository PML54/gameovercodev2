import 'dart:core';

import 'package:gameover/gamephlclass.dart';
//<PMLV2>
class GameCommons {
  int myProfile;
  String myPseudo = "";
  int myUid;
  int myGame = 0;

  GameCommons(this.myPseudo, this.myProfile, this.myUid);
}


class PhlCommons {
  static int thisGameCode = 0;
  static int thisGameId = 0;
  static int nbtic = 0;
  static int lastmodify = 1;
  static int nbFotosGame = 0;
  static int nbGamersGame = 0;
  static String thatPseudo = "";
  static List<GameMasters> listThatGM = [];
  static List<Games> listThatGame = [];
  static int isAdmin = 0;
  static int thatUid = 0;
  static int thatStatus = 0;
  static int gameStatus = 0;
  static int thatState = 0;
  static int random = 1; // Normal 2 = Films<PHL>
  static int gameNew = 0;
  static Games gameActif = Games(
      gameid: -1,
      gamecode: -1,
      gamemode: -1,
      gamestatus: -1,
      gamename: "XXXX",
      gamedate: "DDDDD",
      gmid: -1,
      gamenbgamers: -1,
      gamenbphotos: -1,
      gamenbgamersactifs: -1,
      gamefilter: -1,
      gametimememe: -1,
      gametimevote: -1,
      gametimer: -1,
      gameopen: -1);
  int numiro;

  PhlCommons(this.numiro);
}
