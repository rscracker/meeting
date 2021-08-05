import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendsList extends StatefulWidget {
  final uid;
  FriendsList({@required this.uid});
  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  bool isSearch = false;
  var searchController = TextEditingController();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  var friendsList;
  getUsers() async{
    var temp;
    var result = await db.collection('Users').doc(widget.uid).get().then((doc) {
      temp = doc.data();
    });
    return temp;
  }
  @override
  void initState() {
    getUsers().then((data) {
      setState(() {
        friendsList = data['friendsList'];
      });
      print(friendsList);
    });
    super.initState();
  }
  searchUser() {
    setState(() {
      isSearch = !isSearch;
    });
  }
  deleteUser(){

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading : Icon(Icons.arrow_back),
        title: isSearch ? Text("Friends") : TextField(
          controller: searchController,
        ),
        actions: <Widget>[
          IconButton(onPressed: searchUser, icon: Icon(Icons.search)),
        ],
      ),
      body: ListView.builder(
        itemCount: (friendsList.length != 0) ? friendsList.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0)),
            child: ListTile(
              title: Text(friendsList[index]),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: deleteUser,
              ),
            ),
          );
        },
      ),
    );
  }
}
