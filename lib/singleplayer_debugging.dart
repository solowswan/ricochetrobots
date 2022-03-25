//import 'package:flutter/services.dart';
//import 'package:provider/provider.dart';
//import 'package:cloud_functions/cloud_functions.dart';
//import 'dart:html';
import 'dart:math';
import 'dart:async';
//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ricochetrobots/main.dart';
import 'board_square.dart';
//import 'helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:numberpicker/numberpicker.dart';
//import 'games_list.dart';

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



class singleplayer_debugging extends StatelessWidget {



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

  int PositionBlueI = 2;
  int PositionBlueAltI = 2;
  int PositionBlueJ=8;
  int PositionBlueAltJ = 2;

  int PositionRedI = 3;
  int PositionRedAltI = 3;
  int PositionRedJ=3;
  int PositionRedAltJ = 3;

  int PositionGreenI = 4;
  int PositionGreenAltI = 2;
  int PositionGreenJ=4;
  int PositionGreenAltJ = 2;

  int PositionYellowI = 13;
  int PositionYellowAltI = 13;
  int PositionYellowJ=13;
  int PositionYellowAltJ = 13;
  int movecount = 1;

  int GameRound = 1;
  int RunningTimer = 1;
  String lowestbidder = "asd";
  String hostplayer = "qwsde";

  int lowestbid = 1;
  bool isEnabled = false;

  String msg="";
  late FocusNode myFocusNode;

  ValueNotifier<int> _counter = ValueNotifier<int>(10);
  ValueNotifier<int> _switch = ValueNotifier<int>(1);

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
    //super.initState();
    _initialiseGame();
  }

  @override
  Widget build(BuildContext context) {

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
                    ListView(
                      children: <Widget>[
                        ConstrainedBox(
                          //color: Colors.grey,
                          //height: 60.0,
                          constraints: BoxConstraints(maxWidth: 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Column(children: <Widget>[IconButton(
                                icon: const Icon(Icons.launch),
                                tooltip: 'Initialise Board',
                                onPressed: () {
                                  _initialiseGame();
                                },
                              ),
                                Text('START')]), Column(children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.replay),
                                  tooltip: 'Reset',
                                  onPressed: () {
                                    if (_auth.currentUser?.email == hostplayer) {
                                      _resetGame(_auth.currentUser?.email,PositionBlueI,PositionBlueJ, PositionRedI, PositionRedJ, PositionGreenI, PositionGreenJ, PositionYellowI, PositionYellowJ);
                                    }
                                  },
                                ),
                                Text('Reset')
                              ]),
                              Column(children: <Widget>[IconButton(
                                icon: const Icon(Icons.arrow_forward),
                                tooltip: 'Next Round',
                                onPressed: () {
                                  if (_auth.currentUser?.email == hostplayer) {
                                    _nextRound(_auth.currentUser?.email, GameRound, lowestbidder, PositionBlueI, PositionBlueJ, PositionRedI, PositionRedJ, PositionGreenI, PositionGreenJ, PositionYellowI, PositionYellowJ);
                                  }
                                },
                              ),
                                Text('NextRound')]),
                            ],
                          ),

                        ),
                        ConstrainedBox(
                          //color: Colors.grey,
                          //height: 60.0,
                          constraints: BoxConstraints(maxWidth: 5),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("ROUND: " + GameRound.toString() + " ",
                                  style: TextStyle(fontSize: 24.0,
                                      fontWeight: FontWeight.bold)),

                              IconButton(
                                icon: Icon(
                                  Icons.remove,
                                  color: Theme.of(context).accentColor,
                                ),
                                padding: EdgeInsets.symmetric(vertical: 4.0,
                                    horizontal: 0.0),
                                iconSize: 32.0,
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  _counter.value--;
                                  //               print(_counter.value);
                                },
                              ),

                              ValueListenableBuilder(
                                valueListenable: _counter,
                                builder: (context, value, child) =>
                                    Text('$value', style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.red)),
                              ),

                              IconButton(
                                icon: Icon(
                                  Icons.add,
                                  color: Theme.of(context).accentColor,
                                ),
                                padding: EdgeInsets.symmetric(vertical: 4.0,
                                    horizontal: 0.0),
                                iconSize: 32.0,
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  _counter.value++;
                                },
                              ),

                              ElevatedButton(
                                child: Text('SUBMIT BID'),
                                onPressed: isEnabled ? () {
                                  _submitBet(_auth.currentUser?.email, _auth.currentUser?.email, _counter.value, GameRound, RunningTimer);
                                  myFocusNode.unfocus();
                                } : null,
                              ),
                            ],
                          ),

                        ),

                        Center(child:
                        // The grid of squares
                        SizedBox(
                            width: 800,
                            child:
                            ValueListenableBuilder(
                                valueListenable: _switch,
                                builder: (context, value, child) {
                                  return (
                                      GridView.builder(
                                        itemCount: rowCount * columnCount,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: columnCount,
                                        ),
                                        itemBuilder: (context, position) {
                                          int rowNumber = (position /columnCount).floor();
                                          int columnNumber = (position %columnCount);
                                          if ((rowNumber == 7) && (columnNumber == 7)) {
                                            return (
                                                Container(
                                                  padding: const EdgeInsets.all(0.0),
                                                  child: Container(
                                                    color: Colors.black,
                                                  ),
                                                )
                                            );
                                          }
                                          else if ((rowNumber == 8) && (columnNumber == 7)) {
                                            return (Container(
                                              padding: const EdgeInsets.all(0.0),
                                              child: Container(
                                                color: Colors.black,
                                              ),
                                            )
                                            );
                                          }
                                          else
                                          if ((rowNumber == 7) && (columnNumber == 8)) {
                                            return (Container(
                                              padding: const EdgeInsets.all(0.0),
                                              child: Container(
                                                color: Colors.black,
                                              ),
                                            )
                                            );
                                          }
                                          else
                                          if ((rowNumber == 8) && (columnNumber == 8)) {
                                            return (Container(
                                              padding: const EdgeInsets.all(0.0),
                                              child: Container(
                                                color: Colors.black,
                                              ),
                                            )
                                            );
                                          }
                                          if(_switch.value==-1) {
                                            if(PositionBlueI<15){boardpos[PositionBlueI+1][PositionBlueJ].downarrow=true;}
                                            if(PositionBlueJ<15){boardpos[PositionBlueI][PositionBlueJ+1].rightarrow=true;}
                                            if(PositionBlueI>0){boardpos[PositionBlueI-1][PositionBlueJ].uparrow=true;}
                                            if(PositionBlueJ>0){boardpos[PositionBlueI][PositionBlueJ-1].leftarrow=true;}
                                          } else if(_switch.value==-2) {
                                            if(PositionRedI<15){boardpos[PositionRedI+1][PositionRedJ].downarrow=true;}
                                            if(PositionRedJ<15){boardpos[PositionRedI][PositionRedJ+1].rightarrow=true;}
                                            if(PositionRedI>0){boardpos[PositionRedI-1][PositionRedJ].uparrow=true;}
                                            if(PositionRedJ>0){boardpos[PositionRedI][PositionRedJ-1].leftarrow=true;}
                                          }else if(_switch.value==-3) {
                                            if(PositionGreenI<15){boardpos[PositionGreenI+1][PositionGreenJ].downarrow=true;}
                                            if(PositionGreenJ<15){boardpos[PositionGreenI][PositionGreenJ+1].rightarrow=true;}
                                            if(PositionGreenI>0){boardpos[PositionGreenI-1][PositionGreenJ].uparrow=true;}
                                            if(PositionGreenJ>0){boardpos[PositionGreenI][PositionGreenJ-1].leftarrow=true;}
                                          }else if(_switch.value==-4) {
                                            if(PositionYellowI<15){boardpos[PositionYellowI+1][PositionYellowJ].downarrow=true;}
                                            if(PositionYellowJ<15){boardpos[PositionYellowI][PositionYellowJ+1].rightarrow=true;}
                                            if(PositionYellowI>0){boardpos[PositionYellowI-1][PositionYellowJ].uparrow=true;}
                                            if(PositionYellowJ>0){boardpos[PositionYellowI][PositionYellowJ-1].leftarrow=true;}
                                          }else if (_switch.value.sign==1) {
                                            boardpos.forEach((f) => {f.forEach((x) => {x.downarrow=false}) });
                                            boardpos.forEach((f) => {f.forEach((x) => {x.rightarrow=false}) });
                                            boardpos.forEach((f) => {f.forEach((x) => {x.uparrow=false}) });
                                            boardpos.forEach((f) => {f.forEach((x) => {x.leftarrow=false}) });
                                          }
                                          boardpos[PositionGreenI][PositionGreenJ].greenposition = true;
                                          boardpos[PositionBlueI][PositionBlueJ].blueposition = true;
                                          boardpos[PositionYellowI][PositionYellowJ].yellowposition = true;
                                          boardpos[PositionRedI][PositionRedJ].redposition = true;

                                          _initialiseGame();
                                          double topwidth=0.0;
                                          double bottomwidth=0.0;
                                          double rightwidth=0.0;
                                          double leftwidth=0.0;
                                          double saturn=0.0;
                                          double circle=0.0;
                                          int iconindex=-1;
                                          List<IconData> _icons = [
                                            Icons.wb_sunny_sharp,
                                            Icons.add_alarm,
                                            Icons.anchor,
                                            Icons.vpn_lock,
                                          ];
                                          final Color myColor;
                                          if (boardpos[rowNumber][columnNumber].obstaclenorth) {
                                           topwidth=4;
                                          }
                                          if (boardpos[rowNumber][columnNumber].obstaclesouth) {
                                            bottomwidth=4;
                                          }
                                          if (boardpos[rowNumber][columnNumber].obstacleeast) {
                                            rightwidth=4;
                                          }
                                          if (boardpos[rowNumber][columnNumber].obstaclewest) {
                                            leftwidth=4;
                                          }
                                          if (boardpos[rowNumber][columnNumber].collectible == "GreenSaturn") {
                                            iconindex=0;
                                            myColor = Colors.green;
                                          } else if (boardpos[rowNumber][columnNumber].collectible == "RedSaturn") {
                                            iconindex=0;
                                            myColor = Colors.red;
                                          } else if (boardpos[rowNumber][columnNumber].collectible == "BlueSaturn") {
                                            iconindex=0;
                                            myColor = Colors.blue;
                                          } else if (boardpos[rowNumber][columnNumber].collectible == "YellowSaturn") {
                                            iconindex=0;
                                            myColor = Colors.yellow;
                                          } else if (boardpos[rowNumber][columnNumber].collectible == "GreenCircle") {
                                            iconindex=1;
                                            myColor = Colors.green;
                                          } else if (boardpos[rowNumber][columnNumber].collectible == "RedCircle") {
                                            iconindex=1;
                                            myColor = Colors.red;
                                          } else if (boardpos[rowNumber][columnNumber].collectible == "BlueCircle") {
                                            iconindex=1;
                                            myColor = Colors.blue;
                                          } else if (boardpos[rowNumber][columnNumber].collectible == "YellowCircle") {
                                            iconindex=1;
                                            myColor = Colors.yellow;
                                          } else if (boardpos[rowNumber][columnNumber].collectible == "GreenTriangle") {
                                            iconindex=2;
                                            myColor = Colors.green;
                                          } else if (boardpos[rowNumber][columnNumber].collectible == "RedTriangle") {
                                            iconindex=2;
                                            myColor = Colors.red;
                                          } else if (boardpos[rowNumber][columnNumber].collectible == "BlueTriangle") {
                                            iconindex=2;
                                            myColor = Colors.blue;
                                          } else if (boardpos[rowNumber][columnNumber].collectible == "YellowTriangle") {
                                            iconindex=2;
                                            myColor = Colors.yellow;
                                          } else if (boardpos[rowNumber][columnNumber].collectible == "GreenCross") {
                                            iconindex=3;
                                            myColor = Colors.green;
                                          } else if (boardpos[rowNumber][columnNumber].collectible == "RedCross") {
                                            iconindex=3;
                                            myColor = Colors.red;
                                          } else if (boardpos[rowNumber][columnNumber].collectible == "BlueCross") {
                                            iconindex=3;
                                            myColor = Colors.blue;
                                          } else if (boardpos[rowNumber][columnNumber].collectible == "YellowCross") {
                                            iconindex=3;
                                            myColor = Colors.yellow;
                                          }else {
                                            myColor = Colors.white;
                                          }




                                          if (boardpos[rowNumber][columnNumber].rightarrow) {
                                            return InkWell(
                                              onTap: () {
                                                _switch.value = _switch.value * -1;
                                                // print("Switch");
                                                //print(_switch.value);
                                                // if(_auth.currentUser?.email==lowestbidder && (_switch.value==-1))
                                                //  {
                                                if(_switch.value==1 || _switch.value==-1) {
                                                  _handleMoveBlueAlt(_auth.currentUser?.email, PositionBlueI, PositionBlueJ, 2);
                                                } else if(_switch.value==2 || _switch.value==-2) {
                                                  _handleMoveRedAlt(_auth.currentUser?.email, PositionRedI, PositionRedJ, 2);
                                                } else if(_switch.value==3|| _switch.value==-3) {
                                                  _handleMoveGreenAlt(_auth.currentUser?.email, PositionGreenI, PositionGreenJ, 2);
                                                } else if(_switch.value==4|| _switch.value==-4) {
                                                  _handleMoveYellowAlt(_auth.currentUser?.email, PositionYellowI, PositionYellowJ, 2);
                                                }
                                                //   };

                                              },
                                                splashColor: Colors.grey,
                                                child: Stack(children: <Widget>[Container(
                                                  padding: EdgeInsets.only(top: 0,bottom: 0,right: 0,left: 0),
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                        top: BorderSide(
                                                            width: topwidth,
                                                            color: Colors.black),
                                                        bottom: BorderSide(
                                                            width: bottomwidth,
                                                            color: Colors.black),
                                                        right: BorderSide(
                                                            width: rightwidth,
                                                            color: Colors.black),
                                                        left: BorderSide(
                                                            width: leftwidth,
                                                            color: Colors.black)
                                                    ),
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                  Container(
                                                      color: Colors.grey,
                                                      child: Text(
                                                          position.toString())
                                                  ),
                                                  Container(
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: Icon(
                                                          Icons.arrow_forward,
                                                          color: Colors.red,
                                                          size: MediaQuery.of(context).size.width/20, //48.0,
                                                        ),
                                                      )
                                                  )
                                                ])
                                            );
                                          }

                                          if (boardpos[rowNumber][columnNumber].uparrow) {
                                            return InkWell(
                                              onTap: () {
                                                _switch.value = _switch.value * -1;
                                                //  print("Switch");
                                                //  print(_switch.value);
                                                // if(_auth.currentUser?.email==lowestbidder && (_switch.value==-1))
                                                //  {
                                                if(_switch.value==1 || _switch.value==-1) {
                                                  _handleMoveBlueAlt(_auth.currentUser?.email, PositionBlueI, PositionBlueJ, 1);
                                                } else if(_switch.value==2 || _switch.value==-2) {
                                                  _handleMoveRedAlt(_auth.currentUser?.email, PositionRedI, PositionRedJ, 1);
                                                } else if(_switch.value==3|| _switch.value==-3) {
                                                  _handleMoveGreenAlt(_auth.currentUser?.email, PositionGreenI, PositionGreenJ, 1);
                                                } else if(_switch.value==4|| _switch.value==-4) {
                                                  _handleMoveYellowAlt(_auth.currentUser?.email, PositionYellowI, PositionYellowJ, 1);
                                                }
                                                //   };
                                              },
                                                splashColor: Colors.grey,
                                                child: Stack(children: <Widget>[Container(
                                                  padding: EdgeInsets.only(top: 0,bottom: 0,right: 0,left: 0),
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                        top: BorderSide(
                                                            width: topwidth,
                                                            color: Colors.black),
                                                        bottom: BorderSide(
                                                            width: bottomwidth,
                                                            color: Colors.black),
                                                        right: BorderSide(
                                                            width: rightwidth,
                                                            color: Colors.black),
                                                        left: BorderSide(
                                                            width: leftwidth,
                                                            color: Colors.black)
                                                    ),
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                  Container(
                                                      color: Colors.grey,
                                                      child: Text(
                                                          position.toString())
                                                  ),
                                                  Container(
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: Icon(
                                                          Icons.arrow_upward,
                                                          color: Colors.red,
                                                          size: MediaQuery.of(context).size.width/20, //48.0,
                                                        ),
                                                      )
                                                  )
                                                ])
                                            );
                                          }

                                          if (boardpos[rowNumber][columnNumber].leftarrow) {
                                            return InkWell(
                                              onTap: () {
                                                _switch.value = _switch.value * -1;
                                                // print("Switch");
                                                //  print(_switch.value);
                                                // if(_auth.currentUser?.email==lowestbidder && (_switch.value==-1))
                                                //  {
                                                if(_switch.value==1 || _switch.value==-1) {
                                                  _handleMoveBlueAlt(_auth.currentUser?.email, PositionBlueI, PositionBlueJ, 4);
                                                } else if(_switch.value==2 || _switch.value==-2) {
                                                  _handleMoveRedAlt(_auth.currentUser?.email, PositionRedI, PositionRedJ, 4);
                                                } else if(_switch.value==3|| _switch.value==-3) {
                                                  _handleMoveGreenAlt(_auth.currentUser?.email, PositionGreenI, PositionGreenJ, 4);
                                                } else if(_switch.value==4|| _switch.value==-4) {
                                                  _handleMoveYellowAlt(_auth.currentUser?.email, PositionYellowI, PositionYellowJ, 4);
                                                }
                                                //   };
                                              },
                                                splashColor: Colors.grey,
                                                child: Stack(children: <Widget>[Container(
                                                  padding: EdgeInsets.only(top: 0,bottom: 0,right: 0,left: 0),
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                        top: BorderSide(
                                                            width: topwidth,
                                                            color: Colors.black),
                                                        bottom: BorderSide(
                                                            width: bottomwidth,
                                                            color: Colors.black),
                                                        right: BorderSide(
                                                            width: rightwidth,
                                                            color: Colors.black),
                                                        left: BorderSide(
                                                            width: leftwidth,
                                                            color: Colors.black)
                                                    ),
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                  Container(
                                                      color: Colors.grey,
                                                      child: Text(
                                                          position.toString())
                                                  ),
                                                  Container(
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: Icon(
                                                          Icons.arrow_back,
                                                          color: Colors.red,
                                                          size: MediaQuery.of(context).size.width/20, //48.0,
                                                        ),
                                                      )
                                                  )
                                                ])
                                            );
                                          }

                                          if (boardpos[rowNumber][columnNumber].downarrow) {
                                            return InkWell(
                                              onTap: () {
                                                _switch.value = _switch.value * -1;
                                                //  print("Switch");
                                                //  print(_switch.value);
                                                // if(_auth.currentUser?.email==lowestbidder && (_switch.value==-1))
                                                //  {
                                                if(_switch.value==1 || _switch.value==-1) {
                                                  _handleMoveBlueAlt(_auth.currentUser?.email, PositionBlueI, PositionBlueJ, 3);
                                                } else if(_switch.value==2 || _switch.value==-2) {
                                                  _handleMoveRedAlt(_auth.currentUser?.email, PositionRedI, PositionRedJ, 3);
                                                } else if(_switch.value==3|| _switch.value==-3) {
                                                  _handleMoveGreenAlt(_auth.currentUser?.email, PositionGreenI, PositionGreenJ, 3);
                                                } else if(_switch.value==4|| _switch.value==-4) {
                                                  _handleMoveYellowAlt(_auth.currentUser?.email, PositionYellowI, PositionYellowJ, 3);
                                                }
                                                //   };
                                              },
                                              splashColor: Colors.grey,
                                              child: Stack(children: <Widget>[Container(
                                                      padding: EdgeInsets.only(top: 0,bottom: 0,right: 0,left: 0),
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                            top: BorderSide(
                                                                width: topwidth,
                                                                color: Colors.black),
                                                            bottom: BorderSide(
                                                                width: bottomwidth,
                                                                color: Colors.black),
                                                            right: BorderSide(
                                                                width: rightwidth,
                                                                color: Colors.black),
                                                            left: BorderSide(
                                                                width: leftwidth,
                                                                color: Colors.black)
                                                        ),
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Container(
                                                        color: Colors.grey,
                                                        child: Text(position.toString())
                                                    ),
                                                Container(
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                        Icons.arrow_downward,
                                                        color: Colors.red,
                                                        size: MediaQuery.of(context).size.width/20, //48.0,
                                                      ),
                                                  )
                                                    )
                                                  ])
                                            );
                                          }

                                          if (boardpos[rowNumber][columnNumber].blueposition) {
                                            return InkWell(
                                                onTap: () {
                                                  _switch.value = _switch.value.sign * 1 * -1;
                                                },
                                                splashColor: Colors.grey,
                                                child: Stack(children: <Widget>[Container(
                                                  padding: EdgeInsets.only(top: 0,bottom: 0,right: 0,left: 0),
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                        top: BorderSide(
                                                            width: topwidth,
                                                            color: Colors.black),
                                                        bottom: BorderSide(
                                                            width: bottomwidth,
                                                            color: Colors.black),
                                                        right: BorderSide(
                                                            width: rightwidth,
                                                            color: Colors.black),
                                                        left: BorderSide(
                                                            width: leftwidth,
                                                            color: Colors.black)
                                                    ),
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                  Container(
                                                      color: Colors.blue,
                                                      child: Text(position.toString())
                                                  )
                                                  //Text(position.toString())
                                                  //   Image.asset('assets/images/greenplayer.png'),
                                                ])

                                            );
                                          } else
                                          if (boardpos[rowNumber][columnNumber].redposition) {
                                            return InkWell(
                                                onTap: () {
                                                  _switch.value = _switch.value.sign * 2 * -1;
                                                },
                                                splashColor: Colors.grey,
                                                child: Stack(children: <Widget>[Container(
                                                  padding: EdgeInsets.only(top: 0,bottom: 0,right: 0,left: 0),
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                        top: BorderSide(
                                                            width: topwidth,
                                                            color: Colors.black),
                                                        bottom: BorderSide(
                                                            width: bottomwidth,
                                                            color: Colors.black),
                                                        right: BorderSide(
                                                            width: rightwidth,
                                                            color: Colors.black),
                                                        left: BorderSide(
                                                            width: leftwidth,
                                                            color: Colors.black)
                                                    ),
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                  Container(
                                                      color: Colors.red,
                                                      child: Text(position.toString())
                                                  )
                                                  //Text(position.toString())
                                                  //   Image.asset('assets/images/greenplayer.png'),
                                                ])

                                            );
                                          } else
                                          if (boardpos[rowNumber][columnNumber].greenposition) {
                                            return InkWell(
                                              onTap: () {
                                                _switch.value = _switch.value.sign * 3 * -1;
                                              },
                                              splashColor: Colors.grey,
                                              child: Stack(children: <Widget>[Container(
                                                    padding: EdgeInsets.only(top: 0,bottom: 0,right: 0,left: 0),
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                          top: BorderSide(
                                                              width: topwidth,
                                                              color: Colors.black),
                                                          bottom: BorderSide(
                                                              width: bottomwidth,
                                                              color: Colors.black),
                                                          right: BorderSide(
                                                              width: rightwidth,
                                                              color: Colors.black),
                                                          left: BorderSide(
                                                              width: leftwidth,
                                                              color: Colors.black)
                                                      ),
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                Container(
                                                    color: Colors.green,
                                                    child: Text(position.toString())
                                                )
                                                    //Text(position.toString())
                                                 //   Image.asset('assets/images/greenplayer.png'),
                                                  ])

                                            );
                                          } if (boardpos[rowNumber][columnNumber].yellowposition) {
                                            return InkWell(
                                                onTap: () {
                                                  _switch.value = _switch.value.sign * 4 * -1;
                                                },
                                                splashColor: Colors.grey,
                                                child: Stack(children: <Widget>[Container(
                                                  padding: EdgeInsets.only(top: 0,bottom: 0,right: 0,left: 0),
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                        top: BorderSide(
                                                            width: topwidth,
                                                            color: Colors.black),
                                                        bottom: BorderSide(
                                                            width: bottomwidth,
                                                            color: Colors.black),
                                                        right: BorderSide(
                                                            width: rightwidth,
                                                            color: Colors.black),
                                                        left: BorderSide(
                                                            width: leftwidth,
                                                            color: Colors.black)
                                                    ),
                                                    color: Colors.yellow,
                                                  ),
                                                ),
                                                  Container(
                                                      color: Colors.yellow,
                                                      child: Text(position.toString())
                                                  )
                                                  //Text(position.toString())
                                                  //   Image.asset('assets/images/greenplayer.png'),
                                                ])

                                            );
                                          } else {
                                            return (
                                                Stack(children: <Widget>[Container(
                                                  // padding: const EdgeInsets.all(1.0),
                                                  padding: EdgeInsets.only(top: 0,bottom: 0,right: 0,left: 0),
                                                  //color: Colors.black,
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                        top: BorderSide(
                                                            width: topwidth,
                                                            color: Colors.black),
                                                        bottom: BorderSide(
                                                            width: bottomwidth,
                                                            color: Colors.black),
                                                        right: BorderSide(
                                                            width: rightwidth,
                                                            color: Colors.black),
                                                        left: BorderSide(
                                                            width: leftwidth,
                                                            color: Colors.black)
                                                    ),
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                  Container(
                                                      color: Colors.grey,
                                                      child: Text(position.toString())
                                                  ),
                                                  if(iconindex>-1) (
                                                    Container(
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: Icon(
                                                            _icons[iconindex],//Icons.wb_sunny_sharp,
                                                            color: myColor, //Colors.green,
                                                            size: MediaQuery.of(context).size.width/30, //48.0,
                                                          ),
                                                        )
                                                    )
                                                  )
                                          ])
                                            );
                                          }
                                        },
                                      )
                                  );
                                })
                        ),
                        ),
                        Center(child: Text("Moves " + movecount.toString(),
                            style: TextStyle(
                                fontSize: 32.0, fontWeight: FontWeight.bold))),
                      ],
                    )
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

    boardpos[1][13].collectible = "RedSaturn";
    boardpos[2][5].collectible = "BlueCross";
    boardpos[2][9].collectible = "BlueTriangle";
    boardpos[4][2].collectible = "GreenCircle";
    boardpos[5][7].collectible = "RedTriangle";
    boardpos[5][14].collectible = "GreenCross";
    boardpos[6][1].collectible = "YellowSaturn";
    boardpos[6][11].collectible = "YellowCircle";
    boardpos[9][3].collectible = "YellowCross";
    boardpos[10][13].collectible = "RedCross";
    boardpos[11][1].collectible = "RedCircle";
    boardpos[11][10].collectible = "GreenSaturn";
    boardpos[12][6].collectible = "BlueSaturn";
    boardpos[12][14].collectible = "YellowTriangle";
    boardpos[14][2].collectible = "GreenTriangle";
    boardpos[14][9].collectible = "BlueCircle";




    //setState(() {});
  }


  Future _reinitialiseGame(String? gamename, int PositionBlueI, int PositionBlueJ, int PositionRedI,int PositionRedJ, int PositionGreenI,int PositionGreenJ, int PositionYellowI,int PositionYellowJ) async {
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

    boardpos[1][13].collectible = "RedSaturn";
    boardpos[2][5].collectible = "BlueCross";
    boardpos[2][9].collectible = "BlueTriangle";
    boardpos[4][2].collectible = "GreenCircle";
    boardpos[5][7].collectible = "RedTriangle";
    boardpos[5][14].collectible = "GreenCross";
    boardpos[6][1].collectible = "YellowSaturn";
    boardpos[6][11].collectible = "YellowCircle";
    boardpos[9][3].collectible = "YellowCross";
    boardpos[10][13].collectible = "RedCross";
    boardpos[11][1].collectible = "RedCircle";
    boardpos[11][10].collectible = "GreenSaturn";
    boardpos[12][6].collectible = "BlueSaturn";
    boardpos[12][14].collectible = "YellowTriangle";
    boardpos[14][2].collectible = "GreenTriangle";
    boardpos[14][9].collectible = "BlueCircle";


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
  //  print("a");
    CollectionReference collectibleupdate = FirebaseFirestore.instance.collection('Games/'+gamename!+'/Collectibles');

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

  Future _handleMoveRedAlt(String? gamename, int i, int j, int t) async {
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
    PositionRedI=i;
    PositionRedJ=j;
    PositionRedAltI=ialt;
    PositionRedAltJ=jalt;
    await game.doc(gamename).update({'redi': i,'redj':j,'redalti': ialt,'redaltj':jalt});
    if(ialt!=i || jalt!=j) {
      await game.doc(gamename).update({'movecount': FieldValue.increment(1)});
    }    //setState(() {});
  }

  Future _handleMoveBlueAlt(String? gamename, int i, int j, int t) async {
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
    PositionBlueI=i;
    PositionBlueJ=j;
    PositionBlueAltI=ialt;
    PositionBlueAltJ=jalt;
    await game.doc(gamename).update({'bluei': i,'bluej':j,'bluealti': ialt,'bluealtj':jalt});
    if(ialt!=i || jalt!=j) {
    //  await game.doc(gamename).update({'movecount': FieldValue.increment(1)});
    }    // setState(() {});
  }

  Future _handleMoveGreenAlt(String? gamename, int i, int j, int t) async {

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
    PositionGreenI=i;
    PositionGreenJ=j;
    PositionGreenAltI=ialt;
    PositionGreenAltJ=jalt;
    await game.doc(gamename).update({'greeni': i,'greenj':j,'greenalti': ialt,'greenaltj':jalt});
  //  print("MOVED");
    if(ialt!=i || jalt!=j) {
  //    await game.doc(gamename).update({'movecount': FieldValue.increment(1)});
    }
    //setState(() {});
  }

  Future _handleMoveYellowAlt(String? gamename, int i, int j, int t) async {

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
    PositionYellowI=i;
    PositionYellowJ=j;
    PositionYellowAltI=ialt;
    PositionYellowAltJ=jalt;
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

  Future _submitBet(String? gamename, String? uid, int bet, int Round, int Timer) async {
    CollectionReference betupdate = FirebaseFirestore.instance.collection('Games/'+ gamename! +'/Players');
    CollectionReference gameupdate = FirebaseFirestore.instance.collection('Games/');
    CollectionReference round2update = FirebaseFirestore.instance.collection('Games/'+ gamename + '/Rounds');

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

//    print(bets);
//    if(bets.first == 99 && Timer!=0) {
      await gameupdate.doc(gamename).update({'lowestbidder': uid.toString()});
      await gameupdate.doc(gamename).update({'lowestbid': bet});
      await gameupdate.doc(gamename).update({'firstbet': DateTime.now()});
      await gameupdate.doc(gamename).update({'Timer': 0});

      //startTimer(gamename);
//      print(bets);
//    }
 //   if(bet < lowestbid  && Timer!=0){
//      await gameupdate.doc(gamename).update({'lowestbidder': uid.toString()});
 //     await gameupdate.doc(gamename).update({'lowestbid': bet});
 //   }
//    await betupdate.doc(uid).update({'bet': bet, 'timestampupdated': DateTime.now()});

    //await betupdate.doc(uid).update({'bet': bet});

  }

  Future _setwinner(String? gamename, int Round,String uid) async {
    CollectionReference gameupdate = FirebaseFirestore.instance.collection('Games/');
    await gameupdate.doc(gamename).update({'winner': uid});
  }

  Future _nextRound(String? gamename, int Round,String uid,PositionBlueI, int PositionBlueJ, int PositionRedI, int PositionRedJ, int PositionGreenI, int PositionGreenJ, int PositionYellowI, int PositionYellowJ) async {
    CollectionReference gameupdate = FirebaseFirestore.instance.collection('Games/');
    CollectionReference playerupdate = FirebaseFirestore.instance.collection('Games/'+gamename!+'/Players');
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

  Future _resetGame(String? gamename,int PositionBlueI, int PositionBlueJ, int PositionRedI, int PositionRedJ, int PositionGreenI, int PositionGreenJ, int PositionYellowI, int PositionYellowJ) async {
    stopTimer();
    await _reinitialiseGame(gamename,PositionBlueI, PositionBlueJ, PositionRedI, PositionRedJ, PositionGreenI, PositionGreenJ, PositionYellowI, PositionYellowJ);
    CollectionReference gameupdate = FirebaseFirestore.instance.collection('Games/');
    CollectionReference playerupdate = FirebaseFirestore.instance.collection('Games/'+gamename!+'/Players');
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




