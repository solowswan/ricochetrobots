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

FirebaseAuth auth = FirebaseAuth.instance;

class GamesList extends StatefulWidget {
  //SignUp({Key key, this.title}) : super(key: key);

//  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<GamesList> {

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

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        //title: new Text("Comic Reader Multi Language"),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Ricochet Robots - List of all available games'),
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
            onPressed: _signOut,
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.library_books),
            title: new Text('Library'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.shop),
              title: Text('Shop')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings')
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
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
              //print(bets[1]);
              //print(players[1]);
              //print(players.length);

              return (GridView.builder(
                  //shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                  ),
                  itemCount: game_name.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                        width: 100.0,
                        height: 30.0,
                        child: Row( children: <Widget>[Text('Game name: ${game_name[index].padRight(30,' ')}Round: ${game_round[index]} Host: ${game_host[index]}'),
                          TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.teal,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (
                                          ctxt) => new GameActivity(),
                                      settings: RouteSettings(
                                       // arguments: Arguments(
                                         // comic.reference.id,
                                         // comic.data()["title"].toString(),
                                         // comic.data()["lang"].toString(),
                                        ),
                                      ));
                            },
                            child: const Text('Join'),
                          ),
                    ]
                        )
                    );

                  }
              )


              );

            } else {return new Text("There is no data");}
            //return new ListView(children: getExpenseItems(snapshot1));
          }
      ),

    );
  }

}
