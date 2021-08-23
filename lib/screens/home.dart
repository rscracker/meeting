import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user.dart';
import '../model/schedule.dart';
import 'freindslist.dart';
import 'addschedule.dart';
import 'friendsRequest.dart';

class Home extends StatefulWidget {
  var uid;
  Home({@required this.uid});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var backgroundColor = Colors.white;
  var cardColor = Colors.teal[50];
  final FirebaseFirestore db = FirebaseFirestore.instance;
  var userdata;
  var nickname;
  var name;
  var friendsList;
  var friendsRequest;

  var scheduleList;
  List friendsScheduleList = [];
  List totalScheduleList = [];

  @override
  void initState(){
    getUsers().then((data) {
      List friends = [];
      setState(() {
        userdata = data;
        scheduleList = userdata['scheduleList'];
        });
      });
    super.initState();
  }

  getUsers() async{
    var temp;
    List friends = [];
    var result = await db.collection('Users').doc(widget.uid).get().then((doc) {
      temp = doc.data();
      friends = temp['friendsList'];
    });
    friends.forEach((uid) async {
      await db.collection('Users').doc(uid).get().then((doc) {
        setState(() {
          if(doc.data() != null){
            friendsScheduleList = friendsScheduleList + (doc.data() as dynamic)['scheduleList'];
          }
        });
      });
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
          IconButton(onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddSchedule(uid : widget.uid))
            );
          },
              icon: Icon(Icons.add)),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('Users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List totalUserData = [];
          var temp = snapshot.data!.docs;
          temp.forEach((DocumentSnapshot doc) {
            totalUserData.add(doc.data());
            if((doc.data() as dynamic)["userid"] == widget.uid){
              userdata = doc.data();
            }
          });
          return Column(
            children: <Widget>[
              top(userdata, totalUserData),
              mid(userdata, totalUserData),
            ],
          );
        }
      ),
    );
  }

  Widget top(var userdata, var totalUserData) {
    var _scheduleList = userdata['scheduleList'];
    var _friendsList = userdata['friendsList'];
    var _friendsRequest = userdata['friendsRequest'];
    return Row(
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Container(
                color: backgroundColor,
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(userdata['nickname'],
                          style: GoogleFonts.nanumGothic(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight : FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(userdata['name'],
                          style: GoogleFonts.nanumGothic(
                            fontSize: 15,
                            color : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),

                        ),
                      ),
                    ],
                  ),
                ),
            )
        ),
        Expanded(
            flex: 1,
            child: Container(
              color: backgroundColor,
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("업로드",
                      style: GoogleFonts.nanumGothic(
                        fontSize : 17,
                        fontWeight: FontWeight.bold,
                        color : Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(_scheduleList.length.toString(),
                      style: GoogleFonts.nanumGothic(
                        fontSize : 16,
                        color : Colors.black,
                        fontWeight : FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
        ),
        Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => FriendsList(uid : widget.uid))
                );
              },
              child: Container(
                color: backgroundColor,
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("친구",
                        style: GoogleFonts.nanumGothic(
                          fontSize : 17,
                          fontWeight : FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(_friendsList.length.toString(),
                        style: GoogleFonts.nanumGothic(
                          fontSize :16,
                          fontWeight : FontWeight.bold,
                          color : Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
        ),
        Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => FriendsRequest(uid : widget.uid))
                );
              },
              child: Container(
                color: backgroundColor,
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("친구 요청",
                        style: GoogleFonts.nanumGothic(
                          fontSize : 17,
                          fontWeight : FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(_friendsRequest.length.toString(),
                        style: GoogleFonts.nanumGothic(
                          fontSize :16,
                          fontWeight : FontWeight.bold,
                          color : Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
        ),
      ],
    );
  }

  Widget mid(var userdata, List totalUserData) {
    List _myScheduleList = userdata['scheduleList'];
    List _myFriendsList = userdata['friendsList'];
    List _totalScheduleList = userdata['scheduleList'];

    totalUserData.forEach((d) {
      if(_myFriendsList.contains(d['userid'])) {
        for(int i = 0; i < d['scheduleList'].length ; i++){
          if (d['scheduleList'][i]['share'] != [] && d['scheduleList'][i]['share'].contains(widget.uid)){
            _totalScheduleList.add(d['scheduleList'][i]);
          } else if (d['scheduleList'][i]['share'].length == 0){
            _totalScheduleList.add(d['scheduleList'][i]);
          }
        }
      }
    });

    _totalScheduleList.sort((a,b) =>
        (a['date'].substring(0,4) != b['date'].substring(0,4)) ?
        a['date'].substring(0,4).compareTo(b['date'].substring(0,4)) :
        (a['date'].substring(6,7) != b['date'].substring(6,7)) ?
        a['date'].substring(6,7).compareTo(b['date'].substring(6,7)) :
        (a['date'].substring(9,10) != b['date'].substring(9,10)) ?
        a['date'].substring(9,10).compareTo(b['date'].substring(9,10)) :
        (a['time'].substring(0,1) != b['time'].substring(0,1)) ?
        a['time'].substring(0,1).compareTo(b['time'].substring(0,1)) :
        a['time'].substring(3,4).compareTo(b['time'].substring(3,4))
    );

    getNickName(String uid){
      String nickname = "";
      totalUserData.forEach((d){
        print(d);
        if(d['userid'] == uid){
          nickname = d['nickname'];
        }
      });
      return nickname;
    }
    deleteSchedule(String docNum) async{
      _myScheduleList.removeWhere((schedule) => schedule['docNum'] == docNum);
      await db.collection('Users').doc(widget.uid).update({"scheduleList" : _myScheduleList});
    }

    participation(String uploader, String docNum) async{
      List targetScheduleList = [];
      var temp;
      var result = await db.collection('Users').doc(uploader).get().then((doc) {
        temp = doc.data();
        targetScheduleList = temp['scheduleList'];
      });
      targetScheduleList.forEach((schedule) {
        if(schedule['docNum'] == docNum){
          schedule['participation'].add(widget.uid);
        }
      });
      await db.collection('Users').doc(uploader).update({"scheduleList" : targetScheduleList});
    }
    cancelParticipation(String uploader, String docNum) async{
      List targetScheduleList = [];
      var temp;
      var result = await db.collection('Users').doc(uploader).get().then((doc) {
        temp = doc.data();
        targetScheduleList = temp['scheduleList'];
      });
      targetScheduleList.forEach((schedule) {
        if(schedule['docNum'] == docNum){
          schedule['participation'].remove(widget.uid);
        }
      });
      await db.collection('Users').doc(uploader).update({"scheduleList" : targetScheduleList});
    }

    getParticipationNick(List participation) {
      List temp = [];
      participation.forEach((user) {
        temp.add(getNickName(user));
      });
      return temp;
    }
    return Expanded(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: ListView.builder(
          itemCount: (_totalScheduleList.length != 0) ? _totalScheduleList.length : 0,
          itemBuilder: (BuildContext context, int index){
            return GestureDetector(
              onTap: (){
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        backgroundColor: Colors.lightBlue[100],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        title: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("게시자 : ${getNickName(_totalScheduleList[index]['uploader'])}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("참여자 : ${(_totalScheduleList[index]['participation'].length == 0) ?
                              "없음" :
                              getParticipationNick(_totalScheduleList[index]['participation'])}"),
                            ),
                          ],
                        ),
                        content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: Text("확인"),
                          ),
                        ),
                      );
                    }
                    );
              },
              child: Card(
                color: cardColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0)),
                child: ListTile(
                  trailing:
                  (_totalScheduleList[index]['participation'].length.toString()
                      ==_totalScheduleList[index]['limit'].toString()
                    && _totalScheduleList[index]['limit'].toString() != "0"
                  ) ?
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                      ),
                      onPressed: (){
                        _totalScheduleList[index]['participation'].contains(widget.uid) ?
                            cancelParticipation(_totalScheduleList[index]['uploader'], _totalScheduleList[index]['docNum'])
                            : null;
                      },
                      child: Text('마감',
                        style: GoogleFonts.nanumGothic(
                          fontWeight: FontWeight.bold,
                          color: Colors.red
                        ),
                      )) :
                  (_totalScheduleList[index]['uploader'] != widget.uid) ?
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal[100],
                    ),
                    onPressed: (){
                      !_totalScheduleList[index]['participation'].contains(widget.uid) ?
                      participation(_totalScheduleList[index]['uploader'], _totalScheduleList[index]['docNum'])
                      : cancelParticipation(_totalScheduleList[index]['uploader'], _totalScheduleList[index]['docNum'])
                      ;
                    },
                    child:
                    !_totalScheduleList[index]['participation'].contains(widget.uid) ?
                    Text("참여",
                      style: GoogleFonts.nanumGothic(
                        color: Colors.black,
                        fontWeight : FontWeight.bold,
                      ),) :
                    Text("취소",
                    style: GoogleFonts.nanumGothic(
                      color: Colors.black,
                      fontWeight : FontWeight.bold,
                    ),)


                    ,) :
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal[100],
                    ),
                    onPressed: (){
                      deleteSchedule(_totalScheduleList[index]['docNum']);
                    },
                    child:
                    Text("삭제",
                      style: GoogleFonts.nanumGothic(
                        color : Colors.black,
                        fontWeight : FontWeight.bold,
                      ),),),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only( top : 8.0, bottom : 8.0),
                        child: Padding(
                          padding: const EdgeInsets.only(left : 28.0),
                          child: Text(
                            _totalScheduleList[index]['todo'],
                            style: GoogleFonts.nanumGothic(
                                fontSize: 17,
                                fontWeight : FontWeight.bold,
                                color : Colors.black
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top : 8.0, bottom : 8.0),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.location_pin,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left : 8.0),
                              child: Text(
                                _totalScheduleList[index]['location'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top :8.0, bottom : 8.0),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.calendar_today_outlined),
                            Padding(
                              padding: const EdgeInsets.only(left : 8.0),
                              child: Text(
                                "${_totalScheduleList[index]['date']} ${_totalScheduleList[index]['time']}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight : FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only( top : 8.0, bottom : 8.0),
                        child: Padding(
                          padding: const EdgeInsets.only(left : 28.0),
                          child: Text(
                            "인원 : "
                                + _totalScheduleList[index]["participation"].length.toString()
                                + "/"
                                + "${(_totalScheduleList[index]["limit"] == "0") ? "제한 없음" : _totalScheduleList[index]["limit"].toString()}",
                            style: GoogleFonts.nanumGothic(
                                fontSize: 17,
                                fontWeight : FontWeight.bold,
                                color : Colors.black,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

}
