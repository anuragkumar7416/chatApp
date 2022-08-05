import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterchatapp/sign_in_firebase.dart';

import 'create_account.dart';
import 'firebase_home_page.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SplashFirebaseLess());
}


enum ImageSourceType { gallery, camera }
class SplashFirebaseLess extends StatelessWidget {
  const SplashFirebaseLess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,

      ),
      initialRoute: 'Splash',
      routes: {
        'Splash': (context) => const SplashFirebaseFul(),
        'Login': (context) => const FirebaseSignInFul(),
        'CreateAccount': (context) => const CreateAccountFul(),
        'HomePage': (context) => const FirebaseHomePage(),
      },
    );
  }
}

class SplashFirebaseFul extends StatefulWidget {
  const SplashFirebaseFul({Key? key}) : super(key: key);

  @override
  _SplashFirebaseFulState createState() => _SplashFirebaseFulState();
}

class _SplashFirebaseFulState extends State<SplashFirebaseFul> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(const Duration(seconds: 4),()=>Navigator.of(context).pushReplacementNamed('Login'));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.network('https://cdn4.iconfinder.com/data/icons/google-i-o-2016/512/google_firebase-2-512.png',height: 200,width: 200,),
      )
    );
  }
}





