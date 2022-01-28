//c:\src\flutter\bin\flutter run -d chrome --no-sound-null-safety --web-renderer=html
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart'; //as firebase_storage;
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ricochetrobots/games_list.dart';
import 'main.dart';
import 'game_activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

FirebaseAuth auth = FirebaseAuth.instance;


class Arguments {
  final String gamename;

  Arguments(this.gamename);
}


class singleplayer extends StatelessWidget {

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
        Column(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[ //Text("Game Menu",style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    Text('UNDER CONSTRUCTION'),
                  ]),
              Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[ //Text("Game Menu",style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    Text(''),
                  ]),

            ]   )
    );
  }

}
