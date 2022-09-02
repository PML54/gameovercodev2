import 'dart:convert';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gameover/configgamephl.dart';
import 'package:gameover/gamephlclass.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

//<PMLV2>
class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreatePage();
  }
}

class _CreatePage extends State<CreatePage> {
  late String errormsg;
  late bool error, showprogress;
  late String username, password;
  late String ipv4name, pseudo, email, messadmin;
  String datecreate = "";
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _email = TextEditingController();
  List<MemopolUsers> listMemopolUsers = [];
  bool getMemopolUserState = false;
  int getMemopolUserError = -1;
  final now = DateTime.now();
  final alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent
            //color set to transperent or set your own color
            ));

    return Scaffold(
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
                  // stopTimer();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ]),
      body: SingleChildScrollView(
          child: Container(
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
        child: Column(children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 80),
            child: const Text(
              "Demande Acces LaMemopole",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ), //title text
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: const Text(
              "Creation  User memopole",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ), //subtitle text
          ),
          Container(
            //show error message here
            margin: const EdgeInsets.only(top: 30),
            padding: const EdgeInsets.all(10),
            child: error ? errmsg(errormsg) : Container(),
            //if error == true then show error message
            //else set empty container as child
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            margin: const EdgeInsets.only(top: 10),
            child: TextField(
              controller: _username, //set username controller
              style: TextStyle(color: Colors.orange[100], fontSize: 20),
              decoration: myInputDecoration(
                label: "Nom  pour se connecter  3 Caractéres Min ",
                icon: Icons.person,
              ),
              onChanged: (value) {
                //set username  text on change
                username = value;
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _password,
              //set password controller
              style: TextStyle(color: Colors.orange[100], fontSize: 20),
              obscureText: true,
              decoration: myInputDecoration(
                label: "Password",
                icon: Icons.lock,
              ),
              onChanged: (value) {
                // change password text
                password = value;
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            margin: const EdgeInsets.only(top: 10),
            child: TextField(
              controller: _email, //set username controller
              style: TextStyle(color: Colors.orange[100], fontSize: 20),
              decoration: myInputDecoration(
                label: "Email (facultatif-",
                icon: Icons.mail_lock_outlined,
              ),
              onChanged: (value) {
                //set username  text on change
                email = value;
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 20),
            child: SizedBox(
              height: 60,
              width: double.infinity,
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    //show progress indicator on click
                    // showprogress = true;
                  });

                  startCreate();
                },
                child: showprogress
                    ? SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.orange[100],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.deepOrangeAccent),
                        ),
                      )
                    : const Text(
                        "Appuyer pour CREATION",
                        style: TextStyle(fontSize: 20),
                      ),
                colorBrightness: Brightness.dark,
                color: Colors.orange,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)
                    //button corner radius
                    ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 20),
            child: InkResponse(
                onTap: () {
                  //action on tap
                },
                child: const Text(
                  "Password Oublié? Troubleshoot",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
          )
        ]),
      )),
    );
  }

  Widget errmsg(String text) {
    //error message widget.
    return Container(
      padding: const EdgeInsets.all(15.00),
      margin: const EdgeInsets.only(bottom: 10.00),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.red,
          border: Border.all(color: Colors.red, width: 2)),
      child: Row(children: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 6.00),
          child: const Icon(Icons.info, color: Colors.white),
        ), // icon for error message

        Text(text, style: const TextStyle(color: Colors.white, fontSize: 18)),
        //show error message text
      ]),
    );
  }

  Future getIP() async {
    final ipv4 = await Ipify.ipv4();

    ipv4name = ipv4;
  }

  Future getMemopolUser() async {
    Uri url = Uri.parse(pathPHP + "readMEMOPOLUSERS.php");
    var data = {"UNAME": username, "UPASS": password};
    getMemopolUserState = false;
    getMemopolUserError = -1;
    http.Response response = await http.post(url, body: data);
    if (response.body.toString() == 'ERR_1001') {}

    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        getMemopolUserError = 0;
        listMemopolUsers =
            datamysql.map((xJson) => MemopolUsers.fromJson(xJson)).toList();
        getMemopolUserState = true;

        Navigator.pop(context, listMemopolUsers);
        //Navigator.pop(context);
      });
    } else {}
  }

  @override
  void initState() {
    username = "";
    password = "";
    errormsg = "";
    ipv4name = "";
    pseudo = "xx"; //<PML>
    email = "";
    messadmin = "";
    datecreate = "";

    error = false;
    showprogress = false;

    datecreate = DateFormat('d/M/y').format(now); // 28/03/2020
    super.initState();
    ipv4name = "xx.xx.xx.xx";
    getIP();
  }

  InputDecoration myInputDecoration(
      {required String label, required IconData icon}) {
    return InputDecoration(
      hintText: label,
      //show label as placeholder
      hintStyle: TextStyle(color: Colors.orange[100], fontSize: 20),
      //hint text style
      prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 20, right: 10),
          child: Icon(
            icon,
            color: Colors.orange[100],
          )
          //padding and icon for prefix
          ),
      contentPadding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.orange, width: 1)),
      //default border of input

      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.orange, width: 1)),
      //focus border

      fillColor: const Color.fromRGBO(251, 140, 0, 0.5),
      filled: true, //set true if you want to show input background
    );
  }

  Future startCreate() async {
    Uri url = Uri.parse(pathPHP + "createMEMOPOLUSERS.php");
    var data = {
      "USTATUS": "0",
      "UPROFILE": "5",
      "UNAME": username,
      "UPASS": password,
      "UPSEUDO": pseudo,
      "UMAIL": email,
      "UIPCREATE": ipv4name,
      "UIPTODAY": ipv4name,
      "UCDATE": datecreate,
      "ULDATE": datecreate,
      "MESSADMIN": messadmin,
    };

    bool syntaxOK = true;

    if (!(alphanumeric.hasMatch(username))) {
      syntaxOK = false;
    }

    if (username.length < 3 || username.length > 12) syntaxOK = false;
    if (password.length < 3 || username.length > 12) syntaxOK = false;
    if (!syntaxOK) {
      return;
    }
    http.Response response = await http.post(url, body: data);

    if (response.statusCode == 200) {
      Navigator.pop(context, listMemopolUsers);
    }
  }
}
