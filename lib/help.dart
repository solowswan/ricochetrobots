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


class help extends StatelessWidget {

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
                    Text('Physics: \n The red/blue/green and yellow robots will always move vertically'
                        ' \n or horizontally until they bump into an obstacle (A wall or another robot).'
                        '\n'
                        'Target: '
                        '\n To move a robot in the least number of moves into the given target. '
                        '\n The color of the robot must match the color of the target. '
                        '\n Other robots can also be moved. '
                        '\n All moves of all robots are summed up'
                        '\n Game mechanics: '
                        '\n 1) Figure out the maximum number of moves required to reach the target.'
                    '\n 2) Submit a bid with your minimum number of moves'
                    '\n 3) When the first player submits a bid, the countdown will start'
                    '\n 4) After countdown the lowest bidder must defend the bid'
                        '\n 5) If the lowest bidder fails, the second lowest bidder takes over, etc..., until a winner is determined'
                        '\n 6) New round with new target'
                        ''),
                  ]),
              Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[ //Text("Game Menu",style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    Text(''),
                  ]),

            ]   )
    );
  }

}
