import 'package:flutter/material.dart';
import 'package:meeting/screens/Login.dart';
import './screens/home.dart';
import './screens/Login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './screens/addschedule.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Meeting",
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: Login(),
    );
  }
}
