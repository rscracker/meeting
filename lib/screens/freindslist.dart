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
  bool isFriends = false;
  bool isMyAccount = false;
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

  searchUser() async {
    var temp;
    String myNick = '';
    await db.collection('Users').doc(widget.uid).get().then((doc) {
      temp = doc.data();
      setState(() {
        friendsList = temp['friendsList'];
        myNick = temp['nickname'];
      });
    });
    setState(() {
      isSearch = !isSearch;
    });
    print(myNick);
    if (searchController.text == myNick) {
      setState(() {
        isMyAccount = true;
      });
      print(isMyAccount);
    }
    await db.collection('Users').get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        temp = doc.data();
        if (temp['nickname'] == searchController.text) {
          if (friendsList.contains(temp['userid'])) {
            setState(() {
              isFriends = true;
            });
          }
          setState(() {
            searchedUser = temp;
          });
          return temp;
        }
      });
    });
  }

  requestFriends(String uid) async {
    List _friendsRequest = [];
    var temp;
    var result = await db.collection('Users').doc(uid).get().then((doc) {
      temp = doc.data();
      _friendsRequest = temp['friendsRequest'];
    });
    _friendsRequest.add(widget.uid);
    await db
        .collection('Users')
        .doc(uid)
        .update({"friendsRequest": _friendsRequest});
  }

  deleteFriends(int index) async {
    List _friendsList = [];
    await db.collection('Users').doc(widget.uid).get().then((doc) {
      var temp = doc.data();
      _friendsList = temp!['friendsList'];
    });
    _friendsList.removeAt(index);
    await db
        .collection('Users')
        .doc(widget.uid)
        .update({"friendsList": _friendsList});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: TextField(
          textInputAction: TextInputAction.done,
          onSubmitted: (value) async {
            await searchUser();
            if (searchedUser != null) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        backgroundColor: Colors.lightBlue[100],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        title: Column(
                          children: <Widget>[
                            Text(
                              '이름 : ' + searchedUser['name'],
                              style: GoogleFonts.nanumGothic(),
                            ),
                            Text(
                              '닉네임 : ' + searchedUser['nickname'],
                              style: GoogleFonts.nanumGothic(),
                            ),
                          ],
                        ),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: isMyAccount ? Text('') : !isFriends
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.teal[100],
                                      ),
                                      onPressed: () async {
                                        await requestFriends(
                                            searchedUser['userid']);
                                        setState(() {
                                          searchedUser = null;
                                          searchController.text = "";
                                          isFriends = false;
                                          isMyAccount = false;
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "친구 요청",
                                        style: GoogleFonts.nanumGothic(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      "이미 친구입니다",
                                      style: GoogleFonts.nanumGothic(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.teal[100]),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      searchedUser = null;
                                      isFriends = false;
                                      isMyAccount = false;
                                    });
                                  },
                                  child: isMyAccount ? Text("확인",
                                      style: GoogleFonts.nanumGothic(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      )) : isFriends
                                      ? Text("확인",
                                          style: GoogleFonts.nanumGothic(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ))
                                      : Text(
                                          "취소",
                                          style: GoogleFonts.nanumGothic(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                            ),
                          ],
                        ));
                  });
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      title: Text(
                        "존재하지 않는 회원입니다.",
                        style: GoogleFonts.nanumGothic(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "확인",
                          style: GoogleFonts.nanumGothic(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  });
              setState(() {
                searchedUser = null;
              });
            }
          },
          cursorColor: Colors.white,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey,
          ),
          controller: searchController,
        ),
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                  onPressed: () async {
                    await searchUser();
                    //&& searchedUser['userid'] != widget.uid
                    if (searchedUser != null) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                backgroundColor: Colors.lightBlue[100],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                title: Column(
                                  children: <Widget>[
                                    Text(
                                      '이름 : ' + searchedUser['name'],
                                      style: GoogleFonts.nanumGothic(
                                        fontWeight : FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '닉네임 : ' + searchedUser['nickname'],
                                      style: GoogleFonts.nanumGothic(
                                        fontWeight : FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: isMyAccount ? null : !isFriends
                                          ? ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.teal[100],
                                              ),
                                              onPressed: () async {
                                                await requestFriends(
                                                    searchedUser['userid']);
                                                setState(() {
                                                  searchedUser = null;
                                                  searchController.text = "";
                                                  isFriends = false;
                                                  isMyAccount = false;
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "친구 요청",
                                                style: GoogleFonts.nanumGothic(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          : Text(
                                              "이미 친구입니다",
                                              style: GoogleFonts.nanumGothic(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.teal[100]),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            setState(() {
                                              searchedUser = null;
                                              isFriends = false;
                                              isMyAccount = false;
                                            });
                                          },
                                          child: isMyAccount ? Text("확인",
                                              style:
                                              GoogleFonts.nanumGothic(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              )) : isFriends
                                              ? Text("확인",
                                                  style:
                                                      GoogleFonts.nanumGothic(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ))
                                              : Text(
                                                  "취소",
                                                  style:
                                                      GoogleFonts.nanumGothic(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )),
                                    ),
                                  ],
                                ));
                          });
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.lightBlue[100],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              title: Text(
                                "존재하지 않는 회원입니다.",
                                style: GoogleFonts.nanumGothic(
                                  fontWeight: FontWeight.bold,
                                  fontSize : 16,
                                ),
                              ),
                              content: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "확인",
                                  style: GoogleFonts.nanumGothic(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FriendsRequest(uid: widget.uid)));
                },
                icon: Icon(
                  Icons.person_add,
                ),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: db.collection('Users').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            var temp = snapshot.data!.docs;
            temp.forEach((DocumentSnapshot doc) {
              totalUserData.add(doc.data());
              if ((doc.data() as dynamic)["userid"] == widget.uid) {
                userdata = doc.data();
              }
            });
            List _friendsList = userdata['friendsList'];
            getNickName(String uid) {
              String nickname = "";
              totalUserData.forEach((d) {
                if (d['userid'] == uid) {
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
                    title: Text(
                      getNickName(_friendsList[index]),
                      style: GoogleFonts.nanumGothic(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteFriends(index);
                      },
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
