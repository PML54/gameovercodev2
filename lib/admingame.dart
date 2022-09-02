import 'package:flutter/material.dart';
import 'package:gameover/adminphotos.dart';
import 'package:gameover/gamephlclass.dart';
import 'package:gameover/manageusers.dart';
import 'package:google_fonts/google_fonts.dart';
//<PMLV2>
class AdminGame extends StatefulWidget {
  const AdminGame({Key? key}) : super(key: key);

  @override
  State<AdminGame> createState() => _AdminGameState();
}
class _AdminGameState extends State<AdminGame> {
  bool isAdmin = false;
  String connectedGuy = "";
  List<MemopolUsers> listMemopolUsers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              IconButton(
                  icon: const Icon(Icons.save),
                  iconSize: 35,
                  color: Colors.green,
                  tooltip: 'Save Selection',
                  onPressed: () {
                    // createMemeSolo();
                  }),
              const Text(' SVP  Caption'),
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
          padding: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(
                        child: Text(
                          'Admin Photos ',
                          style: GoogleFonts.averageSans(fontSize: 18.0),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminPhotos()),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    child: Text(
                      'xxxxxxx',
                      style: GoogleFonts.averageSans(fontSize: 18.0),
                    ),
                    onPressed: () {

                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    child: Text(
                      'Admin Users',
                      style: GoogleFonts.averageSans(fontSize: 18.0),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ManageUsers()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: IconButton(
          icon: const Icon(Icons.refresh),
          iconSize: 35,
          color: Colors.green,
          tooltip: 'Unused',
          onPressed: () {
            setState(() {});
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isAdmin = false;
    });
  }
}
