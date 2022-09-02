import 'dart:core';
import 'package:flutter/material.dart';

//<PMLV2>
class CheckMLVU {
  //"SELECT MEMOLIKEID,UID, MLVPOINTS  from MEMOLIKEVOTE  order by MEMOLIKEID";
  int memolikeid = 0;
  int mlvpoints = 0;
  int cumu = 0; //nb Votes avec cette nore

  CheckMLVU({
    required this.memolikeid,
    required this.mlvpoints,
    required this.cumu,
  });

  factory CheckMLVU.fromJson(Map<String, dynamic> json) {
    return CheckMLVU(
      memolikeid: int.parse(json['MEMOLIKEID']),
      mlvpoints: int.parse(json['MLVPOINTS']),
      cumu: int.parse(json['CUMU']),
    );
  }
}

class CheckVote {
  int cosum = 0;

  CheckVote({
    required this.cosum,
  });

  factory CheckVote.fromJson(Map<String, dynamic> json) {
    return CheckVote(
      cosum: int.parse(json['COSUM']),
    );
  }
}

class CheckVotePlus {
  // SELECT MEMOLIKEID ,MLVPOINTS, COUNT(MLVPOINTS) AS 'CUMU'
  // from MEMOLIKEVOTE GROUP BY MEMOLIKEID,MLVPOINTS
  // order by MEMOLIKEID,MLVPOINTS;
  int memolikeid = 0;
  int mlvpoints = 0;
  int cumu = 0; //nb Votes avec cette nore

  CheckVotePlus(
      {required this.memolikeid, required this.mlvpoints, required this.cumu});

  factory CheckVotePlus.fromJson(Map<String, dynamic> json) {
    return CheckVotePlus(
      memolikeid: int.parse(json['MEMOLIKEID']),
      mlvpoints: int.parse(json['MLVPOINTS']),
      cumu: int.parse(json['CUMU']),
    );
  }
}

class ClefCodes {
  String clefcode = "XXX";
  int clefcodeid = 0;

  ClefCodes({
    required this.clefcode,
    required this.clefcodeid,
  });

  factory ClefCodes.fromJson(Map<String, dynamic> json) {
    return ClefCodes(
      clefcode: json['CLEFCODE'] as String,
      clefcodeid: int.parse(json['CLEFCODEID']),
    );
  }
}

class Evaluations {
  int evalpoints = 0;
  int gameid = 0;
  int memeid = 0;
  String guimarker = "XXX";
  String guiwriter = "XXX";

  Evaluations({
    required this.evalpoints,
    required this.gameid,
    required this.memeid,
    required this.guimarker,
    required this.guiwriter,
  });

  factory Evaluations.fromJson(Map<String, dynamic> json) {
    return Evaluations(
      evalpoints: int.parse(json['EVALPOINTS']),
      gameid: int.parse(json['GAMEID']),
      memeid: int.parse(json['MEMEID']),
      guimarker: json['GUIMARKER'] as String,
      guiwriter: json['GUIWRITER'] as String,
    );
  }
}

class GameAudika {
  /*
  | AUDIKAID | CODID | LASTID | GAMECODE | LASTDATE   |
  +----------+-------+--------+----------+------------+
  |       96 |     1 |     13 | 80181888 | 2022-07-20 |
  |       97 |     2 |      0 | 80181888 | 2022-07-20 |
  |       98 |     3 |      0 | 80181888 | 2022-07-20 |

  */
  int audikaid = 0;
  int codid = 0;
  int lastid = 0;
  int gamecode = 0;
  String lastdate = "05-05-2022";

  GameAudika({
    required this.audikaid,
    required this.codid,
    required this.lastid,
    required this.gamecode,
    required this.lastdate,
  });

  factory GameAudika.fromJson(Map<String, dynamic> json) {
    return GameAudika(
      audikaid: int.parse(json['AUDIKAID']),
      codid: int.parse(json['CODID']),
      lastid: int.parse(json['LASTID']),
      gamecode: int.parse(json['GAMECODE']),
      lastdate: json['LASTDATE'] as String,
    );
  }
}

class GameByUser {
  int uid = 0;
  int gamecode = 0;
  int gamestatus = 0;
  int gmid = 0;

  // Du plus
  int gustatus = 0; // Le stayu du conecté dans ce game
  bool isSelected = false;
  Color extraColor = Colors.grey;
  int uidaction =
      0; // <0 rienW><1 doit commenter>   <=2 doit Voter >  <3 doit regarder>
  GameByUser({
    required this.uid,
    required this.gamecode,
    required this.gmid,
    required this.gamestatus,
  });

  factory GameByUser.fromJson(Map<String, dynamic> json) {
    return GameByUser(
      uid: int.parse(json['UID']),
      gamecode: int.parse(json['GAMECODE']),
      gmid: int.parse(json['GMID']),
      gamestatus: int.parse(json['GAMESTATUS']),
    );
  }
}

class GameLike {
  int memeid = 0; //  C'est un index à Conserver
  int photoid = 0;
  int uid = 0; // Celui Qui
  int gamecode = 0; // En plus
  String photofilename = "FFFF";
  String photofiletype = "TTT";
  String memetext = "FFFF";
  int mynote = 0;
  String uname = "XX";

  GameLike(
      {required this.memeid,
      required this.photoid,
      required this.uid,
      required this.gamecode,
      required this.photofilename,
      required this.photofiletype,
      required this.memetext,
      required this.uname});

  factory GameLike.fromJson(Map<String, dynamic> json) {
    return GameLike(
      memeid: int.parse(json['MEMEID']),
      photoid: int.parse(json['PHOTOID']),
      uid: int.parse(json['UID']),
      gamecode: int.parse(json['GAMECODE']),
      photofilename: json['PHOTOFILENAME'] as String,
      photofiletype: json['PHOTOFILETYPE'] as String,
      memetext: json['MEMETEXT'] as String,
      uname: json['UNAME'] as String,
    );
  }
}

class GameMasters {
  int gmid = 0; // Auto
  String gmpseudo = "XXXX";
  String gmname = "zzzzz";
  String gmpwd = "YYYYY";
  String gmlast = "2022-05-05";
  String gmipv4 = "**.**.**.**";

  GameMasters(
      {required this.gmid,
      required this.gmpseudo,
      required this.gmname,
      required this.gmpwd,
      required this.gmlast,
      required this.gmipv4});

  factory GameMasters.fromJson(Map<String, dynamic> json) {
    return GameMasters(
        gmid: int.parse(json['GMID']),
        gmpseudo: json['GMPSEUDO'] as String,
        gmname: json['GMNAME'] as String,
        gmpwd: json['GMPWD'] as String,
        gmlast: json['GMLAST'] as String,
        gmipv4: json['GMIPV4'] as String);
  }
}

class GamePhotoSelect {
  int gamecode = 0;
  int photoid = 0;

  GamePhotoSelect({
    required this.gamecode,
    required this.photoid,
  });

  factory GamePhotoSelect.fromJson(Map<String, dynamic> json) {
    return GamePhotoSelect(
      gamecode: int.parse(json['GAMECODE']),
      photoid: int.parse(json['PHOTOID']),
    );
  }
}

class Games {
  int gameid = 0; // Auto
  int gamecode = 0;
  int gamemode = 0;
  int gamestatus = 0;
  String gamename = "";
  String gamedate = "2022-05-05";
  int gmid = 0; // GameMAster
  int gamenbgamers = 0;
  int gamenbgamersactifs = 0;
  int gamenbphotos = 0;
  int gamefilter = 0;
  int gametimememe = 0;
  int gametimevote = 0;
  int gametimer = 0;
  int gameopen = 0;

  bool isSelected = false;
  Color extraColor = Colors.grey;

  Games(
      {required this.gameid,
      required this.gamecode,
      required this.gamemode,
      required this.gamestatus,
      required this.gamename,
      required this.gamedate,
      required this.gmid,
      required this.gamenbgamers,
      required this.gamenbphotos,
      required this.gamenbgamersactifs,
      required this.gamefilter,
      required this.gametimememe,
      required this.gametimevote,
      required this.gametimer,
      required this.gameopen});

  factory Games.fromJson(Map<String, dynamic> json) {
    return Games(
      gameid: int.parse(json['GAMEID']),
      gamecode: int.parse(json['GAMECODE']),
      gamemode: int.parse(json['GAMEMODE']),
      gamestatus: int.parse(json['GAMESTATUS']),
      gamename: json['GAMENAME'] as String,
      gamedate: json['GAMEDATE'] as String,
      gmid: int.parse(json['GMID']),
      gamenbgamers: int.parse(json['GAMENBGAMERS']),
      gamenbphotos: int.parse(json['GAMENBPHOTOS']),
      gamenbgamersactifs: int.parse(json['GAMENBGAMERSACTIFS']),
      gamefilter: int.parse(json['GAMEFILTER']),
      gametimememe: int.parse(json['GAMETIMEMEME']),
      gametimevote: int.parse(json['GAMETIMEVOTE']),
      gametimer: int.parse(json['GAMETIMER']),
      gameopen: int.parse(json['GAMEOPEN']),
    );
  }
} // Games

class GameUsers {
  int guid = 0;
  int uid = 0;
  int gamecode = 0;
  int gustatus = 0;
  String guipv4 = "**.**.**.**";
  String gulast = "05-05-2022";
  int gustate = 0;
  String uname = "***";
  int uprofile = 0;

/*
 GUID | UID | GAMECODE | GUIPV4 | GULAST              | UNAME     | UPROFILE |
 */
  GameUsers({
    required this.guid,
    required this.uid,
    required this.gamecode,
    required this.gustatus,
    required this.guipv4,
    required this.gulast,
    required this.gustate,
    required this.uname,
    required this.uprofile,
  });

  factory GameUsers.fromJson(Map<String, dynamic> json) {
    return GameUsers(
      guid: int.parse(json['GUID']),
      uid: int.parse(json['UID']),
      gamecode: int.parse(json['GAMECODE']),
      gustatus: int.parse(json['GUSTATUS']),
      guipv4: json['GUIPV4'] as String,
      gulast: json['GULAST'] as String,
      gustate: int.parse(json['GUSTATE']),
      uname: json['UNAME'] as String,
      uprofile: int.parse(json['UPROFILE']),
    );
  }
}

class GameVotes {
  int uid = 0;
  int memeid = 0;
  int gamecode = 0;
  int gvpoints = 0;
  String gvlast = "05-05-2022";

  GameVotes({
    required this.uid,
    required this.memeid,
    required this.gamecode,
    required this.gvpoints,
    required this.gvlast,
  });

  factory GameVotes.fromJson(Map<String, dynamic> json) {
    return GameVotes(
      uid: int.parse(json['UID']),
      memeid: int.parse(json['MEMEID']),
      gamecode: int.parse(json['GAMECODE']),
      gvpoints: int.parse(json['GVPOINTS']),
      gvlast: json['GVLAST'] as String,
    );
  }
}

class GameVotesResultMeme {
  int memeid = 0;
  int gamecode = 0;
  int sumg = 0;

  GameVotesResultMeme({
    required this.memeid,
    required this.gamecode,
    required this.sumg,
  });

  factory GameVotesResultMeme.fromJson(Map<String, dynamic> json) {
    return GameVotesResultMeme(
      memeid: int.parse(json['MEMEID']),
      gamecode: int.parse(json['GAMECODE']),
      sumg: int.parse(json['SUMG']),
    );
  }
}

class GameVotesResultUid {
  int uid = 0;
  int gamecode = 0;
  int sumg = 0;

  GameVotesResultUid({
    required this.uid,
    required this.gamecode,
    required this.sumg,
  });

  factory GameVotesResultUid.fromJson(Map<String, dynamic> json) {
    return GameVotesResultUid(
      uid: int.parse(json['UID']),
      gamecode: int.parse(json['GAMECODE']),
      sumg: int.parse(json['SUMG']),
    );
  }
}

class Memes {
  int memeid = 0;
  int photoid = 0;
  int gamecode = 0;
  int uid = 0;
  String memetext = "";

  Memes({
    required this.memeid,
    required this.photoid,
    required this.gamecode,
    required this.uid,
    required this.memetext,
  });

  factory Memes.fromJson(Map<String, dynamic> json) {
    return Memes(
      memeid: int.parse(json['MEMEID']),
      photoid: int.parse(json['PHOTOID']),
      gamecode: int.parse(json['GAMECODE']),
      uid: int.parse(json['UID']),
      memetext: json['MEMETEXT'] as String,
    );
  }
}

class MemoLike {
  // En cours
  int memolikeid = 0;
  int memostockid = 0;
  int photoid = 0;
  String memostock = "..";
  String photofilename = "FFFF";
  String photofiletype = "TTT";
  String memolikeuser = "MEMOLIKEUSER";

  MemoLike(
      {required this.memolikeid,
      required this.memostockid,
      required this.photoid,
      required this.memostock,
      required this.photofilename,
      required this.photofiletype,
      required this.memolikeuser});

  factory MemoLike.fromJson(Map<String, dynamic> json) {
    return MemoLike(
      memolikeid: int.parse(json['MEMOLIKEID']),
      memostockid: int.parse(json['MEMOSTOCKID']),
      photoid: int.parse(json['PHOTOID']),
      memostock: json['MEMOSTOCK'] as String,
      photofilename: json['PHOTOFILENAME'] as String,
      photofiletype: json['PHOTOFILETYPE'] as String,
      memolikeuser: json['MEMOLIKEUSER'] as String,
    );
  }
}

class MemopolUsers {
  int uid = 0;
  int ustatus = 0;
  int uprofile = 0;
  String uname = "UNAMEX";

  // String upass = "PASSWX";
  String upseudo = "AAAAX";
  String umail = "AAA@WW.ZZZ";
  String uipcreate = "FF.FF.FF.FF.FF";
  String uiptoday = "FF.FF.FF.FF.FF";
  String ucdate = "06-06-2022";
  String uldate = "06-06-2022";
  String messadmin = "";

  // 64  Admin 32  Game Manager  16 Game User  4 Invited 2 nothing bit 1 : O  =0
  MemopolUsers(
      {required this.uid,
      required this.ustatus,
      required this.uprofile,
      required this.uname,
      // required this.upass,
      required this.upseudo,
      required this.umail,
      required this.uipcreate,
      required this.uiptoday,
      required this.ucdate,
      required this.uldate,
      required this.messadmin});

  factory MemopolUsers.fromJson(Map<String, dynamic> json) {
    return MemopolUsers(
      uid: int.parse(json['UID']),
      ustatus: int.parse(json['USTATUS']),
      uprofile: int.parse(json['UPROFILE']),
      uname: json['UNAME'] as String,
      //    upass: json['UPASS'] as String,
      upseudo: json['UPSEUDO'] as String,
      umail: json['UMAIL'] as String,
      uipcreate: json['UIPCREATE'] as String,
      uiptoday: json['UIPTODAY'] as String,
      ucdate: json['UCDATE'] as String,
      uldate: json['ULDATE'] as String,
      messadmin: json['MESSADMIN'] as String,
    );
  }
}

class MemopolUsersReduce {
  int uid = 0;
  int ustatus = 0;
  int uprofile = 0;
  String uname = "UNAMEX";
  Color extraColor = Colors.grey;
  bool isSelected = false;

  //GUID,GAMEUSERS.UID,GAMECODE,GUIPV4,GULAST,UNAME,UPROFILE
  MemopolUsersReduce({
    required this.uid,
    required this.ustatus,
    required this.uprofile,
    required this.uname,
  });

  factory MemopolUsersReduce.fromJson(Map<String, dynamic> json) {
    return MemopolUsersReduce(
      uid: int.parse(json['UID']),
      ustatus: int.parse(json['USTATUS']),
      uprofile: int.parse(json['UPROFILE']),
      uname: json['UNAME'] as String,
    );
  }
}

class Memoto {
  // En cours
  int memostockid = 0;
  String memostock = "..";
  String memocat = "..";

  Memoto({
    required this.memostockid,
    required this.memostock,
    required this.memocat,
  });

  factory Memoto.fromJson(Map<String, dynamic> json) {
    return Memoto(
      memostockid: int.parse(json['MEMOSTOCKID']),
      memostock: json['MEMOSTOCK'] as String,
      memocat: json['MEMOCAT'] as String,
    );
  }
}

class PhotoBase {
  int photofilesize = 0;
  int photoheight = 0;
  int photoid = 0;
  int photoinode = 0;
  int photowidth = 0;
  String photocat = "NOT";
  String photouploader = "YYY";
  String photodate = "05-05-2022";
  String photofilename = "FFFF";
  String photofiletype = "TTT";
  String memetempo = ""; // <TODO> Le ptit plu
  // Add
  bool isSelected = false;
  double extraWidth = 100;
  double extraHeight = 100;
  Color extraColor = Colors.grey;

  PhotoBase({
    required this.photofilesize,
    required this.photoheight,
    required this.photoid,
    required this.photoinode,
    required this.photowidth,
    required this.photocat,
    required this.photouploader,
    required this.photodate,
    required this.photofilename,
    required this.photofiletype,
  });

  factory PhotoBase.fromJson(Map<String, dynamic> json) {
    return PhotoBase(
      photofilesize: int.parse(json['PHOTOFILESIZE']),
      photoheight: int.parse(json['PHOTOHEIGHT']),
      photoid: int.parse(json['PHOTOID']),
      photoinode: int.parse(json['PHOTOINODE']),
      photowidth: int.parse(json['PHOTOWIDTH']),
      photocat: json['PHOTOCAT'] as String,
      photouploader: json['PHOTOUPLOADER'] as String,
      photodate: json['PHOTODATE'] as String,
      photofilename: json['PHOTOFILENAME'] as String,
      photofiletype: json['PHOTOFILETYPE'] as String,
    );
  }
}

class PhotoCat {
  String photocat = "XXXX";
  String photocast = "XXXX";
  int nbphotos = 0;
  int selected = 0;
  int firstphotoid = 0;

  PhotoCat({
    required this.photocat,
  });

  factory PhotoCat.fromJson(Map<String, dynamic> json) {
    return PhotoCat(
      photocat: json['PHOTOCAT'] as String,
    );
  }

  setNumber(int _number) {
    nbphotos = _number;
  }

  setphotoid(_thatphotoid) {
    firstphotoid = _thatphotoid;
  }

  setSelected(int _selected) {
    selected = _selected;
  }

  supMM() {
    photocast = photocat.substring(3);
  }
}

class PhotoClefs {
  int photoid = 0;
  int clefcodeid = 0;

  PhotoClefs({
    required this.photoid,
    required this.clefcodeid,
  });

  factory PhotoClefs.fromJson(Map<String, dynamic> json) {
    return PhotoClefs(
      photoid: int.parse(json['PHOTOID']),
      clefcodeid: int.parse(json['CLEFCODEID']),
    );
  }
}

class PhotoRandomLive {
  int photoid = 0;
  String photomemelive = "XXXX";

  PhotoRandomLive({
    required this.photoid,
    required this.photomemelive,
  });
}

//  "SELECT SURCAT, CATRED,CATFULL FROM SUPERCAT  ORDER BY CATRED, SURCAT";
class SurCat {
  String surcat = "XXX";
  String catred = "XXX";
  String catfull = "XXX";
  int nbphotos = 0;
  int selected = 0;
  int firstphotoid = 0;

  SurCat({
    required this.surcat,
    required this.catred,
    required this.catfull,
  });

  factory SurCat.fromJson(Map<String, dynamic> json) {
    return SurCat(
        surcat: json['SURCAT'] as String,
        catred: json['CATRED'] as String,
        catfull: json['CATFULL'] as String);
  }

  setNumber(int _number) {
    nbphotos = _number;
  }

  setphotoid(_thatphotoid) {
    firstphotoid = _thatphotoid;
  }

  setSelected(int _selected) {
    selected = _selected;
  }
}
