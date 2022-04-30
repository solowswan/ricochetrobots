import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ricochetrobots/main.dart';
import 'board_square.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttericon/typicons_icons.dart';

class singleplayer_debugging extends StatelessWidget {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<DataRow> _rowList = [
    DataRow(cells: <DataCell>[
      DataCell(Text('1')),
      DataCell(Text('0')),
      DataCell(Text('Start')),
      DataCell(Text('0')),
    ]),
  ];

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

  ValueNotifier<int> _PositionGreenI = ValueNotifier<int>(0);
  ValueNotifier<int> _PositionGreenJ = ValueNotifier<int>(0);
  ValueNotifier<int> _PositionRedI = ValueNotifier<int>(0);
  ValueNotifier<int> _PositionRedJ = ValueNotifier<int>(0);
  ValueNotifier<int> _PositionBlueI = ValueNotifier<int>(0);
  ValueNotifier<int> _PositionBlueJ = ValueNotifier<int>(0);
  ValueNotifier<int> _PositionYellowI = ValueNotifier<int>(0);
  ValueNotifier<int> _PositionYellowJ = ValueNotifier<int>(0);

  int PositionBlueI = 1;
  int PositionBlueAltI = 2;
  int PositionBlueJ=14;
  int PositionBlueAltJ = 2;

  int PositionRedI = 1;
  int PositionRedAltI = 3;
  int PositionRedJ=1;
  int PositionRedAltJ = 3;

  int PositionGreenI = 14;
  int PositionGreenAltI = 2;
  int PositionGreenJ=1;
  int PositionGreenAltJ = 2;

  int PositionYellowI = 14;
  int PositionYellowAltI = 13;
  int PositionYellowJ=14;
  int PositionYellowAltJ = 13;
  int movecount = 1;

  String lowestbidder = "asd";

  int predicti = 0;
  int lowestbid = 1;
  bool isEnabled = true;

  String msg="";
  String msg1="";
  String msg2="";

  late FocusNode myFocusNode;

  ValueNotifier<int> _switch = ValueNotifier<int>(1);
  ValueNotifier<int> _move = ValueNotifier<int>(0);
  ValueNotifier<int> _GameRound = ValueNotifier<int>(1);

  List<List<BoardPosition>> boardpos = List.generate(16, (i) {
    return List.generate(16, (j) {
      return BoardPosition();
    });
  });

  List<RoundResults> roundres = List.generate(3, (i) {
      return RoundResults();
  });

  List<List<RoundMoves>> roundmoves = List.generate(3, (i) {
    return List.generate(100, (j) {
      return RoundMoves();
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
                          constraints: BoxConstraints(maxWidth: 5),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("ROUND: " + _GameRound.value.toString() + " ",
                                  style: TextStyle(fontSize: 24.0,
                                      fontWeight: FontWeight.bold)),
                              Text('NextRound'),
                              IconButton(
                                icon: const Icon(Icons.arrow_forward),
                                tooltip: 'Next Round',
                                onPressed: isEnabled?() {
                                  roundres[_GameRound.value-1].moves=_move.value;
                                  _GameRound.value=_GameRound.value+1;
                                  _move.value=0;
                                }:null,
                              )
                            ],
                          ),

                        ),
    ValueListenableBuilder(
    valueListenable: _PositionBlueJ,
    builder: (context, value, child) {
    return (
    ValueListenableBuilder(
    valueListenable: _PositionBlueI,
    builder: (context, value, child) {
    return (
    ValueListenableBuilder(
    valueListenable: _PositionYellowJ,
    builder: (context, value, child) {
    return (
    ValueListenableBuilder(
    valueListenable: _PositionYellowI,
    builder: (context, value, child) {
    return (
    ValueListenableBuilder(
    valueListenable: _PositionRedJ,
    builder: (context, value, child) {
    return (
    ValueListenableBuilder(
    valueListenable: _PositionRedI,
    builder: (context, value, child) {
    return (
            ValueListenableBuilder(
            valueListenable: _PositionGreenJ,
            builder: (context, value, child) {
            return (
            ValueListenableBuilder(
            valueListenable: _PositionGreenI,
            builder: (context, value, child) {
            return (

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
                                  myColorTarget = Colors.black;
                                } else {
                                  myColorTarget = Colors.white;
                                }

                                List<IconData> _iconsTarget = [
                                  Icons.wb_sunny_sharp,
                                  Icons.add_alarm,
                                  Icons.anchor,
                                  Icons.vpn_lock,
                                ];
                                print(collectibles.data?.data()!["name"]);
                                print(_PositionGreenI.value);
                                print(_PositionGreenJ.value);
                                print(boardpos[PositionGreenI][PositionGreenJ].collectible);

                                if(boardpos[PositionGreenI][PositionGreenJ].collectible==collectibles.data?.data()!["name"])
                                {
                                  //msg="You managed to finish Round "+_GameRound.value.toString()+" in "+_move.value.toString() +" moves!";
                                  msg1="You found";
                                  msg2="in "+_move.value.toString() +" moves";
                                } else if(boardpos[PositionRedI][PositionRedJ].collectible==collectibles.data?.data()!["name"])
                                {
                                  //msg="You managed to finish Round "+_GameRound.value.toString()+" in "+_move.value.toString() +" moves!";
                                  msg1="You found";
                                  msg2="in "+_move.value.toString() +" moves";
                                } else if(boardpos[PositionBlueI][PositionBlueJ].collectible==collectibles.data?.data()!["name"])
                                {
                                  //msg="You managed to finish Round "+_GameRound.value.toString()+" in "+_move.value.toString() +" moves!";
                                  msg1="You found";
                                  msg2="in "+_move.value.toString() +" moves";
                                } else if(boardpos[PositionYellowI][PositionYellowJ].collectible==collectibles.data?.data()!["name"])
                                {
                                  msg1="You found";
                                  msg2="in "+_move.value.toString() +" moves";
                                } else {
                                  msg1="Find";
                                  msg2="with minumum moves";
                                }
                                  return (
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(msg1, style: TextStyle(
                                                  fontSize: 24.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black))
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text("", style: TextStyle(
                                                  fontSize: 24.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red)),
                                              Container(
                                                  child: Stack(
                                                      children: <Widget>[
                                                        //getImage(ImageType.bluecirclene),
                                                        Icon(
                                                          _iconsTarget[collectibles.data?.data()!["index"]],
                                                          //Icons.wb_sunny_sharp,
                                                          color: myColorTarget,
                                                          //Colors.green, //Colors.green,
                                                          size: MediaQuery.of(context).size.width / 20, //48.0,
                                                        ),
                                                      ])
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(msg2, style: TextStyle(
                                                  fontSize: 24.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black))
                                            ],
                                          ),
                                        ],
                                      )
                                  );
                              } else {return new Text("There is no data");}

                            }
                        )

                        );})
            );})
            );})
    );})
            );})
    );})
    );})
    );}),
                        Center(child:
                        // The grid of squares
                        SizedBox(
                            width: 800,
                            child:
                            ValueListenableBuilder(
                                valueListenable: _switch,
                                builder: (context, value, child) {
                                  return (

                                  StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance.collection('Games/anon/Collectibles').doc(_GameRound.value.toString()).snapshots(), //.doc(_auth.currentUser.email).get(),
                                  builder: (context, AsyncSnapshot<DocumentSnapshot> collectibles ) {
                                    if (collectibles.hasData) {
                                      boardpos[collectibles.data?.data()!["i"]][collectibles.data?.data()!["j"]].collectible = collectibles.data?.data()!["name"];
                                    }
                                    return(

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
                                            //if(PositionBlueI<15){boardpos[PositionBlueI+1][PositionBlueJ].downarrow=true;}
                                            //if(PositionBlueJ<15){boardpos[PositionBlueI][PositionBlueJ+1].rightarrow=true;}
                                            //if(PositionBlueI>0){boardpos[PositionBlueI-1][PositionBlueJ].uparrow=true;}
                                            //if(PositionBlueJ>0){boardpos[PositionBlueI][PositionBlueJ-1].leftarrow=true;}
                                            if(PositionBlueI>0){  for(var counter = PositionBlueI-1; counter >= ((_predictMoveBlueAlt(PositionBlueI, PositionBlueJ, 1))/16).floor() && counter>=0; counter--)  { boardpos[counter][PositionBlueJ].uparrow=true;  } }
                                            if(PositionBlueJ<15){ for(var counter = PositionBlueJ+1; counter <= (_predictMoveBlueAlt(PositionBlueI, PositionBlueJ, 2))%16         && counter<=15; counter++)  {boardpos[PositionBlueI][counter].rightarrow=true;  } }
                                            if(PositionBlueI<15){ for(var counter = PositionBlueI+1; counter <= ((_predictMoveBlueAlt(PositionBlueI, PositionBlueJ, 3))/16).floor() && counter<=15; counter++)  {boardpos[counter][PositionBlueJ].downarrow=true;  } }
                                            if(PositionBlueJ>0){  for(var counter = PositionBlueJ-1; counter >= _predictMoveBlueAlt(PositionBlueI, PositionBlueJ, 4)%16         && counter>=0; counter--)  { boardpos[PositionBlueI][counter].leftarrow=true;  } }

                                          } else if(_switch.value==-2) {
                                            //print( _predictMoveRedAlt(PositionRedI, PositionRedJ, 2));
                                            //print( _predictMoveRedAlt(PositionRedI, PositionRedJ, 2)%16 );
                                            //print(boardpos[PositionRedI][PositionRedJ+1].obstacleeast);
                                            //if(PositionRedI>0){boardpos[PositionRedI-1][PositionRedJ].uparrow=true;}
                                            //if(PositionRedJ<15){boardpos[PositionRedI][PositionRedJ+1].rightarrow=true;}
                                            //if(PositionRedI<15){boardpos[PositionRedI+1][PositionRedJ].downarrow=true;}
                                            //if(PositionRedJ>0){boardpos[PositionRedI][PositionRedJ-1].leftarrow=true;}
                                            if(PositionRedI>0){  for(var counter = PositionRedI-1; counter >= ((_predictMoveRedAlt(PositionRedI, PositionRedJ, 1))/16).floor() && counter>=0; counter--)  { boardpos[counter][PositionRedJ].uparrow=true;  } }
                                            if(PositionRedJ<15){ for(var counter = PositionRedJ+1; counter <= (_predictMoveRedAlt(PositionRedI, PositionRedJ, 2))%16         && counter<=15; counter++)  {boardpos[PositionRedI][counter].rightarrow=true;  } }
                                            if(PositionRedI<15){ for(var counter = PositionRedI+1; counter <= ((_predictMoveRedAlt(PositionRedI, PositionRedJ, 3))/16).floor() && counter<=15; counter++)  {boardpos[counter][PositionRedJ].downarrow=true;  } }
                                            if(PositionRedJ>0){  for(var counter = PositionRedJ-1; counter >= _predictMoveRedAlt(PositionRedI, PositionRedJ, 4)%16         && counter>=0; counter--)  { boardpos[PositionRedI][counter].leftarrow=true;  } }


                                          }else if(_switch.value==-3) {
                                            //if(PositionGreenI<15){boardpos[PositionGreenI+1][PositionGreenJ].downarrow=true;}
                                            //if(PositionGreenJ<15){boardpos[PositionGreenI][PositionGreenJ+1].rightarrow=true;}
                                            //if(PositionGreenI>0){boardpos[PositionGreenI-1][PositionGreenJ].uparrow=true;}
                                            //if(PositionGreenJ>0){boardpos[PositionGreenI][PositionGreenJ-1].leftarrow=true;}
                                            if(PositionGreenI>0){  for(var counter = PositionGreenI-1; counter >= ((_predictMoveGreenAlt(PositionGreenI, PositionGreenJ, 1))/16).floor() && counter>=0; counter--)  { boardpos[counter][PositionGreenJ].uparrow=true;  } }
                                            if(PositionGreenJ<15){ for(var counter = PositionGreenJ+1; counter <= (_predictMoveGreenAlt(PositionGreenI, PositionGreenJ, 2))%16         && counter<=15; counter++)  {boardpos[PositionGreenI][counter].rightarrow=true;  } }
                                            if(PositionGreenI<15){ for(var counter = PositionGreenI+1; counter <= ((_predictMoveGreenAlt(PositionGreenI, PositionGreenJ, 3))/16).floor() && counter<=15; counter++)  {boardpos[counter][PositionGreenJ].downarrow=true;  } }
                                            if(PositionGreenJ>0){  for(var counter = PositionGreenJ-1; counter >= _predictMoveGreenAlt(PositionGreenI, PositionGreenJ, 4)%16         && counter>=0; counter--)  { boardpos[PositionGreenI][counter].leftarrow=true;  } }

                                          }else if(_switch.value==-4) {
                                            //if(PositionYellowI<15){boardpos[PositionYellowI+1][PositionYellowJ].downarrow=true;}
                                            //if(PositionYellowJ<15){boardpos[PositionYellowI][PositionYellowJ+1].rightarrow=true;}
                                            //if(PositionYellowI>0){boardpos[PositionYellowI-1][PositionYellowJ].uparrow=true;}
                                            //if(PositionYellowJ>0){boardpos[PositionYellowI][PositionYellowJ-1].leftarrow=true;}
                                            if(PositionYellowI>0){  for(var counter = PositionYellowI-1; counter >= ((_predictMoveYellowAlt(PositionYellowI, PositionYellowJ, 1))/16).floor() && counter>=0; counter--)  { boardpos[counter][PositionYellowJ].uparrow=true;  } }
                                            if(PositionRedJ<15){ for(var counter = PositionYellowJ+1; counter <= (_predictMoveYellowAlt(PositionYellowI, PositionYellowJ, 2))%16         && counter<=15; counter++)  {boardpos[PositionYellowI][counter].rightarrow=true;  } }
                                            if(PositionYellowI<15){ for(var counter = PositionYellowI+1; counter <= ((_predictMoveYellowAlt(PositionYellowI, PositionYellowJ, 3))/16).floor() && counter<=15; counter++)  {boardpos[counter][PositionYellowJ].downarrow=true;  } }
                                            if(PositionRedJ>0){  for(var counter = PositionYellowJ-1; counter >= _predictMoveYellowAlt(PositionYellowI, PositionYellowJ, 4)%16         && counter>=0; counter--)  { boardpos[PositionYellowI][counter].leftarrow=true;  } }

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
                                            topwidth=2;
                                          }
                                          if (boardpos[rowNumber][columnNumber].obstaclesouth) {
                                            bottomwidth=2;
                                          }
                                          if (boardpos[rowNumber][columnNumber].obstacleeast) {
                                            rightwidth=2;
                                          }
                                          if (boardpos[rowNumber][columnNumber].obstaclewest) {
                                            leftwidth=2;
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
                                            myColor = Colors.black;
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
                                            myColor = Colors.black;
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
                                            myColor = Colors.black;
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
                                            myColor = Colors.black;
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
                                                  predicti=_predictMoveRedAlt(PositionRedI, PositionRedJ,4);
                                                  print(predicti);
                                                  print((predicti/15).floor());
                                                  print(predicti%15);
                                                } else if(_switch.value==3|| _switch.value==-3) {
                                                  _handleMoveGreenAlt(_auth.currentUser?.email, PositionGreenI, PositionGreenJ, 2);
                                                } else if(_switch.value==4|| _switch.value==-4) {
                                                  _handleMoveYellowAlt(_auth.currentUser?.email, PositionYellowI, PositionYellowJ, 2);

                                                }
                                                //   };

                                              },
                                                splashColor: Colors.black12,
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
                                                    color: Colors.black12,
                                                  ),
                                                ),
                                                  Container(
                                                      color: Colors.black12,
                                                      child: Text("")
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
                                                  predicti=_predictMoveRedAlt(PositionRedI, PositionRedJ,1);
                                                  print(predicti);
                                                  print((predicti/15).floor());
                                                  print(predicti%15);
                                                } else if(_switch.value==3|| _switch.value==-3) {
                                                  _handleMoveGreenAlt(_auth.currentUser?.email, PositionGreenI, PositionGreenJ, 1);
                                                } else if(_switch.value==4|| _switch.value==-4) {
                                                  _handleMoveYellowAlt(_auth.currentUser?.email, PositionYellowI, PositionYellowJ, 1);
                                                }
                                                //   };
                                              },
                                                splashColor: Colors.black12,
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
                                                    color: Colors.black12,
                                                  ),
                                                ),
                                                  Container(
                                                      color: Colors.black12,
                                                      child: Text("")
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
                                                  predicti=_predictMoveRedAlt(PositionRedI, PositionRedJ,4);
                                                  print(predicti);
                                                  print((predicti/15).floor());
                                                  print(predicti%15);
                                                } else if(_switch.value==3|| _switch.value==-3) {
                                                  _handleMoveGreenAlt(_auth.currentUser?.email, PositionGreenI, PositionGreenJ, 4);
                                                } else if(_switch.value==4|| _switch.value==-4) {
                                                  _handleMoveYellowAlt(_auth.currentUser?.email, PositionYellowI, PositionYellowJ, 4);
                                                }
                                                //   };
                                              },
                                                splashColor: Colors.black12,
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
                                                    color: Colors.black12,
                                                  ),
                                                ),
                                                  Container(
                                                      color: Colors.black12,
                                                      child: Text("")
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
                                                  predicti=_predictMoveRedAlt(PositionRedI, PositionRedJ,4);
                                                  print(predicti);
                                                  print((predicti/15).floor());
                                                  print(predicti%15);
                                                } else if(_switch.value==3|| _switch.value==-3) {
                                                  _handleMoveGreenAlt(_auth.currentUser?.email, PositionGreenI, PositionGreenJ, 3);
                                                } else if(_switch.value==4|| _switch.value==-4) {
                                                  _handleMoveYellowAlt(_auth.currentUser?.email, PositionYellowI, PositionYellowJ, 3);
                                                }
                                                //   };
                                              },
                                              splashColor: Colors.black12,
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
                                                        color: Colors.black12,
                                                      ),
                                                    ),
                                                    Container(
                                                        color: Colors.black12,
                                                        child: Text("")
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
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                  Container(
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: Icon(
                                                          Typicons.user,//Icons.wb_sunny_sharp,
                                                          color: Colors.blue, //Colors.green,
                                                          size: MediaQuery.of(context).size.width/20, //48.0,
                                                        ),
                                                      )
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
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                  Container(
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: Icon(
                                                          Typicons.user,//Icons.wb_sunny_sharp,
                                                          color: Colors.red, //Colors.green,
                                                          size: MediaQuery.of(context).size.width/20, //48.0,
                                                        ),
                                                      )
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
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                Container(
                                                    child: Align(
                                                      alignment: Alignment.center,
                                                      child: Icon(
                                                        Typicons.user,//Icons.wb_sunny_sharp,
                                                        color: Colors.green, //Colors.green,
                                                        size: MediaQuery.of(context).size.width/20, //48.0,
                                                      ),
                                                    )
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
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                  Container(
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: Icon(
                                                          Typicons.user,//Icons.wb_sunny_sharp,
                                                          color: Colors.black, //Colors.green,
                                                          size: MediaQuery.of(context).size.width/20, //48.0,
                                                        ),
                                                      )
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
                                                    color: Colors.black12,
                                                  ),
                                                ),
                                                  Container(
                                                      color: Colors.black12,
                                                      child: Text("")
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
                                  );})
                                  );
                                })
                        ),
                        ),




                            ValueListenableBuilder(
                            valueListenable: _move,
                            builder: (context, value, child) {
                            return (Column( children: <Widget>[ if(true)
                                    Center(child: Text("Moves " + _move.value.toString(),style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold)),),
                             // Center(child: Text("Moves " + _GameRound.value.toString(), style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold)),),
                              if(_GameRound.value==1) Center(child: Text("Round 1: Moves " + _move.value.toString(),style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.normal)),), _GameRound.value>1 ? Center(child: Text("Round 1: Moves " + roundres[0].moves.toString(),style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.normal)),) : Text(""),
                              if(_GameRound.value==2) Center(child: Text("Round 2: Moves " + _move.value.toString(),style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.normal)),), _GameRound.value>2 ? Center(child: Text("Round 2: Moves " + roundres[1].moves.toString(),style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.normal)),) : Text(""),
                              if(_GameRound.value==3) Center(child: Text("Round 3: Moves " + _move.value.toString(),style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.normal)),), _GameRound.value>3 ? Center(child: Text("Round 3: Moves " + roundres[2].moves.toString(),style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.normal)),) : Text(""),

                              GridView.builder(
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
                                        DataColumn(label: Text('ROUND', style: TextStyle(fontWeight: FontWeight.bold),)),
                                        DataColumn(label: Text('MOVE', style: TextStyle(fontWeight: FontWeight.bold),)),
                                        DataColumn(label: Text('COLOR', style: TextStyle(fontWeight: FontWeight.bold),)),
                                        DataColumn(label: Text('FROM/TO',style: TextStyle(fontWeight: FontWeight.bold),)),
                                      ],
                                      rows: _rowList,
                                    );
                                  }
                              )

                              ])
                            );}),

                      ],
                    )





            );})









                );

  }
  // Initialises all lists
  Future _initialiseGame() async {

    StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('/Games/anon/board /obstacles').orderBy('bet', descending: false).snapshots(), //.doc(_auth.currentUser.email).get(),
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
    );


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

    //boardpos[1][13].collectible = "RedSaturn";
    //boardpos[2][5].collectible = "BlueCross";
    //boardpos[2][9].collectible = "BlueTriangle";
    //boardpos[4][2].collectible = "GreenCircle";
    //boardpos[5][7].collectible = "RedTriangle";
    //boardpos[5][14].collectible = "GreenCross";
    //boardpos[6][1].collectible = "YellowSaturn";
    //boardpos[6][11].collectible = "YellowCircle";
    //boardpos[9][3].collectible = "YellowCross";
    //boardpos[10][13].collectible = "RedCross";
    //boardpos[11][1].collectible = "RedCircle";
    //boardpos[11][10].collectible = "GreenSaturn";
    // boardpos[12][6].collectible = "BlueSaturn";
    //boardpos[12][14].collectible = "YellowTriangle";
    // boardpos[14][2].collectible = "GreenTriangle";
    // boardpos[14][9].collectible = "BlueCircle";
  }

  _predictMoveBlueAlt(int i, int j, int t) {
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
    return(i*16+j);
  }

   _predictMoveRedAlt(int i, int j, int t) {
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
    return(i*16+j);
  }

  _predictMoveGreenAlt(int i, int j, int t) {
    while(1==1) {
      if (boardpos[i][j].obstaclenorth && t==1) {break;}
      if (boardpos[i][j].obstacleeast && t==2) {break;}
      if (boardpos[i][j].obstaclesouth && t==3) {break;}
      if (boardpos[i][j].obstaclewest && t==4) {break;}
      if (i>0 && boardpos[i-1][j].blueposition && t==1) {break;}
      if (i<15 && boardpos[i+1][j].blueposition && t==3) {break;}
      if (j>0 && boardpos[i][j-1].blueposition && t==4) {break;}
      if (j<15 && boardpos[i][j+1].blueposition && t==2) {break;}
      if (i>0 && boardpos[i-1][j].redposition && t==1) {break;}
      if (i<15 && boardpos[i+1][j].redposition && t==3) {break;}
      if (j>0 && boardpos[i][j-1].redposition && t==4) {break;}
      if (j<15 && boardpos[i][j+1].redposition && t==2) {break;}
      if (i>0 && boardpos[i-1][j].yellowposition && t==1) {break;}
      if (i<15 && boardpos[i+1][j].yellowposition && t==3) {break;}
      if (j>0 && boardpos[i][j-1].yellowposition && t==4) {break;}
      if (j<15 && boardpos[i][j+1].yellowposition && t==2) {break;}
      if (t==1) {i--;}
      if (t==3) {i++;}
      if (t==4) {j--;}
      if (t==2) {j++;}
    }
    return(i*16+j);
  }

  _predictMoveYellowAlt(int i, int j, int t) {
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
      if (i>0 && boardpos[i-1][j].redposition && t==1) {break;}
      if (i<15 && boardpos[i+1][j].redposition && t==3) {break;}
      if (j>0 && boardpos[i][j-1].redposition && t==4) {break;}
      if (j<15 && boardpos[i][j+1].redposition && t==2) {break;}
      if (t==1) {i--;}
      if (t==3) {i++;}
      if (t==4) {j--;}
      if (t==2) {j++;}
    }
    return(i*16+j);
  }



  Future _handleMoveRedAlt(String? gamename, int i, int j, int t) async {

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
    _PositionRedI.value=i;
    _PositionRedJ.value=j;

    _rowList.add(DataRow(cells: <DataCell>[
      DataCell(Text(_GameRound.value.toString())),
      DataCell(Text(_move.value.toString())),
      DataCell(Text("Red")),
      DataCell(Text(((ialt)*16+(jalt+1)).toString() + "-" + ((i)*16+(j+1)).toString())),
    ]));
  }

  Future _handleMoveBlueAlt(String? gamename, int i, int j, int t) async {

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
    _PositionBlueI.value=i;
    _PositionBlueJ.value=j;

    _rowList.add(DataRow(cells: <DataCell>[
      DataCell(Text(_GameRound.value.toString())),
      DataCell(Text(_move.value.toString())),
      DataCell(Text("Blue")),
      DataCell(Text(((ialt)*16+(jalt+1)).toString() + "-" + ((i)*16+(j+1)).toString())),
    ]));

   // setState(() {});
  }

  Future _handleMoveGreenAlt(String? gamename, int i, int j, int t) async {

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
    _PositionGreenI.value=i;
    _PositionGreenJ.value=j;

    _rowList.add(DataRow(cells: <DataCell>[
      DataCell(Text(_GameRound.value.toString())),
      DataCell(Text(_move.value.toString())),
      DataCell(Text("Green")),
      DataCell(Text(((ialt)*16+(jalt+1)).toString() + "-" + ((i)*16+(j+1)).toString())),
    ]));


  }

  Future _handleMoveYellowAlt(String? gamename, int i, int j, int t) async {

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
    _PositionYellowI.value=i;
    _PositionYellowJ.value=j;

    _rowList.add(DataRow(cells: <DataCell>[
      DataCell(Text(_GameRound.value.toString())),
      DataCell(Text(_move.value.toString())),
      DataCell(Text("Black")),
      DataCell(Text(((ialt)*16+(jalt+1)).toString() + "-" + ((i)*16+(j+1)).toString())),
    ]));

  }


}




