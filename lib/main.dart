//c:\src\flutter\bin\flutter run -d chrome --no-sound-null-safety --web-renderer=html
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'game_activity.dart';

FirebaseAuth auth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp()  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ricochet Robots',
      theme: ThemeData(
        primarySwatch: Colors.red,
        //scaffoldBackgroundColor: const Color(0xFF000000)
      ),
      //home: MyHomePage(title: 'Comic Reader Multi Language'),
      // home: new FirstScreen(),
      home: LandingPage(),
    );
  }
}

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
      appBar: AppBar(title: Text('Ricochet Robots')
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

            ]
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: _signOut,
          ),
        ],
      ),
    );
  }
}