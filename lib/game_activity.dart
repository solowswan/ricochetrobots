import 'package:provider/provider.dart';
import 'dart:html';
import 'dart:async';
import 'package:flutter/material.dart';
import 'board_square.dart';
import 'helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:numberpicker/numberpicker.dart';
// Types of images available
enum ImageType {
  zero,
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  bomb,
  facingDown,
  flagged,
  bombnw,
  bombsw,
  bombne,
  bombse,
  redcircle,
  bluecrossne,
  bluecrossnw,
  bluecrossse,
  bluecrosssw,
  bluetrianglene,
  bluetrianglenw,
  bluetrianglese,
  bluetrianglesw,
  bluesaturnne,
  bluesaturnnw,
  bluesaturnse,
  bluesaturnsw,
  bluecirclene,
  bluecirclenw,
  bluecirclese,
  bluecirclesw,
  redcrossne,
  redcrossnw,
  redcrossse,
  redcrosssw,
  redtrianglene,
  redtrianglenw,
  redtrianglese,
  redtrianglesw,
  redsaturnne,
  redsaturnnw,
  redsaturnse,
  redsaturnsw,
  redcirclene,
  redcirclenw,
  redcirclese,
  redcirclesw,
  greencrossne,
  greencrossnw,
  greencrossse,
  greencrosssw,
  greentrianglene,
  greentrianglenw,
  greentrianglese,
  greentrianglesw,
  greensaturnne,
  greensaturnnw,
  greensaturnse,
  greensaturnsw,
  greencirclene,
  greencirclenw,
  greencirclese,
  greencirclesw,
  yellowcrossne,
  yellowcrossnw,
  yellowcrossse,
  yellowcrosssw,
  yellowtrianglene,
  yellowtrianglenw,
  yellowtrianglese,
  yellowtrianglesw,
  yellowsaturnne,
  yellowsaturnnw,
  yellowsaturnse,
  yellowsaturnsw,
  yellowcirclene,
  yellowcirclenw,
  yellowcirclese,
  yellowcirclesw,
  rainbowne,
  rainbownw,
  rainbowse,
  rainbowsw,
  walle,
  wallw,
  walln,
  walls,
  redplayer,
  bluepleyer,
  greenplayer,
  yellowpleyer
}



//class GameActivity extends StatefulWidget {
//  @override
//  _GameActivityState createState() => _GameActivityState();
//}

class GameActivity extends StatelessWidget {

  Timer _timer = Timer(Duration(milliseconds: 1), () {});
  int _start = 5;

  Future startTimer() async {
    CollectionReference gameupdate = FirebaseFirestore.instance.collection('Games/');
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          //setState(() {
          gameupdate.doc("TestGame").update({'Timer': _start });
          timer.cancel();
        //  });
        } else {
         // setState(() {
          gameupdate.doc("TestGame").update({'Timer': _start });
          _start--;
        //  });
        }
      },
    );
  }


  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Row and column count of the board
  int rowCount = 16;
  int columnCount = 16;

  int bluei = 8;
  int bluej = 5;

  int redi = 0;
  int redj = 5;

  int greeni = 5;
  int greenj = 5;

  int yellowi = 0;
  int yellowj = 5;


  final bet = TextEditingController();


  //int movecount=0;
  // The grid of squares
  List<List<BoardPosition>> boardpos = List.generate(16, (i) {
    return List.generate(16, (j) {
      return BoardPosition();
    });
  });

  @override
  //void initState() {
   // //super.initState();
  //  _initialiseGame();
 // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        //title: new Text("Comic Reader Multi Language"),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/BlueCrossNorthEast.png',
              fit: BoxFit.contain,
              height: 55,
            ),
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
            title: Text('Settings'),

          )
        ],
      ),


      body:
      StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Games').doc("TestGame").snapshots(), //counterStream,
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            //if(snapshot.hasData) {
            if (snapshot.hasData) {
              int PositionBlueI = snapshot.data?.data()!["bluei"];
              int PositionBlueAltI = snapshot.data?.data()!["bluealti"];
              int PositionBlueJ=snapshot.data?.data()!["bluej"];
              int PositionBlueAltJ = snapshot.data?.data()!["bluealtj"];

              int PositionRedI = snapshot.data?.data()!["redi"];
              int PositionRedAltI = snapshot.data?.data()!["redalti"];
              int PositionRedJ=snapshot.data?.data()!["redj"];
              int PositionRedAltJ = snapshot.data?.data()!["redaltj"];

              int PositionGreenI = snapshot.data?.data()!["greeni"];
              int PositionGreenAltI = snapshot.data?.data()!["greenalti"];
              int PositionGreenJ=snapshot.data?.data()!["greenj"];
              int PositionGreenAltJ = snapshot.data?.data()!["greenaltj"];

              int PositionYellowI = snapshot.data?.data()!["yellowi"];
              int PositionYellowAltI = snapshot.data?.data()!["yellowalti"];
              int PositionYellowJ=snapshot.data?.data()!["yellowj"];
              int PositionYellowAltJ = snapshot.data?.data()!["yellowaltj"];
              int movecount = snapshot.data?.data()!["movecount"];

              int GameRound = snapshot.data?.data()!["Round"];
              int RunningTimer = snapshot.data?.data()!["Timer"];
              String lowestbidder = snapshot.data?.data()!["lowestbidder"];
              int lowestbid = snapshot.data?.data()!["lowestbid"];
              print(lowestbidder);
              print(lowestbid);
              print(GameRound);
              print(RunningTimer);
              print(_auth.currentUser?.email);
              //QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Games/TestGame/Collectibles').orderBy('Round', descending: false).limit(1).get();
              //var list = querySnapshot.docs;
              //List<int> collectibleslist = [];
              // list.forEach((f) => bets.add(f.id));
              //list.forEach((f) => collectibleslist.add(f.data()['bet']));

              return (


                  ListView(
                    children: <Widget>[


                      Container(
                        color: Colors.grey,
                        height: 60.0,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveRedAlt(PositionRedI,PositionRedJ,1); };
                              },
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.arrow_upward,
                                  color: Colors.black,
                                  size: 40.0,
                                ),
                                backgroundColor: Colors.red,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveRedAlt(PositionRedI,PositionRedJ,2);};
                              },
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.black,
                                  size: 40.0,
                                ),
                                backgroundColor: Colors.red,
                              ),
                            ),
                            InkWell(
                              onTap: () {
            if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveRedAlt(PositionRedI,PositionRedJ,3);};
                              },
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.arrow_downward,
                                  color: Colors.black,
                                  size: 40.0,
                                ),
                                backgroundColor: Colors.red,
                              ),
                            ),
                            InkWell(
                              onTap: () {
            if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveRedAlt(PositionRedI,PositionRedJ,4);};
                              },
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                  size: 40.0,
                                ),
                                backgroundColor: Colors.red,
                              ),
                            ),
                            InkWell(
                              onTap: () {
            if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveBlueAlt(PositionBlueI,PositionBlueJ,1);};
                              },
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.arrow_upward,
                                  color: Colors.black,
                                  size: 40.0,
                                ),
                                backgroundColor: Colors.blue,
                              ),
                            ),
                            InkWell(
                              onTap: () {
            if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveBlueAlt(PositionBlueI,PositionBlueJ,2);};
                              },
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.black,
                                  size: 40.0,
                                ),
                                backgroundColor: Colors.blue,
                              ),
                            ),
                            InkWell(
                              onTap: () {
            if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveBlueAlt(PositionBlueI,PositionBlueJ,3);};
                              },
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.arrow_downward,
                                  color: Colors.black,
                                  size: 40.0,
                                ),
                                backgroundColor: Colors.blue,
                              ),
                            ),
                            InkWell(
                              onTap: () {
            if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveBlueAlt(PositionBlueI,PositionBlueJ,4);};
                              },
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                  size: 40.0,
                                ),
                                backgroundColor: Colors.blue,
                              ),
                            ),
                            InkWell(
                              onTap: () {
            if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveGreenAlt(PositionGreenI,PositionGreenJ,1);};
                              },
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.arrow_upward,
                                  color: Colors.black,
                                  size: 40.0,
                                ),
                                backgroundColor: Colors.green,
                              ),
                            ),
                            InkWell(
                              onTap: () {
            if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveGreenAlt(PositionGreenI,PositionGreenJ,2);};
                              },
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.black,
                                  size: 40.0,
                                ),
                                backgroundColor: Colors.green,
                              ),
                            ),
                            InkWell(
                              onTap: () {
            if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveGreenAlt(PositionGreenI,PositionGreenJ,3);};
                              },
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.arrow_downward,
                                  color: Colors.black,
                                  size: 40.0,
                                ),
                                backgroundColor: Colors.green,
                              ),
                            ),
                            InkWell(
                              onTap: () {
            if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveGreenAlt(PositionGreenI,PositionGreenJ,4);};
                              },
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                  size: 40.0,
                                ),
                                backgroundColor: Colors.green,
                              ),
                            ),
                            InkWell(
                              onTap: () {
            if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveYellowAlt(PositionYellowI,PositionYellowJ,1);};
                              },
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.arrow_upward,
                                  color: Colors.black,
                                  size: 40.0,
                                ),
                                backgroundColor: Colors.yellow,
                              ),
                            ),
                            InkWell(
                              onTap: () {
            if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveYellowAlt(PositionYellowI,PositionYellowJ,2);};
                              },
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.black,
                                  size: 40.0,
                                ),
                                backgroundColor: Colors.yellow,
                              ),
                            ),
                            InkWell(
                              onTap: () {
            if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveYellowAlt(PositionYellowI,PositionYellowJ,3);};
                              },
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.arrow_downward,
                                  color: Colors.black,
                                  size: 40.0,
                                ),
                                backgroundColor: Colors.yellow,
                              ),
                            ),
                            InkWell(
                              onTap: () {
            if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveYellowAlt(PositionYellowI,PositionYellowJ,4);};
                              },
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                  size: 40.0,
                                ),
                                backgroundColor: Colors.yellow,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _reinitialiseGame(PositionBlueI,PositionBlueJ,PositionRedI,PositionRedJ,PositionGreenI,PositionGreenJ,PositionYellowI,PositionYellowJ);
                                movecount=0;
                              },
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Colors.black,
                                  size: 40.0,
                                ),
                                backgroundColor: Colors.tealAccent,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _resetGame("TestGame");
                                movecount=0;
                              },
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.restart_alt,
                                  color: Colors.black,
                                  size: 40.0,
                                ),
                                backgroundColor: Colors.tealAccent,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child:Row(
                          children: <Widget>[
                            Expanded(child: TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter your BET'
                              ),
                              controller: bet,
                            ),
                            ),
                            Expanded(child: ElevatedButton(
                              child: Text('SUBMIT BET'),
                              onPressed: () {
                                _submitBet("TestGame",_auth.currentUser?.email,int.parse(bet.text));
                              },
                            ),
                            )
                          ],
                        ),

                      ),

                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('Games/TestGame/Collectibles').where("Round",isEqualTo: GameRound).snapshots(), //.doc(_auth.currentUser.email).get(),
                          builder: (context, AsyncSnapshot<QuerySnapshot> collectibles ) {
                            if (collectibles.hasData) {
                              List<String> target = [];
                              //List<String> bets = [];
                              //List<List<Players>> players;
                              //List<Map<String, dynamic>> send=[] ;
                              //snapshot1.data?.docs.forEach((f) => print(f.id));
                              collectibles.data?.docs.forEach((f) => target.add(f.id.toString()));
                              //collectibles.data?.docs.forEach((f) => players.add(f.id.toString()));
                              //print(target[0]);
                              //WIN CONDITION!!!!
                              if(boardpos[PositionGreenI][PositionGreenJ].collectible==target[0].toString() && target[0].toString().substring(0,5)=="green" && movecount<=lowestbid)
                              {
                                print(boardpos[PositionGreenI][PositionGreenJ].collectible);
                                print(target[0].toString().substring(0,5));
                                showAlertDialogWIN(context,GameRound,lowestbidder);
                              } else if(boardpos[PositionGreenI][PositionGreenJ].collectible==target[0].toString() && target[0].toString().substring(0,5)=="green" && movecount>lowestbid) {
                                showAlertDialogNEXTPLAYER(context,lowestbidder, PositionBlueI, PositionBlueJ, PositionRedI, PositionRedJ, PositionGreenI, PositionGreenJ, PositionYellowI, PositionYellowJ);
                              }
                              if(boardpos[PositionRedI][PositionRedJ].collectible==target[0].toString() && target[0].toString().substring(0,3)=="red" && movecount<=lowestbid)
                              {
                                print(boardpos[PositionRedI][PositionRedJ].collectible);
                                print(target[0].toString().substring(0,5));
                                showAlertDialogWIN(context,GameRound,lowestbidder);
                              }
                              if(boardpos[PositionBlueI][PositionBlueJ].collectible==target[0].toString() && target[0].toString().substring(0,4)=="blue" && movecount<=lowestbid)
                              {
                                print(boardpos[PositionBlueI][PositionBlueJ].collectible);
                                print(target[0].toString().substring(0,5));
                                showAlertDialogWIN(context,GameRound,lowestbidder);
                              }
                              if(boardpos[PositionYellowI][PositionYellowJ].collectible==target[0].toString() && target[0].toString().substring(0,6)=="yellow" && movecount<=lowestbid)
                              {
                                print(boardpos[PositionYellowI][PositionYellowJ].collectible);
                                print(target[0].toString().substring(0,5));
                                showAlertDialogWIN(context,GameRound,lowestbidder);
                              }

                              print("Debug");
                              //print(players.length);
                              //print(GameRound);
                              return (Container(
                                child:Row(
                                  children: <Widget>[
                                    Expanded(child: Text("ROUND "+ GameRound.toString()),
                                    ),

                                    Expanded(child: Text("Collectible " + target[0].toString().toUpperCase()),
                                    ),
                                    Expanded(child: Text(RunningTimer.toString()),
                                    )
                                  ],
                                ),

                              )

                              );

                            } else {return new Text("There is no data");}
                            //return new ListView(children: getExpenseItems(snapshot1));
                          }
                      ),




                      // The grid of squares
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columnCount,
                        ),
                        itemBuilder: (context, position) {
                          // Get row and column number of square
                          int rowNumber = (position / columnCount).floor();
                          int columnNumber = (position % columnCount);
                          Image image;

                          image = getImage(ImageType.facingDown);

                          //boardpos[redi][redj].redposition = true;
                          boardpos[PositionBlueAltI][PositionBlueAltJ].blueposition = false;
                          boardpos[PositionBlueI][PositionBlueJ].blueposition = true;
                          boardpos[PositionRedAltI][PositionRedAltJ].redposition = false;
                          boardpos[PositionRedI][PositionRedJ].redposition = true;
                          boardpos[PositionGreenAltI][PositionGreenAltJ].greenposition = false;
                          boardpos[PositionGreenI][PositionGreenJ].greenposition = true;
                          boardpos[PositionYellowAltI][PositionYellowAltJ].yellowposition = false;
                          boardpos[PositionYellowI][PositionYellowJ].yellowposition = true;
                          if ((rowNumber == 7) && (columnNumber == 7)) {
                            image = getImage(ImageType.bombnw);
                          }
                          if ((rowNumber == 8) && (columnNumber == 7)) {
                            image = getImage(ImageType.bombsw);
                          }
                          if ((rowNumber == 7) && (columnNumber == 8)) {
                            image = getImage(ImageType.bombne);
                          }
                          if ((rowNumber == 8) && (columnNumber == 8)) {
                            image = getImage(ImageType.bombse);
                          }
                          //Quadrant 1
                          if ((rowNumber == 4) && (columnNumber == 2)) {
                            image = getImage(ImageType.greencirclene);
                          }
                          if ((rowNumber == 2) && (columnNumber == 5)) {
                            image = getImage(ImageType.bluecrossse);
                          }
                          if ((rowNumber == 6) && (columnNumber == 1)) {
                            image = getImage(ImageType.yellowsaturnnw);
                          }
                          if ((rowNumber == 5) && (columnNumber == 7)) {
                            image = getImage(ImageType.redtrianglesw);
                          }
                          if ((rowNumber == 5) && (columnNumber == 0)) {
                            image = getImage(ImageType.walln);
                          }
                          if ((rowNumber == 4) && (columnNumber == 0)) {
                            image = getImage(ImageType.walls);
                          }
                          if ((rowNumber == 0) && (columnNumber == 3)) {
                            image = getImage(ImageType.walle);
                          }
                          if ((rowNumber == 0) && (columnNumber == 4)) {
                            image = getImage(ImageType.wallw);
                          }
                          //Quadrant 2
                          if ((rowNumber == 2) && (columnNumber == 9)) {
                            image = getImage(ImageType.bluetrianglese);
                          }
                          if ((rowNumber == 1) && (columnNumber == 13)) {
                            image = getImage(ImageType.redsaturnnw);
                          }
                          if ((rowNumber == 6) && (columnNumber == 11)) {
                            image = getImage(ImageType.yellowcirclene);
                          }
                          if ((rowNumber == 5) && (columnNumber == 14)) {
                            image = getImage(ImageType.greencrosssw);
                          }
                          if ((rowNumber == 0) && (columnNumber == 11)) {
                            image = getImage(ImageType.walle);
                          }
                          if ((rowNumber == 0) && (columnNumber == 12)) {
                            image = getImage(ImageType.wallw);
                          }
                          if ((rowNumber == 3) && (columnNumber == 15)) {
                            image = getImage(ImageType.walls);
                          }
                          if ((rowNumber == 4) && (columnNumber == 15)) {
                            image = getImage(ImageType.walln);
                          }
                          //Quadrant 3
                          if ((rowNumber == 11) && (columnNumber == 1)) {
                            image = getImage(ImageType.redcirclesw);
                          }
                          if ((rowNumber == 9) && (columnNumber == 3)) {
                            image = getImage(ImageType.yellowcrossne);
                          }
                          if ((rowNumber == 14) && (columnNumber == 2)) {
                            image = getImage(ImageType.greentrianglenw);
                          }
                          if ((rowNumber == 12) && (columnNumber == 6)) {
                            image = getImage(ImageType.bluesaturnse);
                          }
                          if ((rowNumber == 15) && (columnNumber == 5)) {
                            image = getImage(ImageType.walle);
                          }
                          if ((rowNumber == 15) && (columnNumber == 6)) {
                            image = getImage(ImageType.wallw);
                          }
                          if ((rowNumber == 13) && (columnNumber == 0)) {
                            image = getImage(ImageType.walls);
                          }
                          if ((rowNumber == 14) && (columnNumber == 0)) {
                            image = getImage(ImageType.walln);
                          }
                          //Quadrant 4
                          if ((rowNumber == 10) && (columnNumber == 8)) {
                            image = getImage(ImageType.rainbownw);
                          }
                          if ((rowNumber == 10) && (columnNumber == 13)) {
                            image = getImage(ImageType.redcrossnw);
                          }
                          if ((rowNumber == 12) && (columnNumber == 14)) {
                            image = getImage(ImageType.yellowtrianglesw);
                          }
                          if ((rowNumber == 11) && (columnNumber == 10)) {
                            image = getImage(ImageType.greensaturnse);
                          }
                          if ((rowNumber == 14) && (columnNumber == 9)) {
                            image = getImage(ImageType.bluecirclene);
                          }
                          if ((rowNumber == 15) && (columnNumber == 11)) {
                            image = getImage(ImageType.walle);
                          }
                          if ((rowNumber == 15) && (columnNumber == 12)) {
                            image = getImage(ImageType.wallw);
                          }
                          if ((rowNumber == 8) && (columnNumber == 15)) {
                            image = getImage(ImageType.walls);
                          }
                          if ((rowNumber == 9) && (columnNumber == 15)) {
                            image = getImage(ImageType.walln);
                          }
                          if ((rowNumber == 9) && (columnNumber == 15)) {
                            image = getImage(ImageType.walln);
                          }
                          if ((rowNumber == 8) && (columnNumber == 15)) {
                            image = getImage(ImageType.walls);
                          }
                          if (boardpos[rowNumber][columnNumber].blueposition) {
                            return InkWell(
                              onTap: () {
                              },
                              splashColor: Colors.grey,
                              child: Container(
                                  color: Colors.grey,
                                  child: Stack(children: <Widget>[image,
                                    Image.asset('assets/images/blueplayer.png'),
                                  ])
                              ),
                            );
                          } else if (boardpos[rowNumber][columnNumber].redposition) {
                            return InkWell(
                              onTap: () {
                              },
                              splashColor: Colors.grey,
                              child: Container(
                                  color: Colors.grey,
                                  child: Stack(children: <Widget>[image,
                                    Image.asset('assets/images/redplayer.png'),
                                  ])
                              ),
                            );
                          } else if (boardpos[rowNumber][columnNumber].greenposition) {
                            return InkWell(
                              onTap: () {
                              },
                              splashColor: Colors.grey,
                              child: Container(
                                  color: Colors.grey,
                                  child: Stack(children: <Widget>[image,
                                    Image.asset('assets/images/greenplayer.png'),
                                  ])
                              ),
                            );
                          } else if (boardpos[rowNumber][columnNumber].yellowposition) {
                            return InkWell(
                              onTap: () {
                              },
                              splashColor: Colors.grey,
                              child: Container(
                                  color: Colors.grey,
                                  child: Stack(children: <Widget>[image,
                                    Image.asset('assets/images/yellowplayer.png'),
                                  ])
                              ),
                            );
                          } else {
                            return InkWell(
                              splashColor: Colors.grey,
                              child: Container(
                                  color: Colors.grey,
                                  child: Stack(children: <Widget>[image,
                                  ])
                              ),
                            );
                          }
                        },
                        itemCount: rowCount * columnCount,
                      ),
                      Text(movecount.toString(),style: TextStyle(fontSize: 32.0,fontWeight:FontWeight.bold)),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('Games/TestGame/Players').orderBy('bet', descending: false).snapshots(), //.doc(_auth.currentUser.email).get(),
                          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot1 ) {
                            if (snapshot1.hasData) {
                              var data = [];
                              List<String> players = [];
                              List<String> bets = [];
                              snapshot1.data?.docs.forEach((f) => bets.add(f.data()["bet"].toString()));
                              snapshot1.data?.docs.forEach((f) => players.add(f.id.toString()));
                              //print(bets[1]);
                              //print(players[1]);
                              //print(players.length);

                              return (ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: players.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Text('${players[index].length} Player: ${players[index].padRight(30,' ')}Bet:${bets[index]} ');

                                  }
                              )


                              );

                            } else {return new Text("There is no data");}
                            //return new ListView(children: getExpenseItems(snapshot1));
                          }
                      ),

                    ],

                  )

              );

            } else {return(Text("123"));}
          }



      ),






    );


  }
  // Initialises all lists
  Future _initialiseGame() async {
    //MIDDLE
    boardpos[6][7].obstaclesouth = true;
    boardpos[6][8].obstaclesouth = true;
    boardpos[7][9].obstaclewest = true;
    boardpos[8][9].obstaclewest = true;
    boardpos[9][7].obstaclenorth = true;
    boardpos[9][8].obstaclenorth = true;
    boardpos[7][6].obstacleeast = true;
    boardpos[8][6].obstacleeast = true;
    //WALL
    boardpos[0][0].obstaclenorth = true;
    boardpos[0][0].obstaclewest = true;
    boardpos[1][0].obstaclewest = true;
    boardpos[1][0].obstaclewest = true;
    boardpos[2][0].obstaclewest = true;
    boardpos[3][0].obstaclewest = true;
    boardpos[4][0].obstaclewest = true;
    boardpos[5][0].obstaclewest = true;
    boardpos[6][0].obstaclewest = true;
    boardpos[7][0].obstaclewest = true;
    boardpos[8][0].obstaclewest = true;
    boardpos[9][0].obstaclewest = true;
    boardpos[10][0].obstaclewest = true;
    boardpos[11][0].obstaclewest = true;
    boardpos[12][0].obstaclewest = true;
    boardpos[13][0].obstaclewest = true;
    boardpos[14][0].obstaclewest = true;
    boardpos[15][0].obstaclewest = true;
    boardpos[15][0].obstaclesouth = true;
    boardpos[15][1].obstaclesouth = true;
    boardpos[15][2].obstaclesouth = true;
    boardpos[15][3].obstaclesouth = true;
    boardpos[15][4].obstaclesouth = true;
    boardpos[15][5].obstaclesouth = true;
    boardpos[15][6].obstaclesouth = true;
    boardpos[15][7].obstaclesouth = true;
    boardpos[15][8].obstaclesouth = true;
    boardpos[15][9].obstaclesouth = true;
    boardpos[15][10].obstaclesouth = true;
    boardpos[15][11].obstaclesouth = true;
    boardpos[15][12].obstaclesouth = true;
    boardpos[15][13].obstaclesouth = true;
    boardpos[15][14].obstaclesouth = true;
    boardpos[15][15].obstaclesouth = true;
    boardpos[15][15].obstacleeast = true;
    boardpos[14][15].obstacleeast = true;
    boardpos[13][15].obstacleeast = true;
    boardpos[12][15].obstacleeast = true;
    boardpos[11][15].obstacleeast = true;
    boardpos[10][15].obstacleeast = true;
    boardpos[9][15].obstacleeast = true;
    boardpos[8][15].obstacleeast = true;
    boardpos[7][15].obstacleeast = true;
    boardpos[6][15].obstacleeast = true;
    boardpos[5][15].obstacleeast = true;
    boardpos[4][15].obstacleeast = true;
    boardpos[3][15].obstacleeast = true;
    boardpos[2][15].obstacleeast = true;
    boardpos[1][15].obstacleeast = true;
    boardpos[0][15].obstacleeast = true;
    boardpos[0][15].obstaclenorth = true;
    boardpos[0][14].obstaclenorth = true;
    boardpos[0][13].obstaclenorth = true;
    boardpos[0][12].obstaclenorth = true;
    boardpos[0][11].obstaclenorth = true;
    boardpos[0][10].obstaclenorth = true;
    boardpos[0][9].obstaclenorth = true;
    boardpos[0][8].obstaclenorth = true;
    boardpos[0][7].obstaclenorth = true;
    boardpos[0][6].obstaclenorth = true;
    boardpos[0][5].obstaclenorth = true;
    boardpos[0][4].obstaclenorth = true;
    boardpos[0][3].obstaclenorth = true;
    boardpos[0][2].obstaclenorth = true;
    boardpos[0][1].obstaclenorth = true;
    boardpos[0][0].obstaclenorth = true;

    //Reflectors East
    boardpos[0][3].obstacleeast = true;
    boardpos[0][11].obstacleeast = true;
    boardpos[1][12].obstacleeast = true;
    boardpos[2][5].obstacleeast = true;
    boardpos[2][9].obstacleeast = true;
    boardpos[4][2].obstacleeast = true;
    boardpos[5][6].obstacleeast = true;
    boardpos[5][13].obstacleeast = true;
    boardpos[6][1].obstacleeast = true;
    boardpos[6][11].obstacleeast = true;
    boardpos[9][3].obstacleeast = true;
    boardpos[10][7].obstacleeast = true;
    boardpos[10][12].obstacleeast = true;
    boardpos[11][0].obstacleeast = true;
    boardpos[11][10].obstacleeast = true;
    boardpos[12][6].obstacleeast = true;
    boardpos[12][13].obstacleeast = true;
    boardpos[14][1].obstacleeast = true;
    boardpos[14][9].obstacleeast = true;
    boardpos[15][5].obstacleeast = true;
    boardpos[15][11].obstacleeast = true;

    //Reflectors West
    boardpos[0][4].obstaclewest = true;
    boardpos[0][12].obstaclewest = true;
    boardpos[1][13].obstaclewest = true;
    boardpos[2][6].obstaclewest = true;
    boardpos[2][10].obstaclewest = true;
    boardpos[4][3].obstaclewest = true;
    boardpos[5][7].obstaclewest = true;
    boardpos[5][14].obstaclewest = true;
    boardpos[6][2].obstaclewest = true;
    boardpos[6][12].obstaclewest = true;
    boardpos[9][4].obstaclewest = true;
    boardpos[10][8].obstaclewest = true;
    boardpos[10][13].obstaclewest = true;
    boardpos[11][1].obstaclewest = true;
    boardpos[11][11].obstaclewest = true;
    boardpos[12][7].obstaclewest = true;
    boardpos[12][14].obstaclewest = true;
    boardpos[14][2].obstaclewest = true;
    boardpos[14][10].obstaclewest = true;
    boardpos[15][6].obstaclewest = true;
    boardpos[15][12].obstaclewest = true;

    //Reflectors South
    boardpos[4][0].obstaclesouth = true;
    boardpos[13][0].obstaclesouth = true;
    boardpos[5][1].obstaclesouth = true;
    boardpos[11][1].obstaclesouth = true;
    boardpos[3][2].obstaclesouth = true;
    boardpos[13][2].obstaclesouth = true;
    boardpos[8][3].obstaclesouth = true;
    boardpos[3][5].obstaclesouth = true;
    boardpos[12][6].obstaclesouth = true;
    boardpos[5][7].obstaclesouth = true;
    boardpos[9][8].obstaclesouth = true;
    boardpos[2][9].obstaclesouth = true;
    boardpos[13][9].obstaclesouth = true;
    boardpos[11][10].obstaclesouth = true;
    boardpos[5][11].obstaclesouth = true;
    boardpos[0][13].obstaclesouth = true;
    boardpos[9][13].obstaclesouth = true;
    boardpos[5][14].obstaclesouth = true;
    boardpos[12][14].obstaclesouth = true;
    boardpos[3][15].obstaclesouth = true;
    boardpos[8][15].obstaclesouth = true;

    //Reflectors North
    boardpos[5][0].obstaclenorth = true;
    boardpos[14][0].obstaclenorth = true;
    boardpos[6][1].obstaclenorth = true;
    boardpos[12][1].obstaclenorth = true;
    boardpos[4][2].obstaclenorth = true;
    boardpos[14][2].obstaclenorth = true;
    boardpos[9][3].obstaclenorth = true;
    boardpos[4][5].obstaclenorth = true;
    boardpos[13][6].obstaclenorth = true;
    boardpos[6][7].obstaclenorth = true;
    boardpos[10][8].obstaclenorth = true;
    boardpos[3][9].obstaclenorth = true;
    boardpos[14][9].obstaclenorth = true;
    boardpos[12][10].obstaclenorth = true;
    boardpos[6][11].obstaclenorth = true;
    boardpos[1][13].obstaclenorth = true;
    boardpos[10][13].obstaclenorth = true;
    boardpos[6][14].obstaclenorth = true;
    boardpos[13][14].obstaclenorth = true;
    boardpos[4][15].obstaclenorth = true;
    boardpos[9][15].obstaclenorth = true;
    //board[10][3].red = true;
    // Check bombs around and assign numbers

    boardpos[4][2].collectible = "greencircle";
    boardpos[14][2].collectible = "greentriangle";
    boardpos[11][1].collectible = "redcircle";
    boardpos[2][9].collectible = "bluetriangle";

    //setState(() {});
  }


  Future _reinitialiseGame(int PositionBlueI, int PositionBlueJ, int PositionRedI,int PositionRedJ, int PositionGreenI,int PositionGreenJ, int PositionYellowI,int PositionYellowJ) async {
    CollectionReference game = FirebaseFirestore.instance.collection('Games');


    boardpos[PositionBlueI][PositionBlueJ].blueposition = false;
    boardpos[PositionRedI][PositionRedJ].redposition = false;
    boardpos[PositionGreenI][PositionGreenJ].greenposition = false;
    boardpos[PositionYellowI][PositionYellowJ].yellowposition = false;

    //MIDDLE
    boardpos[6][7].obstaclesouth = true;
    boardpos[6][8].obstaclesouth = true;
    boardpos[7][9].obstaclewest = true;
    boardpos[8][9].obstaclewest = true;
    boardpos[9][7].obstaclenorth = true;
    boardpos[9][8].obstaclenorth = true;
    boardpos[7][6].obstacleeast = true;
    boardpos[8][6].obstacleeast = true;
    //WALL
    boardpos[0][0].obstaclenorth = true;
    boardpos[0][0].obstaclewest = true;
    boardpos[1][0].obstaclewest = true;
    boardpos[1][0].obstaclewest = true;
    boardpos[2][0].obstaclewest = true;
    boardpos[3][0].obstaclewest = true;
    boardpos[4][0].obstaclewest = true;
    boardpos[5][0].obstaclewest = true;
    boardpos[6][0].obstaclewest = true;
    boardpos[7][0].obstaclewest = true;
    boardpos[8][0].obstaclewest = true;
    boardpos[9][0].obstaclewest = true;
    boardpos[10][0].obstaclewest = true;
    boardpos[11][0].obstaclewest = true;
    boardpos[12][0].obstaclewest = true;
    boardpos[13][0].obstaclewest = true;
    boardpos[14][0].obstaclewest = true;
    boardpos[15][0].obstaclewest = true;
    boardpos[15][0].obstaclesouth = true;
    boardpos[15][1].obstaclesouth = true;
    boardpos[15][2].obstaclesouth = true;
    boardpos[15][3].obstaclesouth = true;
    boardpos[15][4].obstaclesouth = true;
    boardpos[15][5].obstaclesouth = true;
    boardpos[15][6].obstaclesouth = true;
    boardpos[15][7].obstaclesouth = true;
    boardpos[15][8].obstaclesouth = true;
    boardpos[15][9].obstaclesouth = true;
    boardpos[15][10].obstaclesouth = true;
    boardpos[15][11].obstaclesouth = true;
    boardpos[15][12].obstaclesouth = true;
    boardpos[15][13].obstaclesouth = true;
    boardpos[15][14].obstaclesouth = true;
    boardpos[15][15].obstaclesouth = true;
    boardpos[15][15].obstacleeast = true;
    boardpos[14][15].obstacleeast = true;
    boardpos[13][15].obstacleeast = true;
    boardpos[12][15].obstacleeast = true;
    boardpos[11][15].obstacleeast = true;
    boardpos[10][15].obstacleeast = true;
    boardpos[9][15].obstacleeast = true;
    boardpos[8][15].obstacleeast = true;
    boardpos[7][15].obstacleeast = true;
    boardpos[6][15].obstacleeast = true;
    boardpos[5][15].obstacleeast = true;
    boardpos[4][15].obstacleeast = true;
    boardpos[3][15].obstacleeast = true;
    boardpos[2][15].obstacleeast = true;
    boardpos[1][15].obstacleeast = true;
    boardpos[0][15].obstacleeast = true;
    boardpos[0][15].obstaclenorth = true;
    boardpos[0][14].obstaclenorth = true;
    boardpos[0][13].obstaclenorth = true;
    boardpos[0][12].obstaclenorth = true;
    boardpos[0][11].obstaclenorth = true;
    boardpos[0][10].obstaclenorth = true;
    boardpos[0][9].obstaclenorth = true;
    boardpos[0][8].obstaclenorth = true;
    boardpos[0][7].obstaclenorth = true;
    boardpos[0][6].obstaclenorth = true;
    boardpos[0][5].obstaclenorth = true;
    boardpos[0][4].obstaclenorth = true;
    boardpos[0][3].obstaclenorth = true;
    boardpos[0][2].obstaclenorth = true;
    boardpos[0][1].obstaclenorth = true;
    boardpos[0][0].obstaclenorth = true;

    //Reflectors East
    boardpos[0][3].obstacleeast = true;
    boardpos[0][11].obstacleeast = true;
    boardpos[1][12].obstacleeast = true;
    boardpos[2][5].obstacleeast = true;
    boardpos[2][9].obstacleeast = true;
    boardpos[4][2].obstacleeast = true;
    boardpos[5][6].obstacleeast = true;
    boardpos[5][13].obstacleeast = true;
    boardpos[6][1].obstacleeast = true;
    boardpos[6][11].obstacleeast = true;
    boardpos[9][3].obstacleeast = true;
    boardpos[10][7].obstacleeast = true;
    boardpos[10][12].obstacleeast = true;
    boardpos[11][0].obstacleeast = true;
    boardpos[11][10].obstacleeast = true;
    boardpos[12][6].obstacleeast = true;
    boardpos[12][13].obstacleeast = true;
    boardpos[14][1].obstacleeast = true;
    boardpos[14][9].obstacleeast = true;
    boardpos[15][5].obstacleeast = true;
    boardpos[15][11].obstacleeast = true;

    //Reflectors West
    boardpos[0][4].obstaclewest = true;
    boardpos[0][12].obstaclewest = true;
    boardpos[1][13].obstaclewest = true;
    boardpos[2][6].obstaclewest = true;
    boardpos[2][10].obstaclewest = true;
    boardpos[4][3].obstaclewest = true;
    boardpos[5][7].obstaclewest = true;
    boardpos[5][14].obstaclewest = true;
    boardpos[6][2].obstaclewest = true;
    boardpos[6][12].obstaclewest = true;
    boardpos[9][4].obstaclewest = true;
    boardpos[10][8].obstaclewest = true;
    boardpos[10][13].obstaclewest = true;
    boardpos[11][1].obstaclewest = true;
    boardpos[11][11].obstaclewest = true;
    boardpos[12][7].obstaclewest = true;
    boardpos[12][14].obstaclewest = true;
    boardpos[14][2].obstaclewest = true;
    boardpos[14][10].obstaclewest = true;
    boardpos[15][6].obstaclewest = true;
    boardpos[15][12].obstaclewest = true;

    //Reflectors South
    boardpos[4][0].obstaclesouth = true;
    boardpos[13][0].obstaclesouth = true;
    boardpos[5][1].obstaclesouth = true;
    boardpos[11][1].obstaclesouth = true;
    boardpos[3][2].obstaclesouth = true;
    boardpos[13][2].obstaclesouth = true;
    boardpos[8][3].obstaclesouth = true;
    boardpos[3][5].obstaclesouth = true;
    boardpos[12][6].obstaclesouth = true;
    boardpos[5][7].obstaclesouth = true;
    boardpos[9][8].obstaclesouth = true;
    boardpos[2][9].obstaclesouth = true;
    boardpos[13][9].obstaclesouth = true;
    boardpos[11][10].obstaclesouth = true;
    boardpos[5][11].obstaclesouth = true;
    boardpos[0][13].obstaclesouth = true;
    boardpos[9][13].obstaclesouth = true;
    boardpos[5][14].obstaclesouth = true;
    boardpos[12][14].obstaclesouth = true;
    boardpos[3][15].obstaclesouth = true;
    boardpos[8][15].obstaclesouth = true;

    //Reflectors North
    boardpos[5][0].obstaclenorth = true;
    boardpos[14][0].obstaclenorth = true;
    boardpos[6][1].obstaclenorth = true;
    boardpos[12][1].obstaclenorth = true;
    boardpos[4][2].obstaclenorth = true;
    boardpos[14][2].obstaclenorth = true;
    boardpos[9][3].obstaclenorth = true;
    boardpos[4][5].obstaclenorth = true;
    boardpos[13][6].obstaclenorth = true;
    boardpos[6][7].obstaclenorth = true;
    boardpos[10][8].obstaclenorth = true;
    boardpos[3][9].obstaclenorth = true;
    boardpos[14][9].obstaclenorth = true;
    boardpos[12][10].obstaclenorth = true;
    boardpos[6][11].obstaclenorth = true;
    boardpos[1][13].obstaclenorth = true;
    boardpos[10][13].obstaclenorth = true;
    boardpos[6][14].obstaclenorth = true;
    boardpos[13][14].obstaclenorth = true;
    boardpos[4][15].obstaclenorth = true;
    boardpos[9][15].obstaclenorth = true;
    //board[10][3].red = true;
    // Check bombs around and assign numbers

    boardpos[4][2].collectible = "greencircle";
    boardpos[14][2].collectible = "greentriangle";
    boardpos[11][1].collectible = "redcircle";
    boardpos[2][9].collectible = "bluetriangle";


    boardpos[redi][redj].redposition = false;      // print(snapshot.connectionState);
    boardpos[bluei][bluej].blueposition = false;      // print(snapshot.connectionState);
    boardpos[greeni][greenj].greenposition = false;      // print(snapshot.connectionState);
    boardpos[yellowi][yellowj].yellowposition = false;      // print(snapshot.connectionState);


    await game.doc("TestGame").update({'redalti': PositionRedI,'redaltj':PositionRedJ});
    await game.doc("TestGame").update({'bluealti': PositionBlueI,'bluealtj':PositionBlueJ});
    await game.doc("TestGame").update({'greenalti': PositionGreenI,'greenaltj':PositionGreenJ});
    await game.doc("TestGame").update({'yellowalti': PositionYellowI,'yellowaltj':PositionYellowJ});

    await game.doc("TestGame").update({'movecount': 0});
    await game.doc("TestGame").update({'bluei': 4,'bluej':4});
    await game.doc("TestGame").update({'redi': 3,'redj':3});
    await game.doc("TestGame").update({'greeni': 8,'greenj':2});
    await game.doc("TestGame").update({'yellowi': 13,'yellowj':13});


    // setState(() {});
  }
  // This function opens other squares around the target square which don't have any bombs around them.
  // We use a recursive function which stops at squares which have a non zero number of bombs around them.

  Future _handleMoveRedAlt(int i, int j, int t) async {
    CollectionReference game = FirebaseFirestore.instance.collection('Games');

    boardpos[i][j].redposition = false;
    int ialt=i;
    int jalt=j;
    while(1==1) {
      if (boardpos[i][j].obstaclenorth && t==1) {break;}
      if (boardpos[i][j].obstacleeast && t==2) {break;}
      if (boardpos[i][j].obstaclesouth && t==3) {break;}
      if (boardpos[i][j].obstaclewest && t==4) {break;}
      if (i>0 && boardpos[i-1][j].blueposition && t==1) {break;}
      if (i<15 && boardpos[i+1][j].blueposition && t==3) {break;}
      if (j>0 && boardpos[i][j-1].blueposition && t==4) {break;}
      if (j<15 && boardpos[i][j+1].blueposition && t==2) {break;}
      if (i>0 && boardpos[i-1][j].greenposition && t==1) {break;}
      if (i<15 && boardpos[i+1][j].greenposition && t==3) {break;}
      if (j>0 && boardpos[i][j-1].greenposition && t==4) {break;}
      if (j<15 && boardpos[i][j+1].greenposition && t==2) {break;}
      if (i>0 && boardpos[i-1][j].yellowposition && t==1) {break;}
      if (i<15 && boardpos[i+1][j].yellowposition && t==3) {break;}
      if (j>0 && boardpos[i][j-1].yellowposition && t==4) {break;}
      if (j<15 && boardpos[i][j+1].yellowposition && t==2) {break;}
      if (t==1) {i--;}
      if (t==3) {i++;}
      if (t==4) {j--;}
      if (t==2) {j++;}
    }
    boardpos[i][j].redposition = true;
    redi=i;
    redj=j;
    await game.doc("TestGame").update({'redi': i,'redj':j,'redalti': ialt,'redaltj':jalt});
    await game.doc("TestGame").update({'movecount': FieldValue.increment(1) });
    //setState(() {});
  }

  Future _handleMoveBlueAlt(int i, int j, int t) async {
    CollectionReference game = FirebaseFirestore.instance.collection('Games');

    boardpos[i][j].blueposition = false;
    int ialt=i;
    int jalt=j;
    while(1==1) {
      if (boardpos[i][j].obstaclenorth && t==1) {break;}
      if (boardpos[i][j].obstacleeast && t==2) {break;}
      if (boardpos[i][j].obstaclesouth && t==3) {break;}
      if (boardpos[i][j].obstaclewest && t==4) {break;}
      if (i>0 && boardpos[i-1][j].redposition && t==1) {break;}
      if (i<15 && boardpos[i+1][j].redposition && t==3) {break;}
      if (j>0 && boardpos[i][j-1].redposition && t==4) {break;}
      if (j<15 && boardpos[i][j+1].redposition && t==2) {break;}
      if (i>0 && boardpos[i-1][j].greenposition && t==1) {break;}
      if (i<15 && boardpos[i+1][j].greenposition && t==3) {break;}
      if (j>0 && boardpos[i][j-1].greenposition && t==4) {break;}
      if (j<15 && boardpos[i][j+1].greenposition && t==2) {break;}
      if (i>0 && boardpos[i-1][j].yellowposition && t==1) {break;}
      if (i<15 && boardpos[i+1][j].yellowposition && t==3) {break;}
      if (j>0 && boardpos[i][j-1].yellowposition && t==4) {break;}
      if (j<15 && boardpos[i][j+1].yellowposition && t==2) {break;}
      if (t==1) {i--;}
      if (t==3) {i++;}
      if (t==4) {j--;}
      if (t==2) {j++;}
    }
    boardpos[i][j].blueposition = true;
    bluei=i;
    bluej=j;

    await game.doc("TestGame").update({'bluei': i,'bluej':j,'bluealti': ialt,'bluealtj':jalt});
    await game.doc("TestGame").update({'movecount': FieldValue.increment(1) });
    // setState(() {});
  }

  Future _handleMoveGreenAlt(int i, int j, int t) async {

    CollectionReference game = FirebaseFirestore.instance.collection('Games');

    boardpos[i][j].greenposition = false;
    int ialt=i;
    int jalt=j;
    while(1==1) {
      if (boardpos[i][j].obstaclenorth && t==1) {break;}
      if (boardpos[i][j].obstacleeast && t==2) {break;}
      if (boardpos[i][j].obstaclesouth && t==3) {break;}
      if (boardpos[i][j].obstaclewest && t==4) {break;}
      if (i>0 && boardpos[i-1][j].redposition && t==1) {break;}
      if (i<15 && boardpos[i+1][j].redposition && t==3) {break;}
      if (j>0 && boardpos[i][j-1].redposition && t==4) {break;}
      if (j<15 && boardpos[i][j+1].redposition && t==2) {break;}
      if (i>0 && boardpos[i-1][j].blueposition && t==1) {break;}
      if (i<15 && boardpos[i+1][j].blueposition && t==3) {break;}
      if (j>0 && boardpos[i][j-1].blueposition && t==4) {break;}
      if (j<15 && boardpos[i][j+1].blueposition && t==2) {break;}
      if (i>0 && boardpos[i-1][j].yellowposition && t==1) {break;}
      if (i<15 && boardpos[i+1][j].yellowposition && t==3) {break;}
      if (j>0 && boardpos[i][j-1].yellowposition && t==4) {break;}
      if (j<15 && boardpos[i][j+1].yellowposition && t==2) {break;}
      if (t==1) {i--;}
      if (t==3) {i++;}
      if (t==4) {j--;}
      if (t==2) {j++;}
    }
    boardpos[i][j].greenposition = true;
    greeni=i;
    greenj=j;

    await game.doc("TestGame").update({'greeni': i,'greenj':j,'greenalti': ialt,'greenaltj':jalt});
    await game.doc("TestGame").update({'movecount': FieldValue.increment(1) });
    //setState(() {});
  }

  Future _handleMoveYellowAlt(int i, int j, int t) async {

    CollectionReference game = FirebaseFirestore.instance.collection('Games');

    boardpos[i][j].yellowposition = false;
    int ialt=i;
    int jalt=j;
    while(1==1) {
      if (boardpos[i][j].obstaclenorth && t==1) {break;}
      if (boardpos[i][j].obstacleeast && t==2) {break;}
      if (boardpos[i][j].obstaclesouth && t==3) {break;}
      if (boardpos[i][j].obstaclewest && t==4) {break;}
      if (i>0 && boardpos[i-1][j].redposition && t==1) {break;}
      if (i<15 && boardpos[i+1][j].redposition && t==3) {break;}
      if (j>0 && boardpos[i][j-1].redposition && t==4) {break;}
      if (j<15 && boardpos[i][j+1].redposition && t==2) {break;}
      if (i>0 && boardpos[i-1][j].blueposition && t==1) {break;}
      if (i<15 && boardpos[i+1][j].blueposition && t==3) {break;}
      if (j>0 && boardpos[i][j-1].blueposition && t==4) {break;}
      if (j<15 && boardpos[i][j+1].blueposition && t==2) {break;}
      if (i>0 && boardpos[i-1][j].greenposition && t==1) {break;}
      if (i<15 && boardpos[i+1][j].greenposition && t==3) {break;}
      if (j>0 && boardpos[i][j-1].greenposition && t==4) {break;}
      if (j<15 && boardpos[i][j+1].greenposition && t==2) {break;}
      if (t==1) {i--;}
      if (t==3) {i++;}
      if (t==4) {j--;}
      if (t==2) {j++;}
    }
    boardpos[i][j].yellowposition = true;
    yellowi=i;
    yellowj=j;

    await game.doc("TestGame").update({'yellowi': i,'yellowj':j,'yellowalti': ialt,'yellowaltj':jalt});
    await game.doc("TestGame").update({'movecount': FieldValue.increment(1) });
    //setState(() {});
  }

  Image getImage(ImageType type) {
    switch (type) {
      case ImageType.zero:
        return Image.asset('images/0.png');
      case ImageType.one:
        return Image.asset('images/1.png');
      case ImageType.two:
        return Image.asset('images/2.png');
      case ImageType.three:
        return Image.asset('images/3.png');
      case ImageType.four:
        return Image.asset('images/4.png');
      case ImageType.five:
        return Image.asset('images/5.png');
      case ImageType.six:
        return Image.asset('images/6.png');
      case ImageType.seven:
        return Image.asset('images/7.png');
      case ImageType.eight:
        return Image.asset('images/8.png');
      case ImageType.bomb:
        return Image.asset('images/bomb.png');
      case ImageType.facingDown:
        return Image.asset('assets/images/facingDown.png');
      case ImageType.flagged:
        return Image.asset('assets/images/flagged.png');
      case ImageType.bombnw:
        return Image.asset('assets/images/bombNorthWest.png');
      case ImageType.bombne:
        return Image.asset('assets/images/bombNorthEast.png');
      case ImageType.bombsw:
        return Image.asset('assets/images/bombSouthWest.png');
      case ImageType.bombse:
        return Image.asset('assets/images/bombSouthEast.png');
      case ImageType.bluecrossne:
        return Image.asset('assets/images/BlueCrossNorthEast.png');
      case ImageType.bluecrossnw:
        return Image.asset('assets/images/BlueCrossNorthWest.png');
      case ImageType.bluecrossse:
        return Image.asset('assets/images/BlueCrossSouthEast.png');
      case ImageType.bluecrosssw:
        return Image.asset('assets/images/BlueCrossSouthWest.png');
      case ImageType.bluetrianglene:
        return Image.asset('assets/images/BlueTriangleNorthEast.png');
      case ImageType.bluetrianglenw:
        return Image.asset('assets/images/BlueTriangleNorthWest.png');
      case ImageType.bluetrianglese:
        return Image.asset('assets/images/BlueTriangleSouthEast.png');
      case ImageType.bluetrianglesw:
        return Image.asset('assets/images/BlueTriangleSouthWest.png');
      case ImageType.bluesaturnne:
        return Image.asset('assets/images/BlueSaturnNorthEast.png');
      case ImageType.bluesaturnnw:
        return Image.asset('assets/images/BlueSaturnNorthWest.png');
      case ImageType.bluesaturnse:
        return Image.asset('assets/images/BlueSaturnSouthEast.png');
      case ImageType.bluesaturnsw:
        return Image.asset('assets/images/BlueSaturnSouthWest.png');
      case ImageType.bluecirclene:
        return Image.asset('assets/images/BlueCircleNorthEast.png');
      case ImageType.bluecirclenw:
        return Image.asset('assets/images/BlueCircleNorthWest.png');
      case ImageType.bluecirclese:
        return Image.asset('assets/images/BlueCircleSouthEast.png');
      case ImageType.bluecirclesw:
        return Image.asset('assets/images/BlueCircleSouthWest.png');
      case ImageType.redcrossne:
        return Image.asset('assets/images/RedCrossNorthEast.png');
      case ImageType.redcrossnw:
        return Image.asset('assets/images/RedCrossNorthWest.png');
      case ImageType.redcrossse:
        return Image.asset('assets/images/RedCrossSouthEast.png');
      case ImageType.redcrosssw:
        return Image.asset('assets/images/RedCrossSouthWest.png');
      case ImageType.redtrianglene:
        return Image.asset('assets/images/RedTriangleNorthEast.png');
      case ImageType.redtrianglenw:
        return Image.asset('assets/images/RedTriangleNorthWest.png');
      case ImageType.redtrianglese:
        return Image.asset('assets/images/RedTriangleSouthEast.png');
      case ImageType.redtrianglesw:
        return Image.asset('assets/images/RedTriangleSouthWest.png');
      case ImageType.redsaturnne:
        return Image.asset('assets/images/RedSaturnNorthEast.png');
      case ImageType.redsaturnnw:
        return Image.asset('assets/images/RedSaturnNorthWest.png');
      case ImageType.redsaturnse:
        return Image.asset('assets/images/RedSaturnSouthEast.png');
      case ImageType.redsaturnsw:
        return Image.asset('assets/images/RedSaturnSouthWest.png');
      case ImageType.redcirclene:
        return Image.asset('assets/images/RedCircleNorthEast.png');
      case ImageType.redcirclenw:
        return Image.asset('assets/images/RedCircleNorthWest.png');
      case ImageType.redcirclese:
        return Image.asset('assets/images/RedCircleSouthEast.png');
      case ImageType.redcirclesw:
        return Image.asset('assets/images/RedCircleSouthWest.png');
      case ImageType.greencrossne:
        return Image.asset('assets/images/GreenCrossNorthEast.png');
      case ImageType.greencrossnw:
        return Image.asset('assets/images/GreenCrossNorthWest.png');
      case ImageType.greencrossse:
        return Image.asset('assets/images/GreenCrossSouthEast.png');
      case ImageType.greencrosssw:
        return Image.asset('assets/images/GreenCrossSouthWest.png');
      case ImageType.greentrianglene:
        return Image.asset('assets/images/GreenTriangleNorthEast.png');
      case ImageType.greentrianglenw:
        return Image.asset('assets/images/GreenTriangleNorthWest.png');
      case ImageType.greentrianglese:
        return Image.asset('assets/images/GreenTriangleSouthEast.png');
      case ImageType.greentrianglesw:
        return Image.asset('assets/images/GreenTriangleSouthWest.png');
      case ImageType.greensaturnne:
        return Image.asset('assets/images/GreenSaturnNorthEast.png');
      case ImageType.greensaturnnw:
        return Image.asset('assets/images/GreenSaturnNorthWest.png');
      case ImageType.greensaturnse:
        return Image.asset('assets/images/GreenSaturnSouthEast.png');
      case ImageType.greensaturnsw:
        return Image.asset('assets/images/GreenSaturnSouthWest.png');
      case ImageType.greencirclene:
        return Image.asset('assets/images/GreenCircleNorthEast.png');
      case ImageType.greencirclenw:
        return Image.asset('assets/images/GreenCircleNorthWest.png');
      case ImageType.greencirclese:
        return Image.asset('assets/images/GreenCircleSouthEast.png');
      case ImageType.greencirclesw:
        return Image.asset('assets/images/GreenCircleSouthWest.png');
      case ImageType.yellowcrossne:
        return Image.asset('assets/images/YellowCrossNorthEast.png');
      case ImageType.yellowcrossnw:
        return Image.asset('assets/images/YellowCrossNorthWest.png');
      case ImageType.yellowcrossse:
        return Image.asset('assets/images/YellowCrossSouthEast.png');
      case ImageType.yellowcrosssw:
        return Image.asset('assets/images/YellowCrossSouthWest.png');
      case ImageType.yellowtrianglene:
        return Image.asset('assets/images/YellowTriangleNorthEast.png');
      case ImageType.yellowtrianglenw:
        return Image.asset('assets/images/YellowTriangleNorthWest.png');
      case ImageType.yellowtrianglese:
        return Image.asset('assets/images/YellowTriangleSouthEast.png');
      case ImageType.yellowtrianglesw:
        return Image.asset('assets/images/YellowTriangleSouthWest.png');
      case ImageType.yellowsaturnne:
        return Image.asset('assets/images/YellowSaturnNorthEast.png');
      case ImageType.yellowsaturnnw:
        return Image.asset('assets/images/YellowSaturnNorthWest.png');
      case ImageType.yellowsaturnse:
        return Image.asset('assets/images/YellowSaturnSouthEast.png');
      case ImageType.yellowsaturnsw:
        return Image.asset('assets/images/YellowSaturnSouthWest.png');
      case ImageType.yellowcirclene:
        return Image.asset('assets/images/YellowCircleNorthEast.png');
      case ImageType.yellowcirclenw:
        return Image.asset('assets/images/YellowCircleNorthWest.png');
      case ImageType.yellowcirclese:
        return Image.asset('assets/images/YellowCircleSouthEast.png');
      case ImageType.yellowcirclesw:
        return Image.asset('assets/images/YellowCircleSouthWest.png');
      case ImageType.rainbowne:
        return Image.asset('assets/images/RainbowNorthEast.png');
      case ImageType.rainbownw:
        return Image.asset('assets/images/RainbowNorthWest.png');
      case ImageType.rainbowse:
        return Image.asset('assets/images/RainbowSouthEast.png');
      case ImageType.rainbowsw:
        return Image.asset('assets/images/RainbowSouthWest.png');
      case ImageType.walle:
        return Image.asset('assets/images/WallEast.png');
      case ImageType.wallw:
        return Image.asset('assets/images/WallWest.png');
      case ImageType.walln:
        return Image.asset('assets/images/WallNorth.png');
      case ImageType.walls:
        return Image.asset('assets/images/WallSouth.png');
      case ImageType.redplayer:
        return Image.asset('assets/images/redplayer.png');
      case ImageType.bluepleyer:
        return Image.asset('assets/images/blueplayer.png');
      case ImageType.greenplayer:
        return Image.asset('assets/images/greenplayer.png');
      case ImageType.yellowpleyer:
        return Image.asset('assets/images/yellowplayer.png');
      case ImageType.flagged:
        return Image.asset('assets/images/flagged.png');
      default:
        return Image.asset('assets/images/flagged.png');
    }
  }

  ImageType getImageTypeFromNumber(int number) {
    switch (number) {
      case 0:
        return ImageType.zero;
      case 1:
        return ImageType.one;
      case 2:
        return ImageType.two;
      case 3:
        return ImageType.three;
      case 4:
        return ImageType.four;
      case 5:
        return ImageType.five;
      case 6:
        return ImageType.six;
      case 7:
        return ImageType.seven;
      case 8:
        return ImageType.eight;
      default:
        return ImageType.eight;
    }
  }

  Future _submitBet(String game, String? uid, int bet) async {
    CollectionReference betupdate = FirebaseFirestore.instance.collection('Games/'+ game +'/Players');
    CollectionReference gameupdate = FirebaseFirestore.instance.collection('Games/');

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Games/'+ game +'/Players').orderBy('bet', descending: false).limit(1).get();
    var list = querySnapshot.docs;
    List<int> bets = [];
    list.forEach((f) => bets.add(f.data()['bet']));

    int lowestbid = 99;
    var collection = FirebaseFirestore.instance.collection('Games');
    var docSnapshot = await collection.doc('TestGame').get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      int value = data?['lowestbid'];
      lowestbid=value;// <-- The value you want to retrieve.
    }

    print(bets);
    if(bets.first == 99) {
      await gameupdate.doc(game).update({'lowestbidder': uid.toString()});
      await gameupdate.doc(game).update({'lowestbid': bet});
      await gameupdate.doc(game).update({'firstbet': DateTime.now()});
      await betupdate.doc(uid).set({'bet': bet, 'timestampupdated': DateTime.now()});
      startTimer();
      print(bets);
    }
    if(bet < lowestbid){
      await gameupdate.doc(game).update({'lowestbidder': uid.toString()});
      await gameupdate.doc(game).update({'lowestbid': bet});
      await betupdate.doc(uid).set({'bet': bet, 'timestampupdated': DateTime.now()});
    }


    //await betupdate.doc(uid).update({'bet': bet});

  }

  showAlertDialogWIN(BuildContext context, int Round, String uid) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("NEXT ROUND"),
      onPressed: () {
        //Future.delayed(Duration(hours: 0, minutes: 0, seconds: 2),() {
        _nextRound("TestGame",Round);
        Navigator.pop(context);

        //});
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("CONGRATULATIONS"),
      content: Text("The WINNER IS  " + uid),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    Future.delayed(Duration.zero,()
    {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
    );
  }

  showAlertDialogNEXTPLAYER(BuildContext context, String uid, int PositionBlueI, int PositionBlueJ, int PositionRedI, int PositionRedJ, int PositionGreenI, int PositionGreenJ, int PositionYellowI, int PositionYellowJ) {
    _nextBestBet(uid,PositionBlueI, PositionBlueJ, PositionRedI, PositionRedJ, PositionGreenI, PositionGreenJ, PositionYellowI, PositionYellowJ);

    // set up the button
    Widget okButton = TextButton(
      child: Text("NEXT PLAYER"),
      onPressed: () {
        //Future.delayed(Duration(hours: 0, minutes: 0, seconds: 2),() {
        Navigator.pop(context);

        //});
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("YOU FAILED"),
      content: Text("Bad luck"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    Future.delayed(Duration.zero,()
    {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
    );
  }

  Future _nextRound(String game, int Round) async {
    CollectionReference gameupdate = FirebaseFirestore.instance.collection('Games/');
    CollectionReference roundupdate = FirebaseFirestore.instance.collection('Games/TestGame/Rounds');

    await gameupdate.doc(game).update({'Round': Round+1});
    await roundupdate.doc((Round+1).toString())
        .set({
      'Start': DateTime.now().add(const Duration(minutes: 5))
    });
  }

  Future _nextBestBet(String uid,int PositionBlueI, int PositionBlueJ, int PositionRedI, int PositionRedJ, int PositionGreenI, int PositionGreenJ, int PositionYellowI, int PositionYellowJ) async {
    _reinitialiseGame(PositionBlueI, PositionBlueJ, PositionRedI, PositionRedJ, PositionGreenI, PositionGreenJ, PositionYellowI, PositionYellowJ);
    CollectionReference playerupdate = FirebaseFirestore.instance.collection('Games/TestGame/Players');
    CollectionReference gameupdate = FirebaseFirestore.instance.collection('Games/');

    playerupdate.doc(uid).update({'bet': 99});

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Games/TestGame/Players').orderBy('bet', descending: false).limit(1).get();
    var list = querySnapshot.docs;
    List<String> player = [];
    list.forEach((f) => player.add(f.data()['id']));
    print( "Debug1" + player.first);

    await gameupdate.doc("TestGame").update({'lowestbidder': player.first});

  }


  Future _resetGame(String game) async {
    CollectionReference gameupdate = FirebaseFirestore.instance.collection('Games/');
    CollectionReference playerupdate = FirebaseFirestore.instance.collection('Games/TestGame/Players');
    await gameupdate.doc(game).update({'lowestbidder': ""});
    await gameupdate.doc(game).update({'lowestbid': 99});
    await gameupdate.doc(game).update({'firstbet': DateTime.now()});
    await gameupdate.doc(game).update({'movecount': 0});
    await gameupdate.doc(game).update({'Round': 1});
    await gameupdate.doc(game).update({'Timer': 5});


    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Games/'+ game +'/Players').get();
    var list = querySnapshot.docs;
    list.forEach((element) { playerupdate.doc(element.id).update({'bet': 99}); });


  }

}