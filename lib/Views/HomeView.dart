import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatapp/Widgets/ProgressWidget.dart';
import 'package:flutter_chatapp/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_chatapp/Views/AccountSetting.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:intl/intl.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, @required this.currentUserId}) : super(key: key);
  final String currentUserId;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchTextEditingController = TextEditingController();
  homeViewHeader() {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.settings, size: 30.0, color: Colors.white),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ASettings(),
                  ));
            }),
      ],
      backgroundColor: Colors.lightBlue,
      title: Container(
        margin: new EdgeInsets.only(bottom: 4.0),
        child: TextFormField(
          style: TextStyle(fontSize: 18.0, color: Colors.white),
          controller: searchTextEditingController,
          decoration: InputDecoration(
              hintText: "Search here...",
              hintStyle: TextStyle(color: Colors.white),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              filled: true,
              prefixIcon: Icon(
                Icons.person_pin,
                color: Colors.white,
                size: 30.0,
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear, color: Colors.white),
                onPressed: emptyTextFromField,
              )),
        ),
      ),
    );
  }

  emptyTextFromField() {
    searchTextEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: ,
      body: RaisedButton.icon(
          onPressed: logoutUser,
          icon: Icon(Icons.close),
          label: Text("Sign Out")),
    );
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();
  Future<Null> logoutUser() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyApp()),
        (Route<dynamic> rout) => false);
  }
}

class UserResult extends StatelessWidget {
  const UserResult({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        // child: child,
        );
  }
}
