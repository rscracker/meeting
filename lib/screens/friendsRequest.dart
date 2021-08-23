import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class FriendsRequest extends StatefulWidget {
  final uid;
  FriendsRequest({@required this.uid});
  @override
  _FriendsRequestState createState() => _FriendsRequestState();
}

class _FriendsRequestState extends State<FriendsRequest> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List totalUserData = [];
  var userdata;
  List friendsRequest = [];
  List friendsList = [];
  @override
  void initState() {
    getUsers().then((data) {
      setState(() {
        friendsList = data['friendsList'];
        friendsRequest = data['friendsRequest'];
      });
    });
    super.initState();
  }
  getUsers() async {
    var temp;
    var result = await db.collection('Users').doc(widget.uid).get().then((doc) {
      temp = doc.data();
    });
    return temp;
  }

  addFriends(String uid, int index) async{
    List friendsList1 = [];
    List friendsList2 = [];
    List _friendsRequest = [];
    await db.collection('Users').doc(widget.uid).get().then((doc) {
      friendsList1 = (doc.data() as dynamic)['friendsList'];
    });
    await db.collection('Users').doc(widget.uid).get().then((doc) {
      _friendsRequest = (doc.data() as dynamic)['friendsRequest'];
    });
    await db.collection('Users').doc(uid).get().then((doc) {
      friendsList2 = (doc.data() as dynamic)['friendsList'];
    });

    setState(() {
      friendsList1.add(uid);
      friendsList2.add(widget.uid);
      _friendsRequest.removeAt(index);
    });

    await db.collection('Users').doc(widget.uid).update({"friendsList" : friendsList1});
    await db.collection('Users').doc(uid).update({"friendsList" : friendsList2});
    await db.collection('Users').doc(widget.uid).update({"friendsRequest" : _friendsRequest});
  }

  rejectFriends(int index) async{
    var _friendsRequest;
    await db.collection('Users').doc(widget.uid).get().then((doc) {
      _friendsRequest = (doc.data() as dynamic)['friendsRequest'];
    });
    _friendsRequest.removeAt(index);
    await db.collection('Users').doc(widget.uid).update({"friendsRequest" : _friendsRequest});
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Friends Request",
          style: GoogleFonts.pacifico(),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('Users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var temp = snapshot.data!.docs;
          temp.forEach((DocumentSnapshot doc) {
            totalUserData.add(doc.data());
            if((doc.data() as dynamic)["userid"] == widget.uid){
              userdata = doc.data();
            }
          });
          List _friendsRequest = userdata['friendsRequest'];
          
          getNickName(String uid){
            String nickname = "";
            totalUserData.forEach((d){
              if(d['userid'] == uid){
                nickname = d['nickname'];
              }
            });
            return nickname;
          }
          return ListView.builder(
            itemCount: _friendsRequest.length,
              itemBuilder: (BuildContext context, int index){
                return Card(
                  color: Colors.teal[50],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)),
                  child: ListTile(
                    title: Text((getNickName(userdata["friendsRequest"][index])),
                      style: GoogleFonts.nanumGothic(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.teal[100],
                              ),
                              onPressed: (){
                                addFriends(userdata["friendsRequest"][index], index);
                              },
                              child: Text("승인",
                                style: GoogleFonts.nanumGothic(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.teal[100],
                            ),
                            onPressed: (){
                              rejectFriends(index);
                            },
                            child: Text("거절",
                              style: GoogleFonts.nanumGothic(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),)),
                      ],
                    ),
                  ),
                );
              });
        },
      )
    );
  }
}
