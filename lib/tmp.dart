
class LandingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return SignInPage();
          }
          return GameActivity(); //FirstScreen();
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

class SignInPage extends StatelessWidget {

  final username = TextEditingController();
  final password = TextEditingController();

  void _showDialogNT(BuildContext context, String errormessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("ERROR"),
          content: new Text(errormessage),
        );
      },
    );
  }

  Future _signIn(context, String uid, String pwd) async {
    try {
      //await FirebaseAuth.instance.signInAnonymously();
//      await FirebaseAuth.instance.signInWithEmailAndPassword(email: "solowswan@gmail.com", password: "123123qweqwe");
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: uid, password: pwd);

    } catch (e) {
      print(e); // TODO: show dialog with error
      _showDialogNT(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ComicLib')
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


      body: Center(
        child: Column(
            children: [
              SizedBox(
                width: 300,
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter E-Mail'
                  ),
                  controller: username,
                ),
                //_pController.jumpToPage(200)
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter password'
                  ),
                  controller: password,
                ),
                //_pController.jumpToPage(200)
              ),
              ElevatedButton(
                child: Text('Login'),
                onPressed: () {_signIn(context, username.text,password.text);},
              ),
              //ElevatedButton(
              //  child: Text('Create Account'),
              //  onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (ctxt) => new SignUp()));},
              //),
            ]
        ),
      ),
    );
  }
}



void _handleMoveRed(int i, int j, int t) {
  boardpos[i][j].redposition = false;
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
  setState(() {});
}

void _handleMoveBlue(int i, int j, int t) {
  boardpos[i][j].blueposition = false;
  while((i<15 && j<15 && i>0 && j>=0)) {
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
  setState(() {});
}


StreamBuilder<QuerySnapshot>(
stream: FirebaseFirestore.instance.collection('Games/TestGame/Players').snapshots(), //.doc(_auth.currentUser.email).get(),
builder: (context, AsyncSnapshot<QuerySnapshot> snapshot1 ) {
if (snapshot1.hasData) {
var data = [];
List<String> players = [];
List<String> bets = [];
//List<Map<String, dynamic>> send=[] ;
//snapshot1.data?.docs.forEach((f) => print(f.id));
snapshot1.data?.docs.forEach((f) => bets.add(f.data()["bet"].toString()));
snapshot1.data?.docs.forEach((f) => players.add(f.id.toString()));
print(bets[1]);
print(players[1]);
print(players.length);
return (new Row( children: <Widget>[
Expanded(
child:ListView.builder(
padding: const EdgeInsets.all(8),
itemCount: players.length,
itemBuilder: (BuildContext context, int index) {
return Container(
height: 50,
color: Colors.red,
child: Center(child: Text('Entry ${players[index]}')),
);
}
)
)
]
)
);
} else {return new Text("There is no data");}
//return new ListView(children: getExpenseItems(snapshot1));
}
),


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

Center(
child: Column(
children: [
Expanded(
child: TextFormField(
decoration: const InputDecoration(
border: UnderlineInputBorder(),
hintText: 'Enter E-Mail'
),
controller: username,
),
//_pController.jumpToPage(200)
),
Expanded(
child: TextFormField(
obscureText: true,
decoration: const InputDecoration(
border: UnderlineInputBorder(),
hintText: 'Enter password'
),
controller: password,
),
//_pController.jumpToPage(200)
),
ElevatedButton(
child: Text('Login'),
onPressed: () {_signIn(context, username.text,password.text);},
),
ElevatedButton(
child: Text('Sign up'),
onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (ctxt) => new SignUp()));},
),
]
),
),






















Center(
child: Column(
children: [
SizedBox(
width: 300,
child: TextField(
decoration: InputDecoration(
border: OutlineInputBorder(),
hintText: 'Enter E-Mail'
),
controller: email,
),
//_pController.jumpToPage(200)
),
SizedBox(
width: 300,
child: TextField(
obscureText: true,
decoration: InputDecoration(
border: OutlineInputBorder(),
hintText: 'Enter password'
),
controller: password1,
),
//_pController.jumpToPage(200)
),
SizedBox(
width: 300,
child: TextField(
obscureText: true,
decoration: InputDecoration(
border: OutlineInputBorder(),
hintText: 'Verify password'
),
controller: password2,
),
//_pController.jumpToPage(200)
),
ElevatedButton(
child: Text('Create Account'),
onPressed: () {_signup(context, email.text,password1.text,password2.text);},
),
]
),
),




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




[DataRow(cells: [DataCell(Text(game_name[index])),
DataCell(Text(game_round[index])),
DataCell(Text(game_host[index])),
DataCell(TextButton(
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
),)])]


Expanded(child: TextField(
focusNode: myFocusNode = FocusNode(),
decoration: InputDecoration(
constraints:BoxConstraints(maxHeight: 30),
border: OutlineInputBorder(),
hintText: 'Enter your BET'
),
controller: bet,
),
),