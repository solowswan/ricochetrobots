//c:\src\flutter\bin\flutter run -d chrome --no-sound-null-safety --web-renderer=html
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'game_activity.dart';
import 'menulist.dart';
import 'signup.dart';
import 'singleplayer_debugging.dart';


FirebaseAuth auth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp()  );
}




class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  //final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TURDLE',
      theme: ThemeData(
        primarySwatch: Colors.red,
        //  scaffoldBackgroundColor: const Color(0xFFEFEFEF)
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
           stream: auth.authStateChanges(),
      builder: (context, loginstream) {
        if (loginstream.connectionState == ConnectionState.active) {
         User? user = loginstream.data;
          if (user == null) {
           return SignInPage();
          } else {
          return MenuList();} //FirstScreen();
       // return SignInPage();}
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Colors.green)),
            ),
          );
        }
      },
    );
  }
}

class SignInPage extends StatelessWidget {

  TextEditingController  username = TextEditingController();
  TextEditingController  password = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
      await auth.signInWithEmailAndPassword(email: uid, password: pwd);

    } catch (e) {
      print(e); // TODO: show dialog with error
      _showDialogNT(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
        appBar: AppBar(          backgroundColor: Colors.black,
            title: Text('TURDLE')
      ),


      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row( mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[ //Text("Game Menu",style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      TextButton(
                        style: TextButton.styleFrom(
                            primary: Colors.white,
                            textStyle: TextStyle(fontSize: 32, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold)
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (
                                    ctxt) => new singleplayer_debugging(),
                                settings: RouteSettings(
                                    arguments: Arguments("")
                                  // comic.reference.id,
                                  // comic.data()["title"].toString(),
                                  // comic.data()["lang"].toString(),
                                ),
                              ));
                        },
                        child: const Text('FREE SINGLEPLAYER'),
                      ),
                    ]),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            enableSuggestions: true,
                            autocorrect: true,
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white), ),
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white), ),
                                hintText: 'Email',
                                hintStyle: TextStyle(color: Colors.white)
                            ),
                            controller: username),
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
                                fillColor: Colors.white,
                                hintText: 'Password',
                                hintStyle: TextStyle(color: Colors.white)
                                ),
                            controller: password),
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
                      _signIn(context, username.text,password.text);
                    },
                    child: Text('SignIn'),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                InkWell(
                  onTap: () {Navigator.push(context, MaterialPageRoute(builder: (ctxt) => new SignUp()));},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ", style: TextStyle(color: Colors.white)),
                      Text(
                        'Sign up.',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
