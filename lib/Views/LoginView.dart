import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatapp/Views/HomeView.dart';
import 'package:flutter_chatapp/Widgets/ProgressWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences preferences;

  bool isLoggedIn = false;
  bool isLoading = false;
  User currentUser;

  @override
  void initState() {
    super.initState();

    isSignedIn();
  }

  void isSignedIn() async {
    this.setState(() {
      isLoggedIn = true;
    });
    preferences = await SharedPreferences.getInstance();

    isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(currentUserId: preferences.getString("id"))));
    }
    this.setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomLeft,
                colors: [Colors.lightBlueAccent, Colors.purpleAccent])),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Fluttergram",
              style: TextStyle(
                  fontSize: 82.0, color: Colors.white, fontFamily: "Signatra"),
            ),
            GestureDetector(
              onTap: controlSignIn,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 250.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                              AssetImage("assets/images/btn_google_dark.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(1.0),
                      child: isLoading ? circularProgress() : Container(),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Null> controlSignIn() async {
    preferences = await SharedPreferences.getInstance();
    // ignore: unnecesary_statements
    this.setState(() {
      isLoading = true;
    });

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuthentication =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuthentication.idToken,
        accessToken: googleAuthentication.accessToken);

    User firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;

//SignIn success
    if (firebaseUser != null) {
      //check if already signUp
      final QuerySnapshot resultQuery = await FirebaseFirestore.instance
          .collection("users")
          .where("id", isEqualTo: firebaseUser.uid)
          .get();
      final List<DocumentSnapshot> documentSnapshots = resultQuery.docs;
//Save Data to firestore - if new user
      if (documentSnapshots.length == 0) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .set({
          "nickname": firebaseUser.displayName,
          "photoUrl": firebaseUser.photoURL,
          "id": firebaseUser.uid,
          "aboutMe": "i am using Flutter chat app",
          "createAt": DateTime.now().millisecondsSinceEpoch.toString(),
          "chattingwith": null,
        });

        ///Write data to local
        currentUser = firebaseUser;
        await preferences.setString("id", currentUser.uid);
        await preferences.setString("nickname", currentUser.displayName);
        await preferences.setString("photoUrl", currentUser.photoURL);
      } else {
        currentUser = firebaseUser;
        await preferences.setString("id", documentSnapshots[0]["id"]);
        await preferences.setString(
            "nickname", documentSnapshots[0]["nickname"]);
        await preferences.setString(
            "photoUrl", documentSnapshots[0]["photoUrl"]);
        await preferences.setString("aboutMe", documentSnapshots[0]["aboutMe"]);
      }
      Fluttertoast.showToast(msg: "Congratulation, Sign In Successful");
      this.setState(() {
        isLoading = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(currentUserId: firebaseUser.uid)));
    }
    //SignIn failed
    else {
      Fluttertoast.showToast(msg: "Try Again, Sign In Failed!");
      this.setState(() {
        isLoading = false;
      });
    }
  }
}
