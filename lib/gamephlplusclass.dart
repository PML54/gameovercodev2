import 'dart:core';
//<PMLV2>
class GamersPlus {
  int uid = 0;
  int gamecode = 0;
  int gustatus = 0;

  GamersPlus({
    required this.uid,
    required this.gamecode,
    required this.gustatus,
  });

  factory GamersPlus.fromJson(Map<String, dynamic> json) {
    return GamersPlus(
      uid: int.parse(json['UID']),
      gamecode: int.parse(json['GAMECODE']),
      gustatus: int.parse(json['GUSTATUS']),
    );
  }
}



//
// Das cette classe on met à jour  des données sensibles sans relire  la totale
//C'est de l'update
// UN statut de Game ne  nécessite  pas de tout relire

class GamesPlus {
  int gamecode = 0;
  int gamestatus = 0;

  GamesPlus({
    required this.gamecode,
    required this.gamestatus,
  });

  factory GamesPlus.fromJson(Map<String, dynamic> json) {
    return GamesPlus(
      gamecode: int.parse(json['GAMECODE']),
      gamestatus: int.parse(json['GAMESTATUS']),
    );
  }
}

class Pipole {
  int uid = 0;
  int cumul = 0;

  Pipole({
    required this.uid,
    required this.cumul,
  });

  factory Pipole.fromJson(Map<String, dynamic> json) {
    return Pipole(
      uid: int.parse(json['UID']),
      cumul: int.parse(json['SUMG']),
    );
  }
}

/*
| PMLTABLE   | varchar(20) | YES  |     | NULL    |       |
| PMLFIELD   | varchar(20) | YES  |     | NULL    |       |
| PMLTYPE    | varchar(12) | YES  |     | NULL    |       |
| PMLNULL    | varchar(12) | YES  |     | NULL    |       |
| PMLKEY     | varchar(12) | YES  |     | NULL    |       |
| PMLDEFAULT | varchar(12) | YES  |     | NULL    |       |
| PMLEXTRA   | varchar(12) | YES  |     | NULL    |       |
| PMLDESC    | varchar(12) | YES  |     | NULL    |
   */
class PmlCheck {
  String pmltable = "";
  String pmlfield = "";
  String pmltype = "";

  String pmlnull = "";
  String pmlkey = "";
  String pmldefault = "";
  String pmlextra = "";
  String pmldesc = "";

  PmlCheck(
      {required this.pmltable,
      required this.pmlfield,
      required this.pmltype,
      required this.pmlnull,
      required this.pmlkey,
      required this.pmldefault,
      required this.pmlextra,
      required this.pmldesc});

  factory PmlCheck.fromJson(Map<String, dynamic> json) {
    return PmlCheck(
        pmltable: json['PMLTABLE'] as String,
        pmlfield: json['PMLFIELD'] as String,
        pmltype: json['PMLTYPE'] as String,
        pmlnull: json['PMLNULL'] as String,
        pmlkey: json['PMLKEY'] as String,
        pmldefault: json['PMLDEFAULT'] as String,
        pmlextra: json['PMLEXTRA'] as String,
        pmldesc: json['PMLDESC'] as String);
  }
}
