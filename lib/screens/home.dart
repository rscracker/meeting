import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../model/user.dart';
import '../model/schedule.dart';

class Home extends StatefulWidget {
  var uid;
  Home({@required this.uid});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  var userdata;
  @override
  void initState(){
    getUsers().then((data) {
      setState(() {
        userdata = data;
      });
    });
    super.initState();
  }

  getUsers() async{
    var temp;
    var result = await db.collection('Users').doc(widget.uid).get().then((DocumentSnapshot doc) {
      print(doc.data());
      temp = doc.data();
    });
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule",
        style: GoogleFonts.pacifico(),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.add)),
        ],
      ),
      body: Column(
        children: <Widget>[
          top(),
          mid(),
        ],
      ),
    );
  }

  Widget top() {
    return Row(
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Container(
                color: Colors.red,
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.account_circle),
                      Text(userdata['nickname'],
                        style: TextStyle(
                          fontSize: 15
                        ),
                      ),
                      Text(userdata['name']),
                    ],
                  ),
                ),
            )
        ),
        Expanded(
            flex: 1,
            child: Container(
              color: Colors.green,
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text("Upload"),
                    SizedBox(
                      height: 15,
                    ),
                    Text('3')
                  ],
                ),
              ),
            )
        ),
        Expanded(
            flex: 1,
            child: Container(
              color: Colors.blue,
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text("Friends"),
                    SizedBox(
                      height: 15,
                    ),
                    Text('10')
                  ],
                ),
              ),
            )
        ),
      ],
    );
  }

  Widget mid() {
    return Expanded(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: ListView(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Title",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "2021/07/24 15:30",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Wonsob wonsob2 wonsob3",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void abc(){
    setState(() {

    });
  }
}
