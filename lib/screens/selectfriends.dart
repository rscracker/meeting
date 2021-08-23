import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectFriends extends StatefulWidget {
  final uid;
  SelectFriends({@required this.uid});
  @override
  _SelectFriendsState createState() => _SelectFriendsState();
}

class _SelectFriendsState extends State<SelectFriends> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  List totalUserData = [];
  List<String> sharedList = [];
  var userdata;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text("완료"),
        onPressed: (){
          Navigator.pop(context,sharedList);
        },
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
            itemCount: (_friendsList.length != 0 ) ? _friendsList.length : 0,
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
                    trailing: ElevatedButton(
                      child: (sharedList.contains(_friendsList[index])) ? Text("삭제") : Text("추가"),
                      onPressed: (){
                        if(sharedList.contains(_friendsList[index])){
                          sharedList.remove(_friendsList[index]);
                          setState(() {
                            sharedList = sharedList;
                          });
                        } else {
                          sharedList.add(_friendsList[index]);
                          setState(() {
                            sharedList = sharedList;
                          });
                        }
                      },
                    ),
                  ),
                );
              });
        }
      ),
    );
  }
}
