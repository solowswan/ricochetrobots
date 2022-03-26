import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ricochetrobots/main.dart';
import 'board_square.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class singleplayer_debugging extends StatelessWidget {

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

  String lowestbidder = "asd";

  int lowestbid = 1;
  bool isEnabled = true;

  String msg="";
  late FocusNode myFocusNode;

  ValueNotifier<int> _switch = ValueNotifier<int>(1);
  ValueNotifier<int> _move = ValueNotifier<int>(1);
  ValueNotifier<int> _GameRound = ValueNotifier<int>(1);

  final bet = TextEditingController();
  int counter = 5;

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
      ValueListenableBuilder(
          valueListenable: _GameRound,
          builder: (context, value, child) {
            if(_GameRound.value>2){isEnabled=false;}else{isEnabled=true;}
            return (
                    ListView(
                      children: <Widget>[
                        ConstrainedBox(
                          //color: Colors.grey,
                          //height: 60.0,
                          constraints: BoxConstraints(maxWidth: 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Column(children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.replay),
                                  tooltip: 'Reset',
                                  onPressed: () {
                                      _resetGame(_auth.currentUser?.email,PositionBlueI,PositionBlueJ, PositionRedI, PositionRedJ, PositionGreenI, PositionGreenJ, PositionYellowI, PositionYellowJ);
                                  },
                                ),
                                Text('Reset')
                              ]),
                              Column(children: <Widget>[IconButton(
                                icon: const Icon(Icons.arrow_forward),
                                tooltip: 'Next Round',
                                onPressed: isEnabled?() {
                                  _GameRound.value=_GameRound.value+1;
                                  }:null,
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
                              Text("ROUND: " + _GameRound.value.toString() + " ",
                                  style: TextStyle(fontSize: 24.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),

                        ),

                        StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance.collection('Games/anon/Collectibles').doc(_GameRound.value.toString()).snapshots(), //.doc(_auth.currentUser.email).get(),
                            builder: (context, AsyncSnapshot<DocumentSnapshot> collectibles ) {
                              if (collectibles.hasData) {
                                final Color myColorTarget;
                                if(collectibles.data?.data()!["color"] == "green") {
                                  myColorTarget = Colors.green;
                                } else if(collectibles.data?.data()!["color"] == "red") {
                                  myColorTarget = Colors.red;
                                } else if(collectibles.data?.data()!["color"] == "blue") {
                                  myColorTarget = Colors.blue;
                                } else if(collectibles.data?.data()!["color"] == "yellow") {
                                  myColorTarget = Colors.yellow;
                                } else {
                                  myColorTarget = Colors.white;
                                }

                                List<IconData> _iconsTarget = [
                                  Icons.wb_sunny_sharp,
                                  Icons.add_alarm,
                                  Icons.anchor,
                                  Icons.vpn_lock,
                                ];
                               // print(collectibles.data?.data()!["color"]);
                               // print(collectibles.data?.data()!["index"]);

                                return (
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children:<Widget>[
                                        Row(mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            //Container(child:Text(target[0].toString().toUpperCase(),style: TextStyle(fontSize: 24.0,fontWeight:FontWeight.bold)),), //image = getImage(ImageType.bluecirclene);
                                            Text("TARGET: ", style: TextStyle(fontSize: 14.0,fontWeight:FontWeight.bold, color: Colors.red)),
                                            Container(
                                                child: Stack(children: <Widget>[//getImage(ImageType.bluecirclene),
                                                  Icon(
                                                    _iconsTarget[collectibles.data?.data()!["index"]],//Icons.wb_sunny_sharp,
                                                    color: myColorTarget, //Colors.green, //Colors.green,
                                                    size: MediaQuery.of(context).size.width/30, //48.0,
                                                  ),
                                                ])
                                            ),
                                            Text(msg,style: TextStyle(fontSize: 14.0,fontWeight:FontWeight.bold, color: Colors.black))
                                          ] ,
                                        ),
                                      ],
                                    )
                                );
                              } else {return new Text("There is no data");}
                            }
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
                            ValueListenableBuilder(
                            valueListenable: _move,
                            builder: (context, value, child) {
                            return (
                                                Center(child: Text("Moves " + _move.value.toString(),
                                                    style: TextStyle(
                                                        fontSize: 32.0, fontWeight: FontWeight.bold)))
                            );})
                      ],
                    )
            );})
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
    _move.value=_move.value+1;
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
    _move.value=_move.value+1;
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
    _move.value=_move.value+1;

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
    _move.value=_move.value+1;

    await game.doc(gamename).update({'yellowi': i,'yellowj':j,'yellowalti': ialt,'yellowaltj':jalt});
    if(ialt!=i || jalt!=j) {
      await game.doc(gamename).update({'movecount': FieldValue.increment(1)});
    }    //setState(() {});
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
    //_start=10;
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




