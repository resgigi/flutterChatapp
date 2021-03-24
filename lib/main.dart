import 'package:flutter/material.dart';
import 'package:flutter_chatapp/Views/LoginView.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ChatApp',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
