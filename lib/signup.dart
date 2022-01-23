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

    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users.doc(uid)
          .set({
        'EMail': uid,
        'Created': DateTime.now()
      })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
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
    return Scaffold(
      appBar: AppBar(title: Text('Ricochet Robots - Create a new user')),
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
    );
  }

}
