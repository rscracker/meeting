import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'friendsRequest.dart';

class FriendsList extends StatefulWidget {
  final uid;
  FriendsList({@required this.uid});
  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  bool isSearch = false;
  var searchedUser;
  var searchController = TextEditingController();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  var friendsList;
  List friendsRequest = [];
  int numFriendsRequest = 0;
  List totalUserData = [];
  var userdata;
  getUsers() async {
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
        friendsRequest = data['friendsRequest'];
      });
      print(friendsList);
    });
    super.initState();
  }
  searchUser() async{
    var temp;
    setState(() {
      isSearch = !isSearch;
    });
    await db.collection('Users').get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        temp = doc.data();
        if(temp['nickname'] == searchController.text) {
          setState(() {
            searchedUser = temp;
          });
          return temp;
        }
      });
    });
  }
  requestFriends(String uid) async{
    List _friendsRequest = [];
    var temp;
    var result = await db.collection('Users').doc(uid).get().then((doc) {
      temp = doc.data();
      _friendsRequest = temp['friendsRequest'];
    });
    _friendsRequest.add(widget.uid);
    await db.collection('Users').doc(uid).update({"friendsRequest" : _friendsRequest});
  }

  deleteFriends(int index) async{
    List _friendsList = [];
    await db.collection('Users').doc(widget.uid).get().then((doc){
      var temp = doc.data();
      _friendsList = temp!['friendsList'];
    });
    _friendsList.removeAt(index);
    await db.collection('Users').doc(widget.uid).update({"friendsList" : _friendsList});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading : IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon : Icon(Icons.arrow_back),
        ),
        title: TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey,),
          controller: searchController,
        ),
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                  onPressed: () async{
                    await searchUser();
                    //&& searchedUser['userid'] != widget.uid
                    if(searchedUser != null) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)
                              ),
                              title: Text(searchedUser['nickname']),
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(onPressed: () async{
                                      await requestFriends(searchedUser['userid']);
                                      setState(() {
                                        searchedUser = null;
                                        searchController.text = "";
                                      });
                                      Navigator.pop(context);
                                    },
                                      child: Text("친구 요청"),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(onPressed: (){
                                      Navigator.pop(context);
                                      setState(() {
                                        searchedUser = null;
                                      });
                                    },
                                        child: Text("취소")),
                                  ),
                                ],
                              )
                            );
                          }
                      );
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)
                              ),
                              title: Text("존재하지 않는 회원입니다."),
                              content: ElevatedButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                                child: Text("확인"),
                              ),
                            );
                          });
                      setState(() {
                        searchedUser = null;
                      });
                    }
                  },
                  icon: Icon(Icons.search)),
              IconButton(
                    onPressed: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => FriendsRequest(uid: widget.uid))
                      );
                    },
                    icon: Icon(Icons.announcement_rounded,
                    ),
                  ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('Users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData){
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
          List _friendsList = userdata['friendsList'];
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
            itemCount: (_friendsList.length != 0) ? _friendsList.length : 0,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                color: Colors.teal[50],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0)),
                child: ListTile(
                  title: Text(getNickName(_friendsList[index]),
                    style: GoogleFonts.nanumGothic(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: (){
                      deleteFriends(index);
                    },
                  ),
                ),
              );
            },
          );
        }
      ),
      );
  }
}
