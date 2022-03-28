import 'dart:math';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ricochetrobots/main.dart';
import 'board_square.dart';
//import 'helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:numberpicker/numberpicker.dart';
import 'games_list.dart';

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
  int _start = 10;

  Future startTimer(gamename) async {
    CollectionReference gameupdate = FirebaseFirestore.instance.collection('Games/');
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          //setState(() {
          gameupdate.doc(gamename).update({'Timer': _start });
          timer.cancel();
          //  });
        } else {
          // setState(() {
          gameupdate.doc(gamename).update({'Timer': _start });
          _start--;
          //  });
        }
      },
    );
  }

  Future stopTimer() async {
    _timer.cancel();
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

  String msg="";
  late FocusNode myFocusNode;

  ValueNotifier<int> _counter = ValueNotifier<int>(10);

  final bet = TextEditingController();
  int counter = 5;

  //int movecount=0;
  // The grid of squares
  List<List<BoardPosition>> boardpos = List.generate(16, (i) {
    return List.generate(16, (j) {
      return BoardPosition();
    });
  });


  void initState() {
  // //super.initState();
    _initialiseGame();
  }

  @override
  Widget build(BuildContext context) {

    final Arguments args = ModalRoute.of(context)?.settings.arguments as Arguments;

    return Scaffold( backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: Colors.black,
        //title: new Text("Comic Reader Multi Language"),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('TURDLE'),
          ],
         // children: [
            //Image.asset(
             // 'assets/images/BlueCrossNorthEast.png',
         //     fit: BoxFit.contain,
           //   height: 55,
         //   ),
         // ],

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
      StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Games').doc(args.gamename).snapshots(), //counterStream,
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            //if(snapshot.hasData) {
            if (snapshot.hasData) {
              print(args.gamename);

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
              String hostplayer = snapshot.data?.data()!["Host"];

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

              bool isEnabled = false;
              if(RunningTimer>0){isEnabled=true;}else{isEnabled=false;}
              print(isEnabled);

              return (

                  ListView(
                    children: <Widget>[


                      ConstrainedBox(
                        //color: Colors.grey,
                        //height: 60.0,
                        constraints:BoxConstraints(maxWidth: 1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveRedAlt(args.gamename,PositionRedI,PositionRedJ,1); };
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
                                if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveRedAlt(args.gamename,PositionRedI,PositionRedJ,2);};
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
                                if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveRedAlt(args.gamename,PositionRedI,PositionRedJ,3);};
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
                                if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveRedAlt(args.gamename,PositionRedI,PositionRedJ,4);};
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
                                if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveBlueAlt(args.gamename,PositionBlueI,PositionBlueJ,1);};
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
                                if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveBlueAlt(args.gamename,PositionBlueI,PositionBlueJ,2);};
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
                                if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveBlueAlt(args.gamename,PositionBlueI,PositionBlueJ,3);};
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
                                if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveBlueAlt(args.gamename,PositionBlueI,PositionBlueJ,4);};
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

                          ],
                        ),
                      ),
                      ConstrainedBox(
                        //color: Colors.grey,
                        //height: 60.0,
                        constraints:BoxConstraints(maxWidth: 1),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                //if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveGreenAlt(PositionGreenI,PositionGreenJ,1);};
                                _handleMoveGreenAlt(args.gamename,PositionGreenI,PositionGreenJ,1);
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
                                if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveGreenAlt(args.gamename,PositionGreenI,PositionGreenJ,2);};
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
                                if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveGreenAlt(args.gamename,PositionGreenI,PositionGreenJ,3);};
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
                                if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveGreenAlt(args.gamename,PositionGreenI,PositionGreenJ,4);};
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
                                if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveYellowAlt(args.gamename,PositionYellowI,PositionYellowJ,1);};
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
                                if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveYellowAlt(args.gamename,PositionYellowI,PositionYellowJ,2);};
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
                                if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveYellowAlt(args.gamename,PositionYellowI,PositionYellowJ,3);};
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
                                if(RunningTimer==0 && _auth.currentUser?.email==lowestbidder) {_handleMoveYellowAlt(args.gamename,PositionYellowI,PositionYellowJ,4);};
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
                          ],
                        ),

                      ),
                      ConstrainedBox(
                        //color: Colors.grey,
                        //height: 60.0,
                        constraints:BoxConstraints(maxWidth: 1),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(children: <Widget>[IconButton(
                              icon: const Icon(Icons.launch),
                              tooltip: 'Initialise Board',
                              onPressed: () {
                                _initialiseGame();
                              },
                            ),
                              Text('START')]),Column(children: <Widget>[IconButton(
                              icon: const Icon(Icons.replay),
                              tooltip: 'Reset',
                              onPressed: () {
                                if(_auth.currentUser?.email==hostplayer) {_resetGame(args.gamename,PositionBlueI,PositionBlueJ,PositionRedI,PositionRedJ,PositionGreenI,PositionGreenJ,PositionYellowI,PositionYellowJ);}
                              },
                            ),
                              Text('Reset')]),
                            Column(children: <Widget>[IconButton(
                              icon: const Icon(Icons.arrow_forward),
                              tooltip: 'Next Round',
                              onPressed: () {
                                if(_auth.currentUser?.email==hostplayer) {_nextRound(args.gamename,GameRound,lowestbidder,PositionBlueI,PositionBlueJ, PositionRedI, PositionRedJ, PositionGreenI, PositionGreenJ, PositionYellowI, PositionYellowJ);}
                              },
                            ),
                              Text('NextRound')]),
                            Column(children: <Widget>[IconButton(
                              icon: const Icon(Icons.accessibility),
                              tooltip: 'Next bid',
                              onPressed: () {
                                if(_auth.currentUser?.email==hostplayer) {_nextBestBet(args.gamename,lowestbidder,PositionBlueI, PositionBlueJ, PositionRedI, PositionRedJ, PositionGreenI, PositionGreenJ, PositionYellowI, PositionYellowJ);};
                              },
                            ),
                              Text('NextBid')]),

                          ],
                        ),

                      ),
                        ConstrainedBox(
                        //color: Colors.grey,
                        //height: 60.0,
                        constraints:BoxConstraints(maxWidth: 5),

                        child:Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("ROUND: " +GameRound.toString() + " ",style: TextStyle(fontSize: 24.0,fontWeight:FontWeight.bold)),

                            IconButton(
                              icon: Icon(
                                Icons.remove,
                                color: Theme.of(context).accentColor,
                              ),
                              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
                              iconSize: 32.0,
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                _counter.value--;
                                print(_counter.value);
                              },
                            ),

                              ValueListenableBuilder(
                              valueListenable: _counter ,
                              builder: (context, value, child) => Text(
                              '$value',style: TextStyle(fontSize: 24.0,fontWeight:FontWeight.bold, color: Colors.red)
                              ),
                              ),

                            IconButton(
                              icon: Icon(
                                Icons.add,
                                color: Theme.of(context).accentColor,
                              ),
                              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
                              iconSize: 32.0,
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                _counter.value++;
                              },
                            ),

                            ElevatedButton(

                              child: Text('SUBMIT BID'),
                              onPressed: isEnabled?() {
                                _submitBet(args.gamename,_auth.currentUser?.email,_counter.value, GameRound, RunningTimer);
                                //bet.clear();
                                myFocusNode.unfocus();
                              }:null,

                            ),



                          ],
                        ),

                      ),

                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('Games/'+args.gamename+'/Collectibles').where("Round",isEqualTo: GameRound).snapshots(), //.doc(_auth.currentUser.email).get(),
                          builder: (context, AsyncSnapshot<QuerySnapshot> collectibles ) {
                            if (collectibles.hasData) {
                              List<String> target = [];
                              //List<String> bets = [];
                              //List<List<Players>> players;
                              //List<Map<String, dynamic>> send=[] ;
                              //snapshot1.data?.docs.forEach((f) => print(f.id));
                              collectibles.data?.docs.forEach((f) => target.add(f.id.toString()));
                              //collectibles.data?.docs.forEach((f) => players.add(f.id.toString()));
                              print(target[0]);
                              //WIN CONDITION!!!!
                              if(RunningTimer==0) {
                                msg=" The lowest bidder is $lowestbidder.\n Show us the shortest path in $lowestbid moves";
                                print("Lowest $RunningTimer");
                              } else if(GameRound==1) {msg=" Let the game begin.\n Please provide your lowest bid";}
                              else if(GameRound>1) {msg=" Let the next round begin.\n Please provide your lowest bid";}

                              if(boardpos[PositionGreenI][PositionGreenJ].collectible==target[0].toString() && target[0].toString().substring(0,5)=="green" && movecount<=lowestbid && lowestbid!=99)
                              {
                                print(boardpos[PositionGreenI][PositionGreenJ].collectible);
                                print(target[0].toString().substring(0,5));
                                msg="$lowestbidder has won!!!";
                                _setwinner(args.gamename, 1,lowestbidder);
                                // _nextRound("TestGame",GameRound,lowestbidder);
                                //showAlertDialogWIN(context,GameRound,lowestbidder);
                              } else if(movecount>lowestbid) {
                                //showAlertDialogNEXTPLAYER(context,lowestbidder, PositionBlueI, PositionBlueJ, PositionRedI, PositionRedJ, PositionGreenI, PositionGreenJ, PositionYellowI, PositionYellowJ);
                                msg=" $lowestbidder has failed miserable.\n Please proceed to the next best bidding player.";
                                //sleep(Duration(seconds:2));
                                //if(_auth.currentUser?.email==hostplayer) {_nextBestBet(lowestbidder,PositionBlueI, PositionBlueJ, PositionRedI, PositionRedJ, PositionGreenI, PositionGreenJ, PositionYellowI, PositionYellowJ);}
                              }
                              if(boardpos[PositionRedI][PositionRedJ].collectible==target[0].toString() && target[0].toString().substring(0,3)=="red" && movecount<=lowestbid && lowestbid!=99)
                              {
                                print(boardpos[PositionRedI][PositionRedJ].collectible);
                                print(target[0].toString().substring(0,3));
                                msg="$lowestbidder has won!!!";
                                _setwinner(args.gamename, 1,lowestbidder);
                                //showAlertDialogWIN(context,GameRound,lowestbidder);
                              } else if(boardpos[PositionRedI][PositionRedJ].collectible==target[0].toString() && target[0].toString().substring(0,5)=="red" && movecount>lowestbid) {
                                //showAlertDialogNEXTPLAYER(context,lowestbidder, PositionBlueI, PositionBlueJ, PositionRedI, PositionRedJ, PositionGreenI, PositionGreenJ, PositionYellowI, PositionYellowJ);
                                msg=" $lowestbidder has failed miserable.\n Please proceed to the next best bidding player.";
                                //sleep(Duration(seconds:2));
                                //if(_auth.currentUser?.email==hostplayer) {_nextBestBet(lowestbidder,PositionBlueI, PositionBlueJ, PositionRedI, PositionRedJ, PositionGreenI, PositionGreenJ, PositionYellowI, PositionYellowJ);}
                              }
                              if(boardpos[PositionBlueI][PositionBlueJ].collectible==target[0].toString() && target[0].toString().substring(0,4)=="blue" && movecount<=lowestbid && lowestbid!=99)
                              {
                                print(boardpos[PositionBlueI][PositionBlueJ].collectible);
                                print(target[0].toString().substring(0,4));
                                msg="CONGRATULATIONS!!! $lowestbidder has won!!!";
                                _setwinner(args.gamename, 1,lowestbidder);
                                //showAlertDialogWIN(context,GameRound,lowestbidder);
                              } else if(boardpos[PositionBlueI][PositionBlueJ].collectible==target[0].toString() && target[0].toString().substring(0,5)=="blue" && movecount>lowestbid) {
                                //showAlertDialogNEXTPLAYER(context,lowestbidder, PositionBlueI, PositionBlueJ, PositionRedI, PositionRedJ, PositionGreenI, PositionGreenJ, PositionYellowI, PositionYellowJ);
                                msg=" $lowestbidder has failed miserable.\n Please proceed to the next best bidding player.";
                                //sleep(Duration(seconds:2));
                                //if(_auth.currentUser?.email==hostplayer) {_nextBestBet(lowestbidder,PositionBlueI, PositionBlueJ, PositionRedI, PositionRedJ, PositionGreenI, PositionGreenJ, PositionYellowI, PositionYellowJ);}
                              }
                              if(boardpos[PositionYellowI][PositionYellowJ].collectible==target[0].toString() && target[0].toString().substring(0,6)=="yellow" && movecount<=lowestbid && lowestbid!=99)
                              {
                                print(boardpos[PositionYellowI][PositionYellowJ].collectible);
                                print(target[0].toString().substring(0,6));
                                msg="$lowestbidder has won!!!";
                                _setwinner(args.gamename, 1,lowestbidder);
                                //showAlertDialogWIN(context,GameRound,lowestbidder);
                              } else if(boardpos[PositionYellowI][PositionYellowJ].collectible==target[0].toString() && target[0].toString().substring(0,5)=="yellow" && movecount>lowestbid) {
                                //showAlertDialogNEXTPLAYER(context,lowestbidder, PositionBlueI, PositionBlueJ, PositionRedI, PositionRedJ, PositionGreenI, PositionGreenJ, PositionYellowI, PositionYellowJ);
                                msg=" $lowestbidder has failed miserable.\n Please proceed to the next best bidding player.";
                                //sleep(Duration(seconds:2));
                                //if(_auth.currentUser?.email==hostplayer) {_nextBestBet(lowestbidder,PositionBlueI, PositionBlueJ, PositionRedI, PositionRedJ, PositionGreenI, PositionGreenJ, PositionYellowI, PositionYellowJ);}
                              }

                              print("Debug");
                              //print(players.length);
                              //print(GameRound);
                              return (
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:<Widget>[
                                      Row(mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[ Container(child:Text("  CLOCK: " +RunningTimer.toString() + "  ",style: TextStyle(fontSize: 24.0,fontWeight:FontWeight.bold))),//Container(child:Text(target[0].toString().toUpperCase(),style: TextStyle(fontSize: 24.0,fontWeight:FontWeight.bold)),), //image = getImage(ImageType.bluecirclene);
                                          Text("TARGET: ", style: TextStyle(fontSize: 14.0,fontWeight:FontWeight.bold, color: Colors.red)),
                                          Container(
                                              color: Colors.grey,
                                              child: Stack(children: <Widget>[//getImage(ImageType.bluecirclene),
                                                Image.asset('assets/images/'+target[0].toString()+'SouthWest.png',     height: 30,
                                                  width: 30,),
                                              ])
                                          ),
                                          Text(msg,style: TextStyle(fontSize: 14.0,fontWeight:FontWeight.bold, color: Colors.black))
                                      ] ,
                                      ),
                                    ],

                                  )

                              );

                            } else {return new Text("There is no data");}
                            //return new ListView(children: getExpenseItems(snapshot1));
                          }
                      ),



                    Center( child:
                      // The grid of squares
                      SizedBox(

                        width: 800,
                        child:
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
                          else if ((rowNumber == 8) && (columnNumber == 7)) {
                            image = getImage(ImageType.bombsw);
                          }
                          else if ((rowNumber == 7) && (columnNumber == 8)) {
                            image = getImage(ImageType.bombne);
                          }
                          else if ((rowNumber == 8) && (columnNumber == 8)) {
                            image = getImage(ImageType.bombse);
                          }
                          //Quadrant 1
                          else if ((rowNumber == 4) && (columnNumber == 2)) {
                            image = getImage(ImageType.greencirclene);
                          }
                          else if ((rowNumber == 2) && (columnNumber == 5)) {
                            image = getImage(ImageType.bluecrossse);
                          }
                          else if ((rowNumber == 6) && (columnNumber == 1)) {
                            image = getImage(ImageType.yellowsaturnnw);
                          }
                          else if ((rowNumber == 5) && (columnNumber == 7)) {
                            image = getImage(ImageType.redtrianglesw);
                          }
                          else if ((rowNumber == 5) && (columnNumber == 0)) {
                            image = getImage(ImageType.walln);
                          }
                          else if ((rowNumber == 4) && (columnNumber == 0)) {
                            image = getImage(ImageType.walls);
                          }
                          else if ((rowNumber == 0) && (columnNumber == 3)) {
                            image = getImage(ImageType.walle);
                          }
                          else if ((rowNumber == 0) && (columnNumber == 4)) {
                            image = getImage(ImageType.wallw);
                          }
                          //Quadrant 2
                          else if ((rowNumber == 2) && (columnNumber == 9)) {
                            image = getImage(ImageType.bluetrianglese);
                          }
                          else if ((rowNumber == 1) && (columnNumber == 13)) {
                            image = getImage(ImageType.redsaturnnw);
                          }
                          else if ((rowNumber == 6) && (columnNumber == 11)) {
                            image = getImage(ImageType.yellowcirclene);
                          }
                          else if ((rowNumber == 5) && (columnNumber == 14)) {
                            image = getImage(ImageType.greencrosssw);
                          }
                          else if ((rowNumber == 0) && (columnNumber == 11)) {
                            image = getImage(ImageType.walle);
                          }
                          else if ((rowNumber == 0) && (columnNumber == 12)) {
                            image = getImage(ImageType.wallw);
                          }
                          else if ((rowNumber == 3) && (columnNumber == 15)) {
                            image = getImage(ImageType.walls);
                          }
                          else if ((rowNumber == 4) && (columnNumber == 15)) {
                            image = getImage(ImageType.walln);
                          }
                          //Quadrant 3
                          else if ((rowNumber == 11) && (columnNumber == 1)) {
                            image = getImage(ImageType.redcirclesw);
                          }
                          else if ((rowNumber == 9) && (columnNumber == 3)) {
                            image = getImage(ImageType.yellowcrossne);
                          }
                          else if ((rowNumber == 14) && (columnNumber == 2)) {
                            image = getImage(ImageType.greentrianglenw);
                          }
                          else if ((rowNumber == 12) && (columnNumber == 6)) {
                            image = getImage(ImageType.bluesaturnse);
                          }
                          else if ((rowNumber == 15) && (columnNumber == 5)) {
                            image = getImage(ImageType.walle);
                          }
                          else if ((rowNumber == 15) && (columnNumber == 6)) {
                            image = getImage(ImageType.wallw);
                          }
                          else if ((rowNumber == 13) && (columnNumber == 0)) {
                            image = getImage(ImageType.walls);
                          }
                          else if ((rowNumber == 14) && (columnNumber == 0)) {
                            image = getImage(ImageType.walln);
                          }
                          //Quadrant 4
                          else if ((rowNumber == 10) && (columnNumber == 8)) {
                            image = getImage(ImageType.rainbownw);
                          }
                          else if ((rowNumber == 10) && (columnNumber == 13)) {
                            image = getImage(ImageType.redcrossnw);
                          }
                          else if ((rowNumber == 12) && (columnNumber == 14)) {
                            image = getImage(ImageType.yellowtrianglesw);
                          }
                          else if ((rowNumber == 11) && (columnNumber == 10)) {
                            image = getImage(ImageType.greensaturnse);
                          }
                          else if ((rowNumber == 14) && (columnNumber == 9)) {
                            image = getImage(ImageType.bluecirclene);
                          }
                          else if ((rowNumber == 15) && (columnNumber == 11)) {
                            image = getImage(ImageType.walle);
                          }
                          else if ((rowNumber == 15) && (columnNumber == 12)) {
                            image = getImage(ImageType.wallw);
                          }
                          else if ((rowNumber == 8) && (columnNumber == 15)) {
                            image = getImage(ImageType.walls);
                          }
                          else if ((rowNumber == 9) && (columnNumber == 15)) {
                            image = getImage(ImageType.walln);
                          }
                          else if ((rowNumber == 9) && (columnNumber == 15)) {
                            image = getImage(ImageType.walln);
                          }
                          else if ((rowNumber == 8) && (columnNumber == 15)) {
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
                      ),
),
                      Center(child:Text("Moves " + movecount.toString(),style: TextStyle(fontSize: 32.0,fontWeight:FontWeight.bold))),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('Games/'+args.gamename+'/Players').orderBy('bet', descending: false).snapshots(), //.doc(_auth.currentUser.email).get(),
                          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot1 ) {
                            if (snapshot1.hasData) {
                              var data = [];
                              List<String> players = [];
                              List<String> bets = [];
                              List<String> scores = [];
                              snapshot1.data?.docs.forEach((f) => bets.add(f.data()["bet"].toString()));
                              snapshot1.data?.docs.forEach((f) => players.add(f.id.toString()));
                              snapshot1.data?.docs.forEach((f) => scores.add(f.data()["score"].toString()));

                              List<DataRow> _createRows(QuerySnapshot snapshot) {
                                List<DataRow> newList = snapshot.docs.map((DocumentSnapshot documentSnapshot) {
                                  return new DataRow(cells: [ DataCell(Text(documentSnapshot.id.toString(),  style: TextStyle(height: 1, fontSize: 15),)) ,
                                    DataCell(Text(documentSnapshot['bet'].toString(),  style: TextStyle(height: 1, fontSize: 15),)),
                                    DataCell(Text(documentSnapshot['score'].toString(),  style: TextStyle(height: 1, fontSize: 15),)),
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
                                      dataRowHeight: 20,
                                      headingRowHeight: 30,
                                      headingRowColor: MaterialStateColor.resolveWith((states) => Colors.black26),
                                      showBottomBorder: true,
                                      columns: [
                                        DataColumn(label: Text('PLAYER', style: TextStyle(fontWeight: FontWeight.bold),)),
                                        DataColumn(label: Text('BID', style: TextStyle(fontWeight: FontWeight.bold),)),
                                        DataColumn(label: Text('SCORE',style: TextStyle(fontWeight: FontWeight.bold),)),
                                      ],
                                      rows: _createRows(snapshot1.data!),

                                    );
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
    boardpos[2][5].obstaclesouth = true;
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
    boardpos[3][5].obstaclenorth = true;
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

    boardpos[1][13].collectible = "redsaturn";
    boardpos[2][5].collectible = "bluestar";
    boardpos[2][9].collectible = "bluetriangle";
    boardpos[4][2].collectible = "greencircle";
    boardpos[5][7].collectible = "redtriangle";
    boardpos[5][14].collectible = "greenstar";
    boardpos[6][1].collectible = "yellowsaturn";
    boardpos[6][11].collectible = "yellowcircle";
    boardpos[9][3].collectible = "yellowstar";
    boardpos[10][13].collectible = "redstar";
    boardpos[11][1].collectible = "redcircle";
    boardpos[11][10].collectible = "greensaturn";
    boardpos[12][6].collectible = "bluesaturn";
    boardpos[12][14].collectible = "yellowtriangle";
    boardpos[14][2].collectible = "greentriangle";
    boardpos[14][9].collectible = "bluecircle";




    //setState(() {});
  }


  Future _reinitialiseGame(String gamename, int PositionBlueI, int PositionBlueJ, int PositionRedI,int PositionRedJ, int PositionGreenI,int PositionGreenJ, int PositionYellowI,int PositionYellowJ) async {
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
    boardpos[6][0].obstacleeast = true;
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
    boardpos[6][1].obstaclewest = true;
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
    boardpos[2][5].obstaclesouth = true;
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
    boardpos[3][5].obstaclenorth = true;
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

    boardpos[1][13].collectible = "redsaturn";
    boardpos[2][5].collectible = "bluestar";
    boardpos[2][9].collectible = "bluetriangle";
    boardpos[4][2].collectible = "greencircle";
    boardpos[5][7].collectible = "redtriangle";
    boardpos[5][14].collectible = "greenstar";
    boardpos[6][1].collectible = "yellowsaturn";
    boardpos[6][11].collectible = "yellowcircle";
    boardpos[9][3].collectible = "yellowstar";
    boardpos[10][13].collectible = "redstar";
    boardpos[11][1].collectible = "redcircle";
    boardpos[11][10].collectible = "greensaturn";
    boardpos[12][6].collectible = "bluesaturn";
    boardpos[12][14].collectible = "yellowtriangle";
    boardpos[14][2].collectible = "greentriangle";
    boardpos[14][9].collectible = "bluecircle";


    boardpos[redi][redj].redposition = false;      // print(snapshot.connectionState);
    boardpos[bluei][bluej].blueposition = false;      // print(snapshot.connectionState);
    boardpos[greeni][greenj].greenposition = false;      // print(snapshot.connectionState);
    boardpos[yellowi][yellowj].yellowposition = false;      // print(snapshot.connectionState);


    await game.doc(gamename).update({'redalti': PositionRedI,'redaltj':PositionRedJ});
    await game.doc(gamename).update({'bluealti': PositionBlueI,'bluealtj':PositionBlueJ});
    await game.doc(gamename).update({'greenalti': PositionGreenI,'greenaltj':PositionGreenJ});
    await game.doc(gamename).update({'yellowalti': PositionYellowI,'yellowaltj':PositionYellowJ});

    await game.doc(gamename).update({'redorigi': PositionRedI,'redorigj':PositionRedJ});
    await game.doc(gamename).update({'blueorigi': PositionBlueI,'blueorigj':PositionBlueJ});
    await game.doc(gamename).update({'greenorigi': PositionGreenI,'greenorigj':PositionGreenJ});
    await game.doc(gamename).update({'yelloworigi': PositionYellowI,'yelloworigj':PositionYellowJ});

    await game.doc(gamename).update({'movecount': 0});
    await game.doc(gamename).update({'bluei': 4,'bluej':4});
    await game.doc(gamename).update({'redi': 3,'redj':3});
    await game.doc(gamename).update({'greeni': 8,'greenj':2});
    await game.doc(gamename).update({'yellowi': 13,'yellowj':13});

    var list = new List<int>.filled(16, 0);
    for (var i = 0; i < list.length; i++) {
      list[i]=i;
      //print(list[i]);
    }
    for (var i = 0; i < list.length; i++) {
      int a=Random().nextInt(8);
      int b=Random().nextInt(9)+7;
      int avalue = list[a];
      int bvalue = list[b];
      list[a]=bvalue;
      list[b]=avalue;
    }
print("a");
    CollectionReference collectibleupdate = FirebaseFirestore.instance.collection('Games/'+gamename+'/Collectibles');

    await collectibleupdate.doc("RedSaturn").update({'Round': list[1]});
    await collectibleupdate.doc("BlueCross").update({'Round': list[2]});
    await collectibleupdate.doc("BlueTriangle").update({'Round': list[3]});
    await collectibleupdate.doc("GreenCircle").update({'Round': list[4]});
    await collectibleupdate.doc("RedTriangle").update({'Round': list[5]});
    await collectibleupdate.doc("GreenCross").update({'Round': list[6]});
    await collectibleupdate.doc("YellowSaturn").update({'Round': list[7]});
    await collectibleupdate.doc("YellowCircle").update({'Round': list[8]});
    await collectibleupdate.doc("YellowCross").update({'Round': list[9]});
    await collectibleupdate.doc("RedCross").update({'Round': list[10]});
    await collectibleupdate.doc("RedCircle").update({'Round': list[11]});
    await collectibleupdate.doc("GreenSaturn").update({'Round': list[12]});
    await collectibleupdate.doc("BlueSaturn").update({'Round': list[13]});
    await collectibleupdate.doc("YellowTriangle").update({'Round': list[14]});
    await collectibleupdate.doc("GreenTriangle").update({'Round': list[15]});
    await collectibleupdate.doc("BlueCircle").update({'Round': list[0]});

  }
  // This function opens other squares around the target square which don't have any bombs around them.
  // We use a recursive function which stops at squares which have a non zero number of bombs around them.

  Future _handleMoveRedAlt(String gamename, int i, int j, int t) async {
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
    await game.doc(gamename).update({'redi': i,'redj':j,'redalti': ialt,'redaltj':jalt});
    if(ialt!=i || jalt!=j) {
      await game.doc(gamename).update({'movecount': FieldValue.increment(1)});
    }    //setState(() {});
  }

  Future _handleMoveBlueAlt(String gamename, int i, int j, int t) async {
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

    await game.doc(gamename).update({'bluei': i,'bluej':j,'bluealti': ialt,'bluealtj':jalt});
    if(ialt!=i || jalt!=j) {
      await game.doc(gamename).update({'movecount': FieldValue.increment(1)});
    }    // setState(() {});
  }

  Future _handleMoveGreenAlt(String gamename, int i, int j, int t) async {

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

    await game.doc(gamename).update({'greeni': i,'greenj':j,'greenalti': ialt,'greenaltj':jalt});
    print("MOVED");
    if(ialt!=i || jalt!=j) {
      await game.doc(gamename).update({'movecount': FieldValue.increment(1)});
    }
    //setState(() {});
  }

  Future _handleMoveYellowAlt(String gamename, int i, int j, int t) async {

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

    await game.doc(gamename).update({'yellowi': i,'yellowj':j,'yellowalti': ialt,'yellowaltj':jalt});
    if(ialt!=i || jalt!=j) {
      await game.doc(gamename).update({'movecount': FieldValue.increment(1)});
    }    //setState(() {});
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

  Future _submitBet(String gamename, String? uid, int bet, int Round, int Timer) async {
    CollectionReference betupdate = FirebaseFirestore.instance.collection('Games/'+ gamename +'/Players');
    CollectionReference gameupdate = FirebaseFirestore.instance.collection('Games/');
    CollectionReference round2update = FirebaseFirestore.instance.collection('Games/'+ gamename +'/Rounds');

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Games/'+ gamename +'/Players').orderBy('bet', descending: false).limit(1).get();
    var list = querySnapshot.docs;
    List<int> bets = [];
    list.forEach((f) => bets.add(f.data()['bet']));

    int lowestbid = 99;
    var collection = FirebaseFirestore.instance.collection('Games');
    var docSnapshot = await collection.doc(gamename).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      int value = data?['lowestbid'];
      lowestbid=value;// <-- The value you want to retrieve.
    }

    print(bets);
    if(bets.first == 99 && Timer!=0) {
      await gameupdate.doc(gamename).update({'lowestbidder': uid.toString()});
      await gameupdate.doc(gamename).update({'lowestbid': bet});
      await gameupdate.doc(gamename).update({'firstbet': DateTime.now()});
      startTimer(gamename);
      print(bets);
    }
    if(bet < lowestbid  && Timer!=0){
      await gameupdate.doc(gamename).update({'lowestbidder': uid.toString()});
      await gameupdate.doc(gamename).update({'lowestbid': bet});
    }
    await betupdate.doc(uid).update({'bet': bet, 'timestampupdated': DateTime.now()});

    //await betupdate.doc(uid).update({'bet': bet});

  }

  Future _setwinner(String gamename, int Round,String uid) async {
    CollectionReference gameupdate = FirebaseFirestore.instance.collection('Games/');
    await gameupdate.doc(gamename).update({'winner': uid});
  }

  Future _nextRound(String gamename, int Round,String uid,PositionBlueI, int PositionBlueJ, int PositionRedI, int PositionRedJ, int PositionGreenI, int PositionGreenJ, int PositionYellowI, int PositionYellowJ) async {
    CollectionReference gameupdate = FirebaseFirestore.instance.collection('Games/');
    CollectionReference playerupdate = FirebaseFirestore.instance.collection('Games/'+gamename+'/Players');
    CollectionReference roundupdate = FirebaseFirestore.instance.collection('Games/'+gamename+'/Rounds');
    DocumentSnapshot gamedata = await FirebaseFirestore.instance.collection('Games').doc(gamename).get();

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Games/'+ gamename +'/Players').get();
    var list = querySnapshot.docs;
    list.forEach((element) { playerupdate.doc(element.id).update({'bet': 99}); });
    if(gamedata.data()!["winner"]==gamedata.data()!["lowestbidder"]) {
      list.where((element) => element.id == uid).forEach((element) {
        playerupdate.doc(element.id).update({'score': FieldValue.increment(1)});
      });
    }


    await gameupdate.doc(gamename).update({'Round': Round+1});
    await gameupdate.doc(gamename).update({'lowestbidder': "a@a.at"});
    await gameupdate.doc(gamename).update({'lowestbid': 99});
    await gameupdate.doc(gamename).update({'winner': ""});
    await gameupdate.doc(gamename).update({'firstbet': DateTime.now()});
    await gameupdate.doc(gamename).update({'movecount': 0});
    await gameupdate.doc(gamename).update({'Timer': 10});
    _start=10;
    await roundupdate.doc((Round+1).toString())
        .set({
      'Start': DateTime.now().add(const Duration(minutes: 5))
    });

    await gameupdate.doc(gamename).update({'redorigi': PositionRedI,'redorigj':PositionRedJ});
    await gameupdate.doc(gamename).update({'blueorigi': PositionBlueI,'blueorigj':PositionBlueJ});
    await gameupdate.doc(gamename).update({'greenorigi': PositionGreenI,'greenorigj':PositionGreenJ});
    await gameupdate.doc(gamename).update({'yelloworigi': PositionYellowI,'yelloworigj':PositionYellowJ});

  }

  Future _nextBestBet(String gamename, String uid,int PositionBlueI, int PositionBlueJ, int PositionRedI, int PositionRedJ, int PositionGreenI, int PositionGreenJ, int PositionYellowI, int PositionYellowJ) async {
    //_reinitialiseGame(PositionBlueI, PositionBlueJ, PositionRedI, PositionRedJ, PositionGreenI, PositionGreenJ, PositionYellowI, PositionYellowJ);
    CollectionReference playerupdate = FirebaseFirestore.instance.collection('Games/'+gamename+'/Players');
    CollectionReference gameupdate = FirebaseFirestore.instance.collection('Games/');
    DocumentSnapshot gamedata = await FirebaseFirestore.instance.collection('Games').doc(gamename).get();

    print(gamedata.data()!["bluei"]);;
    print(gamedata.data()!["bluej"]);;

    int newredi = gamedata.data()!["redorigi"];
    int newredj = gamedata.data()!["redorigj"];
    int newbluei = gamedata.data()!["blueorigi"];
    int newbluej = gamedata.data()!["blueorigj"];
    int newgreeni = gamedata.data()!["greenorigi"];
    int newgreenj = gamedata.data()!["greenorigj"];
    int newyellowi = gamedata.data()!["yelloworigi"];
    int newyellowj = gamedata.data()!["yelloworigj"];

    playerupdate.doc(uid).update({'bet': 100});
    print("NextBestBet");
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Games/'+gamename+'/Players').orderBy('bet', descending: false).limit(1).get();
    var list = querySnapshot.docs;
    List<String> player = [];
    List<int> bid = [];
    list.forEach((f) => player.add(f.id));
    list.forEach((f) => bid.add(f.data()["bet"]));
    //list.forEach((f) => print(f.id));

    print( "Debug1" + player.first);

    await gameupdate.doc(gamename).update({'lowestbidder': player.first});
    await gameupdate.doc(gamename).update({'lowestbid': bid.first});
    await gameupdate.doc(gamename).update({'movecount': 0});


    await gameupdate.doc(gamename).update({'redalti': PositionRedI,'redaltj':PositionRedJ});
    await gameupdate.doc(gamename).update({'bluealti': PositionBlueI,'bluealtj':PositionBlueJ});
    await gameupdate.doc(gamename).update({'greenalti': PositionGreenI,'greenaltj':PositionGreenJ});
    await gameupdate.doc(gamename).update({'yellowalti': PositionYellowI,'yellowaltj':PositionYellowJ});

    await gameupdate.doc(gamename).update({'redi': newredi,'redj':newredj});
    await gameupdate.doc(gamename).update({'bluei': newbluei,'bluej':newbluej});
    await gameupdate.doc(gamename).update({'greeni': newgreeni,'greenj':newgreenj});
    await gameupdate.doc(gamename).update({'yellowi': newyellowi,'yellowj':newyellowj});



  }


  Future _resetGame(String gamename,int PositionBlueI, int PositionBlueJ, int PositionRedI, int PositionRedJ, int PositionGreenI, int PositionGreenJ, int PositionYellowI, int PositionYellowJ) async {
    stopTimer();
    await _reinitialiseGame(gamename,PositionBlueI, PositionBlueJ, PositionRedI, PositionRedJ, PositionGreenI, PositionGreenJ, PositionYellowI, PositionYellowJ);
    CollectionReference gameupdate = FirebaseFirestore.instance.collection('Games/');
    CollectionReference playerupdate = FirebaseFirestore.instance.collection('Games/'+gamename+'/Players');
    await gameupdate.doc(gamename).update({'lowestbidder': ""});
    await gameupdate.doc(gamename).update({'lowestbid': 99});
    await gameupdate.doc(gamename).update({'firstbet': DateTime.now()});
    await gameupdate.doc(gamename).update({'movecount': 0});
    await gameupdate.doc(gamename).update({'Round': 1});
    await gameupdate.doc(gamename).update({'Timer': 10});


    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Games/'+ gamename +'/Players').get();
    var list = querySnapshot.docs;
    list.forEach((element) { playerupdate.doc(element.id).update({'bet': 99}); });
    list.forEach((element) { playerupdate.doc(element.id).update({'score': 0}); });


    await _reinitialiseGame(gamename,PositionBlueI, PositionBlueJ, PositionRedI, PositionRedJ, PositionGreenI, PositionGreenJ, PositionYellowI, PositionYellowJ);

  }

}




