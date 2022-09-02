import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gameover/configgamephl.dart';
import 'package:gameover/gamephlclass.dart';
import 'package:gameover/phlcommons.dart';
import 'package:http/http.dart' as http;

//<PMLV2>
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginPage();
  }
}

class _LoginPage extends State<LoginPage> {
  late String errormsg;
  late bool error, showprogress;
  late String username, password;
  final _username = TextEditingController();
  final _password = TextEditingController();
  List<MemopolUsers> listMemopolUsers = [];
  bool getMemopolUserState = false;
  int getMemopolUserError = -1;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent
            //color set to transperent or set your own color
            ));

    return Scaffold(
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
              "Sign Into LaMemopole",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ), //title text
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: const Text(
              "Sign In   Name and Password",
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
                label: "Username",
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
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 20),
            child: SizedBox(
              height: 60,
              width: double.infinity,
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    //show progress indicator on click
                    showprogress = true;
                  });
                  startLogin();
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
                        "LOGIN NOW",
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
        PhlCommons.thatUid = listMemopolUsers[0].uid;
        Navigator.pop(context, listMemopolUsers);
      });
    } else {}
  }

  @override
  void initState() {
    username = "";
    password = "";
    errormsg = "";
    error = false;
    showprogress = false;
    super.initState();
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
          )),

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

  startLogin() async {
    Uri url = Uri.parse(pathPHP + "checkMEMOPOLUSERS.php");
    var data = {"UNAME": username, "UPASS": password};
    http.Response response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      if (jsondata["loginStatus"]) {
        setState(() {
          showprogress = false; //don't show progress indicator
          error = true;
          errormsg = jsondata["message"];

          getMemopolUser();
        });
      } else {
        setState(() {
          error = false;
          showprogress = false; //don't show progress indicator
          error = true;
          errormsg = "Something went wrong.";
        });
      }
    }
  }
}
