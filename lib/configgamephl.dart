//220701  Ajout du Path pour la PreProd

import 'dart:core';
import 'package:flutter/material.dart';

const String pathPHP = "https://lamemopole.com/php/"; // PROD
//<PMLV2>
const String prefixPhoto = "upoad/PML_01_"; // Syntaxe
//const String pathPHP = "https://www.paulbrode.com/php/"; //DEV

const String unknownCodeMaster = "Code Incorrect";
Color colorKO = Colors.red;
Color colorOK = Colors.green;
String medalBronze = "🥉";
String medalGold = "🥇";
//String medalGold=""🥇 🥈 🥉";
List medals = ["🥇", "🥇", "🥈", "🥉"];
String medalSilver = "🥈";
List modeGame = ["PUBLIC", "PRIVATE"];
List msgNewGame = ["Nom Game ?", "Photos Selected ? "];
List statusGame = [
  "Attente du départ",
  "Caption  en cours",
  "Fin des Captions",
  "Vote en cours",
  "Fin des Votes",
  "Résultats",
  "Aborted"
];
List statusGU = [
  "Attend",
  "Commente",
  "a Commenté",
  "Vote",
  "a Voté",
  "Resultats",
  "Aborted"
];
List statusUser = ["DISABLED", "ENABLED"];
