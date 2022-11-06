//c:\src\flutter\bin\flutter run -d chrome --no-sound-null-safety --web-renderer=html
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ricochetrobots/games_list.dart';
import 'package:ricochetrobots/help.dart';
import 'package:ricochetrobots/about.dart';
import 'main.dart';
import 'singleplayer.dart';
import 'singleplayer_debugging.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class Arguments {
  final String gamename;

  Arguments(this.gamename);
}


class MenuList extends StatelessWidget {

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
    return Scaffold( backgroundColor: Colors.black,
        appBar: new AppBar(
          backgroundColor: Colors.black,
          //title: new Text("Comic Reader Multi Language"),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('RATHA'),
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
        Column(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[ Row( mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[ //Text("Game Menu",style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          TextButton(
            style: TextButton.styleFrom(
                primary: Colors.white,
                textStyle: TextStyle(fontSize: 32, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold)
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (
                        ctxt) => new singleplayer(),
                    settings: RouteSettings(
                        //arguments: Arguments("")
                        //arguments: Arguments(_auth.currentUser?.email)

                // comic.reference.id,
                      // comic.data()["title"].toString(),
                      // comic.data()["lang"].toString(),
                    ),
                  ));
            },
            child: const Text('SINGLEPLAYER'),
          ),
          ]),
              Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[ //Text("Game Menu",style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    Text('---------------------------------------------------------------------------------------------------------', style: TextStyle(color: Colors.white)),
                  ]),
              Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[ //Text("Game Menu",style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          textStyle: TextStyle(fontSize: 32, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold)
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (
                                  ctxt) => new GamesList(),
                              settings: RouteSettings(
                                  arguments: Arguments("")
                                // comic.reference.id,
                                // comic.data()["title"].toString(),
                                // comic.data()["lang"].toString(),
                              ),
                            ));
                      },
                      child: const Text('MULTIPLAYER - JOIN'),
                    ),
                  ]),

              Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[ //Text("Game Menu",style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    Text('---------------------------------------------------------------------------------------------------------', style: TextStyle(color: Colors.white)),
                  ]),
              Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[ //Text("Game Menu",style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          textStyle: TextStyle(fontSize: 32, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold)
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (
                                  ctxt) => new help(),
                              settings: RouteSettings(
                                  arguments: Arguments("")
                                // comic.reference.id,
                                // comic.data()["title"].toString(),
                                // comic.data()["lang"].toString(),
                              ),
                            ));
                      },
                      child: const Text('HELP/TUTORIAL'),
                    ),
                  ]),

              Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[ //Text("Game Menu",style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    Text('---------------------------------------------------------------------------------------------------------', style: TextStyle(color: Colors.white)),
                  ]),
              Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[ //Text("Game Menu",style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          textStyle: TextStyle(fontSize: 32, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold)
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (
                                  ctxt) => new about(),
                              settings: RouteSettings(
                                  arguments: Arguments("")
                                // comic.reference.id,
                                // comic.data()["title"].toString(),
                                // comic.data()["lang"].toString(),
                              ),
                            ));
                      },
                      child: const Text('ABOUT'),
                    ),
                  ]),

              Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[ //Text("Game Menu",style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    Text('---------------------------------------------------------------------------------------------------------', style: TextStyle(color: Colors.white)),
                  ]),
              Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[ //Text("Game Menu",style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          textStyle: TextStyle(fontSize: 32, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold)
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (
                                  ctxt) => new singleplayer_debugging(),
                              settings: RouteSettings(
                                  arguments: Arguments("")
                                // comic.reference.id,
                                // comic.data()["title"].toString(),
                                // comic.data()["lang"].toString(),
                              ),
                            ));
                      },
                      child: const Text('Singleplayer Debug'),
                    ),
                  ])
        ]   )
    );
  }

}
