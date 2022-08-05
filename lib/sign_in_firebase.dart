
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firebase_home_page.dart';



class FirebaseSignInFul extends StatefulWidget {
  const FirebaseSignInFul({Key? key}) : super(key: key);

  @override
  _FirebaseSignInFulState createState() => _FirebaseSignInFulState();
}

class _FirebaseSignInFulState extends State<FirebaseSignInFul> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoaded = false;
  bool _isObscure = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  void isLoader() {
    setState(() {
      isLoaded = true;
    });
  }

  void _signIn() async {
    isLoader();

    try {
      await _auth
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text)
          .whenComplete(() {
        setState(() {
          isLoaded = false;
        });
      });
      Navigator.of(context).pushReplacementNamed('HomePage');
    }  catch (e) {
      if (e is FirebaseAuthException) {
        showMessage(e.message!);
      }
    }
  }

  void showMessage(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                child: const Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Widget sizedBoxOfHeight(double heightOfBox){
    return SizedBox(
      height: heightOfBox,
    );
  }

  Widget loginScreen(){
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30, top: 30),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 50),
              alignment: Alignment.center,
              child: const Text(
                'Login',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 45,
                    fontWeight: FontWeight.bold),
              ),
            ),
           sizedBoxOfHeight(50),
            TextField(
              controller: _emailController,
              autofillHints: const [AutofillHints.email],
              decoration: const InputDecoration(
                labelText: "Enter Email",
                prefixIcon: Icon(Icons.person_outline),
                //focusColor: Colors.black,
              ),
            ),
          sizedBoxOfHeight(20),
            TextField(
              obscureText: _isObscure,
              controller: _passwordController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    icon: _isObscure
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility)),
                labelText: "Enter Password",
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            Container(
              margin:
              const EdgeInsets.only(top: 10, left: 150, bottom: 40),
              child: const Text('Forgot your password?',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            ElevatedButton(
              onPressed: () {
                _signIn();
              },
              child: const Text('LOGIN'),
              style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  fixedSize: const Size(360, 50),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
            ),
            sizedBoxOfHeight(50),
            ElevatedButton.icon(
              onPressed: () async {
                isLoader();
                GoogleService service = GoogleService();
                try {
                  await service.signInWithGoogle();
                  setState(() {
                    isLoaded = false;
                  });
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const FirebaseHomePage()));
                } catch (e) {
                  if (e is FirebaseAuthException) {
                    showMessage(e.message!);
                  }
                }
              },
              label: const Text('Login with Google'),
              icon: Image.asset(
                'assets/images/google-3.png',
              ),
              style: ElevatedButton.styleFrom(
                  elevation: 10,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  shadowColor: Colors.grey,
                  fixedSize: const Size(360, 50),
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                  )),
            ),
            sizedBoxOfHeight(20),
            ElevatedButton.icon(
              onPressed: () async {
                isLoader();
                FacebookService service = FacebookService();
                try {
                  await service.signInWithFacebook();
                  setState(() {
                    isLoaded = false;
                  });
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const FirebaseHomePage()));
                } catch (e) {
                  if (e is FirebaseAuthException) {
                    showMessage(e.message!);
                  }
                }
              },
              label: const Text('Login with Facebook'),
              icon: Image.asset('assets/images/facebook (1).png'),
              style: ElevatedButton.styleFrom(
                  elevation: 10,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  shadowColor: Colors.grey,
                  fixedSize: const Size(360, 50),
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              onPressed: () {},
              label: const Text('Login with Linkedin'),
              icon: Image.asset('assets/images/linkedin.png'),
              style: ElevatedButton.styleFrom(
                  elevation: 10,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  shadowColor: Colors.grey,
                  fixedSize: const Size(360, 50),
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 110),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('CreateAccount');
                    },
                    child: const Text(
                      "Create an Account",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          loginScreen(),
          isLoaded ? const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey,
                    color: Colors.blue,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class GoogleService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}

class FacebookService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FacebookAuth _facebookAuth = FacebookAuth.instance;

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<void> signOutFromFacebook() async {
    await _facebookAuth.logOut();
    await _auth.signOut();
  }
}
