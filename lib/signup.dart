//c:\src\flutter\bin\flutter run -d chrome --no-sound-null-safety --web-renderer=html
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart'; //as firebase_storage;
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class SignUp extends StatefulWidget {
  //SignUp({Key key, this.title}) : super(key: key);

//  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SignUp> {

  TextEditingController email = TextEditingController();
  TextEditingController password1 = TextEditingController();
  TextEditingController password2 = TextEditingController();

  final _formKey = GlobalKey<FormState>();


  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
  }


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

  void _showDialogSC(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("User account created successfully"),
          //content: new Text('Press continue to go back to SignIn'),
          actions: <Widget>[
            new ElevatedButton(
              child: new Text("Continue"),
              onPressed: () {
                //   _signOut();
                Navigator.push(context, MaterialPageRoute(builder: (ctxt) => new MyApp()));
              },
            ),
          ],
        );
      },
    );
  }

  Future _signup(context, String uid, String pwd1,String pwd2) async {


    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      CollectionReference users = FirebaseFirestore.instance.collection('Users');

      return users.doc(uid)
          .set({
        'EMail': uid,
        'Created': DateTime.now()
      })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    Future<void> createGame() async {
      // Call the games's CollectionReference to add a new game
      CollectionReference games = FirebaseFirestore.instance.collection('Games');

      await games.doc(uid).set({
        'Host': uid,
        'Round': 1,
        'Timer': 10,
        'timer': 10,
        'bluealti': 4,
        'blueorigi': 4,
        'bluei': 4,
        'bluealtj': 4,
        'blueorigj': 4,
        'bluej': 4,
        'redalti': 3,
        'redorigi': 3,
        'redi': 3,
        'redaltj': 3,
        'redorigj': 3,
        'redj': 3,
        'greenalti': 13,
        'greenorigi': 13,
        'greeni': 13,
        'greenaltj': 0,
        'greenorigj': 0,
        'greenj': 0,
        'yellowalti': 13,
        'yelloworigi': 13,
        'yellowi': 13,
        'yellowaltj': 13,
        'yelloworigj': 13,
        'yellowj': 13,
        'lowestbid': 99,
        'lowestbidder': '',
        'movecount': 0,
        'winner':'',
        'firstbet': DateTime.now()
      });
      await games.doc(uid).collection("Rounds").doc("1").set({'Start': DateTime.now()});
      await games.doc(uid).collection("Rounds").doc("2").set({'Start': DateTime.now()});
      await games.doc(uid).collection("Rounds").doc("3").set({'Start': DateTime.now()});
      await games.doc(uid).collection("Rounds").doc("4").set({'Start': DateTime.now()});
      await games.doc(uid).collection("Rounds").doc("5").set({'Start': DateTime.now()});
      await games.doc(uid).collection("Rounds").doc("6").set({'Start': DateTime.now()});
      await games.doc(uid).collection("Rounds").doc("7").set({'Start': DateTime.now()});
      await games.doc(uid).collection("Rounds").doc("8").set({'Start': DateTime.now()});
      await games.doc(uid).collection("Rounds").doc("9").set({'Start': DateTime.now()});
      await games.doc(uid).collection("Rounds").doc("10").set({'Start': DateTime.now()});
      await games.doc(uid).collection("Rounds").doc("11").set({'Start': DateTime.now()});
      await games.doc(uid).collection("Rounds").doc("12").set({'Start': DateTime.now()});
      await games.doc(uid).collection("Rounds").doc("13").set({'Start': DateTime.now()});
      await games.doc(uid).collection("Rounds").doc("14").set({'Start': DateTime.now()});
      await games.doc(uid).collection("Rounds").doc("15").set({'Start': DateTime.now()});
      await games.doc(uid).collection("Rounds").doc("16").set({'Start': DateTime.now()});

      await games.doc(uid).collection("Collectibles").doc("bluecircle").set({'Round': 0});
      await games.doc(uid).collection("Collectibles").doc("bluetriangle").set({'Round': 1});
      await games.doc(uid).collection("Collectibles").doc("bluecross").set({'Round': 2});
      await games.doc(uid).collection("Collectibles").doc("bluesaturn").set({'Round': 3});
      await games.doc(uid).collection("Collectibles").doc("redcircle").set({'Round': 4});
      await games.doc(uid).collection("Collectibles").doc("redtriangle").set({'Round': 5});
      await games.doc(uid).collection("Collectibles").doc("redcross").set({'Round': 6});
      await games.doc(uid).collection("Collectibles").doc("redsaturn").set({'Round': 7});
      await games.doc(uid).collection("Collectibles").doc("greencircle").set({'Round': 8});
      await games.doc(uid).collection("Collectibles").doc("greentriangle").set({'Round': 9});
      await games.doc(uid).collection("Collectibles").doc("greencross").set({'Round': 10});
      await games.doc(uid).collection("Collectibles").doc("greensaturn").set({'Round': 11});
      await games.doc(uid).collection("Collectibles").doc("yellowcircle").set({'Round': 12});
      await games.doc(uid).collection("Collectibles").doc("yellowtriangle").set({'Round': 13});
      await games.doc(uid).collection("Collectibles").doc("yellowcross").set({'Round': 14});
      await games.doc(uid).collection("Collectibles").doc("yellowsaturn").set({'Round': 15});

      await games.doc(uid).collection("Players").doc(uid).set({'bet': 99,
        'score': 0,
        'timestampupdated': DateTime.now(),
        'isHost': true
      });

      //await games.doc(uid).collection("Players").doc(uid).set({'timestampupdated': DateTime.now()});



      // .then((value) => print("User Added"))
         // .catchError((error) => print("Failed to add user: $error"))

       return(print("Failed to add user:"));

    }

    if (pwd1!=pwd2) {
      _showDialogNT(context,'Passwords not identical!');
    } else {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: uid, password: pwd1).then((userCredential) => {
          // Signed in
          // print(userCredential.user)
          _showDialogSC(context),
          addUser(),
          createGame()
          // ...
        })
        ;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
          _showDialogNT(context, e.message.toString());
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
          _showDialogNT(context, e.message.toString());
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold( backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black,title: Text('Ricochet Robots - Create a new user')),
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
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white), ),
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white), ),
                                hintText: 'Email',
                                hintStyle: TextStyle(color: Colors.white)
                            ),
                            controller: email),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            enableSuggestions: false,
                            autocorrect: false,
                            obscureText: true,
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white), ),
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white), ),
                                hintText: 'Password',
                                hintStyle: TextStyle(color: Colors.white)
                  ),
                            controller: password1),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            enableSuggestions: false,
                            autocorrect: false,
                            obscureText: true,
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white), ),
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white), ),
                                hintText: 'Password',
                                hintStyle: TextStyle(color: Colors.white)
                            ),
                            controller: password2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  height: 40,
                  width: 300,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 6.0,
                      primary: Colors.indigoAccent, // background
                      onPrimary: Colors.white, // foreground
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: const BorderSide(color: Colors.indigoAccent)),
                    ),
                    onPressed: () {
                      _signup(context, email.text,password1.text,password2.text);
                    },
                    child: Text('Create Account'),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
