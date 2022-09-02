import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gameover/configgamephl.dart';
import 'package:gameover/gamephlclass.dart';
import 'package:http/http.dart' as http;

//<PMLV2>
class ManageUsers extends StatefulWidget {
  const ManageUsers({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ManageUsers();
  }
}

class _ManageUsers extends State<ManageUsers> {
  late String errormsg;
  late bool error, showprogress;
  late String username, password;

  List<MemopolUsers> listMemopolUsers = [];

  bool getAllMemopolUserState = false;
  int getAllMemopolUserError = -1;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent
            //color set to transperent or set your own color
            ));

    return Scaffold(
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
            child: Column(children: <Widget>[
              getViewMemopolUsers(),
            ])));
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

  Future getAllMemopolUser() async {
    Uri url = Uri.parse(pathPHP + "readAllMEMOPOLUSERS.php");
    var data = {"UNAME": username, "UPASS": password};
    getAllMemopolUserState = false;
    getAllMemopolUserError = -1;
    http.Response response = await http.post(url, body: data);
    if (response.body.toString() == 'ERR_1001') {}

    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;

      setState(() {
        getAllMemopolUserError = 0;
        listMemopolUsers =
            datamysql.map((xJson) => MemopolUsers.fromJson(xJson)).toList();
        getAllMemopolUserState = true;
      });
    } else {}
  }

  Expanded getViewMemopolUsers() {
    setState(() {});

    if (!getAllMemopolUserState) {
      return (const Expanded(child: Text(".......")));
    }
    var listView = ListView.builder(
        itemCount: listMemopolUsers.length,
        controller: ScrollController(),
        itemBuilder: (context, index) {
          return ListTile(
              dense: true,
              title: Row(
                children: [
                  Text(listMemopolUsers[index].uname + " ",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal,
                      )),
                  Text(statusUser[listMemopolUsers[index].ustatus],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal,
                      )),
                  IconButton(
                      icon: const Icon(Icons.save),
                      iconSize: 35,
                      color: Colors.green,
                      tooltip: 'Save Selection',
                      onPressed: () {
                        //
                      }),
                ],
              ),
              onTap: () {
                setState(() {
                  listMemopolUsers[index].ustatus =
                      1 - listMemopolUsers[index].ustatus;
                });
              });
        });

    return (Expanded(child: listView));
  }

  @override
  void initState() {
    username = "";
    password = "";
    errormsg = "";
    error = false;
    showprogress = false;

    getAllMemopolUser();
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
}
