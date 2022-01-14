import 'package:flutter/material.dart';
import 'board_square.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  bluecrossne,
  redtrianglese,
  greencirclenw,
  redplayer,
  bluepleyer,
  greenplayer,
  yellowpleyer
}

class GameActivity extends StatefulWidget {
  @override
  _GameActivityState createState() => _GameActivityState();
}

class _GameActivityState extends State<GameActivity> {

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

  int greeni = 0;
  int greenj = 5;

  int yellowi = 0;
  int yellowj = 5;

  int movecount=0;
  // The grid of squares
  List<List<BoardPosition>> boardpos = List.generate(16, (i) {
    return List.generate(16, (j) {
      return BoardPosition();
    });
  });

  @override
  void initState() {
    super.initState();
    _initialiseGame();
  }

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
                    _handleMoveRedAlt(PositionRedI,PositionRedJ,1);
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
                    _handleMoveRedAlt(PositionRedI,PositionRedJ,2);
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
                    _handleMoveRedAlt(PositionRedI,PositionRedJ,3);
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
                    _handleMoveRedAlt(PositionRedI,PositionRedJ,4);
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
                    _handleMoveBlueAlt(PositionBlueI,PositionBlueJ,1);
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
                    _handleMoveBlueAlt(PositionBlueI,PositionBlueJ,2);
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
                    _handleMoveBlueAlt(PositionBlueI,PositionBlueJ,3);
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
                    _handleMoveBlueAlt(PositionBlueI,PositionBlueJ,4);
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
                    _reinitialiseGame(PositionBlueI,PositionBlueJ,PositionRedI,PositionRedJ);
                    movecount=0;
                  },
                  child: CircleAvatar(
                    child: Icon(
                      Icons.restart_alt,
                      color: Colors.black,
                      size: 40.0,
                    ),
                    backgroundColor: Colors.yellowAccent,
                  ),
                )
              ],
            ),
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
              boardpos[PositionGreenAltI][PositionGreenAltJ].redposition = false;
              boardpos[PositionGreenI][PositionGreenJ].redposition = true;

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
              if ((rowNumber == 4) && (columnNumber == 3)) {
                image = getImage(ImageType.redtrianglese);
              }
              if ((rowNumber == 8) && (columnNumber == 2)) {
                image = getImage(ImageType.greencirclenw);
              }
              if (boardpos[rowNumber][columnNumber].blueposition) {
                return InkWell(
                  onTap: () {
                    //_handleMoveBlue(rowNumber, columnNumber, 4);
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
                        //_handleMoveRed(rowNumber, columnNumber, 3);
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
                    //_handleMoveRed(rowNumber, columnNumber, 3);
                  },
                  splashColor: Colors.grey,
                  child: Container(
                      color: Colors.grey,
                      child: Stack(children: <Widget>[image,
                        Image.asset('assets/images/greenplayer.png'),
                      ])
                  ),
                );
              }else {
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
              stream: FirebaseFirestore.instance.collection('Games/TestGame/Players').snapshots(), //.doc(_auth.currentUser.email).get(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot1 ) {
                if (snapshot1.hasData) {
                  var data = [];
                  List<String> players = [];
                  List<String> bets = [];
                  //List<List<Players>> players;
                  //List<Map<String, dynamic>> send=[] ;
                  //snapshot1.data?.docs.forEach((f) => print(f.id));
                  snapshot1.data?.docs.forEach((f) => bets.add(f.data()["bet"].toString()));
                  snapshot1.data?.docs.forEach((f) => players.add(f.id.toString()));
                  print(bets[1]);
                  print(players[1]);
                  print(players.length);
                  return (ListView.builder(
                            shrinkWrap: true,
                            itemCount: players.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text('${players[index].length} Player: ${players[index].padRight(30,' ')}Bet:${bets[index]}');

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
    boardpos[7][8].obstaclewest = true;
    boardpos[8][8].obstaclewest = true;
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

    //Reflectors
    boardpos[4][4].obstaclewest = true;
    boardpos[4][3].obstacleeast = true;
    boardpos[4][3].obstaclesouth = true;
    boardpos[7][2].obstaclesouth = true;
    boardpos[8][2].obstaclenorth = true;
    boardpos[8][2].obstaclewest = true;
    boardpos[8][1].obstacleeast = true;
    //board[10][3].red = true;
    // Check bombs around and assign numbers

    setState(() {});
  }


  Future _reinitialiseGame(int PositionBlueI, int PositionBlueJ, int PositionRedI,int PositionRedJ) async {
    CollectionReference game = FirebaseFirestore.instance.collection('Games');


    boardpos[PositionBlueI][PositionBlueJ].blueposition = false;
    boardpos[PositionRedI][PositionRedJ].redposition = false;
    //MIDDLE
    boardpos[6][7].obstaclesouth = true;
    boardpos[6][8].obstaclesouth = true;
    boardpos[7][8].obstaclewest = true;
    boardpos[8][8].obstaclewest = true;
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

    //Reflectors
    boardpos[4][4].obstaclewest = true;
    boardpos[4][3].obstacleeast = true;
    boardpos[4][3].obstaclesouth = true;
    boardpos[7][2].obstaclesouth = true;
    boardpos[8][2].obstaclenorth = true;
    boardpos[8][2].obstaclewest = true;
    boardpos[8][1].obstacleeast = true;
    //board[10][3].red = true;
    // Check bombs around and assign numbers

    boardpos[redi][redj].redposition = false;      // print(snapshot.connectionState);
    boardpos[bluei][bluej].blueposition = false;      // print(snapshot.connectionState);

    await game.doc("TestGame").update({'redalti': PositionRedI,'redaltj':PositionRedJ});
    await game.doc("TestGame").update({'bluealti': PositionBlueI,'bluealtj':PositionBlueJ});
    await game.doc("TestGame").update({'bluei': 4,'bluej':4});
    await game.doc("TestGame").update({'redi': 3,'redj':3});
    //setState(() {});
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
      if (t==1) {i--;}
      if (t==3) {i++;}
      if (t==4) {j--;}
      if (t==2) {j++;}
    }
    boardpos[i][j].redposition = true;
    redi=i;
    redj=j;
    await game.doc("TestGame").update({'redi': i,'redj':j,'redalti': ialt,'redaltj':jalt});
    movecount++;
    print('MoveCount ${movecount}');
    setState(() {});
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
      if (t==1) {i--;}
      if (t==3) {i++;}
      if (t==4) {j--;}
      if (t==2) {j++;}
    }
    boardpos[i][j].blueposition = true;
    bluei=i;
    bluej=j;

    await game.doc("TestGame").update({'bluei': i,'bluej':j,'bluealti': ialt,'bluealtj':jalt});
    movecount++;
    print('MoveCount ${movecount}');
    setState(() {});
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
      if (t==1) {i--;}
      if (t==3) {i++;}
      if (t==4) {j--;}
      if (t==2) {j++;}
    }
    boardpos[i][j].greenposition = true;
    greeni=i;
    greenj=j;

    await game.doc("TestGame").update({'greeni': i,'greenj':j,'greenalti': ialt,'greenaltj':jalt});
    movecount++;
    print('MoveCount ${movecount}');
    setState(() {});
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
      case ImageType.redtrianglese:
        return Image.asset('assets/images/RedTriangleSouthEast.png');
      case ImageType.greencirclenw:
        return Image.asset('assets/images/GreenCircleNorthWest.png');
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
}