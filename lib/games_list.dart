//c:\src\flutter\bin\flutter run -d chrome --no-sound-null-safety --web-renderer=html
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart'; //as firebase_storage;
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'game_activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

FirebaseAuth auth = FirebaseAuth.instance;


class Arguments {
  final String gamename;

  Arguments(this.gamename);
}


class GamesList extends StatelessWidget {

  final email = TextEditingController();
  final password1 = TextEditingController();
  final password2 = TextEditingController();

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
  }

  Future<void> joinGame(String gameId) async {
    // Call the games's CollectionReference to add a new game
    CollectionReference games = FirebaseFirestore.instance.collection('Games');
    await games.doc(gameId).collection("Players").doc(_auth.currentUser?.email).set({'bet': 99,
      'score': 0,
      'timestampupdated': DateTime.now()
    },SetOptions(merge: true));
  }


  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override

  Widget build(BuildContext context) {
    return Scaffold( backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: Colors.black,
        //title: new Text("Comic Reader Multi Language"),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Ricochet Robots'),
          ],

        ),
        actions: <Widget>[
          TextButton(
            child:
            Text(
              //'Logout',
              'LogOut ${_auth.currentUser?.email}',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await Navigator.push(context, MaterialPageRoute(builder: (ctxt) => new LandingPage()));
            }
          ),
        ],
      ),


      body:
          Column(children: <Widget>[ Text("List of available games",style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,color: Colors.black)),

          StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Games').snapshots(), //.doc(_auth.currentUser.email).get(),
          builder: (context, AsyncSnapshot<QuerySnapshot> gameslist ) {
            if (gameslist.hasData) {
              var data = [];
              List<String> game_name = [];
              gameslist.data?.docs.forEach((f) => game_name.add(f.id.toString()));

              List<String> game_round = [];
              gameslist.data?.docs.forEach((f) => game_round.add(f.data()["Round"].toString()));

              List<String> game_host = [];
              gameslist.data?.docs.forEach((f) => game_host.add(f.data()["Host"].toString()));


              List<DataRow> _createRows(QuerySnapshot snapshot) {

                List<DataRow> newList = snapshot.docs.map((DocumentSnapshot documentSnapshot) {
                  return new DataRow(cells: [ DataCell(Text(documentSnapshot.id.toString(),style: TextStyle(fontSize: 14,color: Colors.black)),) ,
                                              DataCell(Text(documentSnapshot['Round'].toString(),style: TextStyle(fontSize: 14,color: Colors.black))),
                                              DataCell(Text(documentSnapshot['Host'].toString(),style: TextStyle(fontSize: 14,color: Colors.black))),
                                              DataCell(TextButton(
                                                style: TextButton.styleFrom(
                                                  primary: Colors.green,
                                                  textStyle: TextStyle(fontSize: 16, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold)
                                                ),
                                                onPressed: () {
                                                  joinGame(documentSnapshot.id.toString());
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (
                                                            ctxt) => new GameActivity(),
                                                        settings: RouteSettings(
                             arguments: Arguments(documentSnapshot.id.toString())
                            // comic.reference.id,
                            // comic.data()["title"].toString(),
                            // comic.data()["lang"].toString(),
                                                        ),
                                                      ));
                                                },
                                                child: const Text('Join'),
                                              ),)
                                            ]
                  );
                }).toList();

                return newList;
              }
              //print(bets[1]);
              //print(players[1]);
              //print(players.length);
              return (GridView.builder(
                  //shrinkWrap: true,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                  ),
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return DataTable(
                      headingRowHeight: 60,
                      dataRowHeight: 60,
                      headingRowColor: MaterialStateColor.resolveWith((states) => Colors.black),
                      showBottomBorder: true,
                      horizontalMargin: 5,
                      columnSpacing: 0,
                      columns: [
                          DataColumn(label: Text('NAME',style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.white),)),
                          DataColumn(label: Text('ROUND',style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.white),)),
                          DataColumn(label: Text('HOST',style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.white),)),
                          DataColumn(label: Text('',style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.white),))
                        ],
                      rows: _createRows(gameslist.data!),

                    );
                  }
              )


              );

            } else {return new Text("There is no data");}
            //return new ListView(children: getExpenseItems(snapshot1));
          }
      ),
    ]   )
    );
  }

}
