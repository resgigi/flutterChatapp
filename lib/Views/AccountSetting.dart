import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chatapp/main.dart';
import 'package:flutter_chatapp/Views/HomeView.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ASettings extends StatelessWidget {
  // const ASettings({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scafoold(
      appbar: Appbar(
        iconTheme:IconThemeData()
      )
    )
  }
}

class SettingScreen extends StatefulWidget {
  // SettingScreen({Key key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  TextEditingController nickNameEditingController;
  TextEditingController aboutMeEditingController;
  File imageFileAvatar;
  SharedPreferences preferences;
  String id = "";
  String nickname = "";
  String aboutMe = "";
  String photoUrl = "";
  @override
  void initState() {
    super.initState();
    readDataFromLocal();
  }

  void readDataFromLocal() async {
    preferences = await SharedPreferences.getInstance();
    id = preferences.getString("id");
    nickname = preferences.getString("nickname");
    aboutMe = preferences.getString("aboutMe");
    photoUrl = preferences.getString("photoUrl");

    nickNameEditingController = TextEditingController(text: nickname);
    aboutMeEditingController = TextEditingController(text: aboutMe);

    setState(() {});
  }

  Future getImage() async{
    File newImageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if(newImageFile != null){
    setState(() {
      this.imageFileAvatar = newImageFile;
      isLoading = true;
    });
    }
    //uploadImageToFireStoreAndStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      (imageFileAvatar == null)
                        ? (photoUrl != "")
                        ? Material(
                          //display already existing - old image file
                          child: CachedNetWorkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                              ),
                              width: 200.0,
                              height: 200.0,
                              padding: EdgeInsets.all(20.0),
                            ),
                            imageUrl: photoUrl,
                            width:200.0,
                            height:200.0,
                            fit:BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(125.0)),
                          clipBehavior: Clip.hardEdge,
                        ) 
                        : Icon(Icons.account_circle, size: 90.0, color:Colors.grey)
                        : Material(
                          //display the new updated image here
                          child: Image.file(
                              imageFileAvatar,
                              width:200.0,
                              height: 200.0,
                              fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(125.0)),
                          clipBehavior: Clip.hardEgde,
                        ),
                    IconButton(
                      icon:Icon(
                        Icons.camera_alt, size: 100.0, color: Colors.white54.withOpacity(0.3),
                      ),
                      onPressed: getImage(),
                      padding: EdgeInsets.all(0.0),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.grey,
                      iconSize: 200.0,
                    ),
                    ],
                  ),
                ),
                width: double.infinity;
                margin: EdgeInsets.all(20.0),
              )
            ];
          ),
        )
      ],
    );
  }
}
