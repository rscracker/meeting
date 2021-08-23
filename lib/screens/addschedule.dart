import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/schedule.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'selectfriends.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

enum Mode{all, part}

class AddSchedule extends StatefulWidget {
  final uid;
  AddSchedule({@required this.uid});
  @override
  _AddScheduleState createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  String errorMessage = "";
  bool isValid = false;
  List friendsList = [];
  List scheduleList = [];
  var userdata;
  Mode _mode = Mode.all;
  List sharedList = [];
  var dateMaskFormatter = new MaskTextInputFormatter(mask: '####/##/##', filter: { "#": RegExp(r'[0-9]') });
  var timeMaskFormatter = new MaskTextInputFormatter(mask: '##:##', filter: { "#": RegExp(r'[0-9]') });
  FirebaseFirestore db = FirebaseFirestore.instance;
  var selectedValue;
  var locationController = TextEditingController();
  var todoController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var limitController = TextEditingController();

  check () {
    if(locationController.text != ""
      && todoController.text != ""
      && dateController.text != ""
      && timeController.text != ""
    ) {
      setState(() {
        isValid = true;
      });
    }
  }
  Future submit() async{
    if(limitController.text == "") {
      setState(() {
        limitController.text = "0";
      });
    }
    FirebaseFirestore db = FirebaseFirestore.instance;
    var temp = scheduleList;
    Schedule schedule = Schedule(
        DateTime.now().toString(),
        locationController.text,
        todoController.text,
        dateController.text,
        timeController.text,
        (sharedList.length == 0) ? [] : sharedList,
        widget.uid,
        limitController.text,
        [],
    );
    temp.add(schedule.toMap());
    print(temp);
    var result = await db.collection('Users').doc(widget.uid).update({"scheduleList": FieldValue.arrayUnion(temp)});
    return result;
  }
  getUser() async{
    var temp;
    var result = await db.collection('Users').doc(widget.uid).get().then((doc) {
      temp = doc.data();
    });
    return temp;
  }

  _navigatePage(BuildContext context) async{
    sharedList = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectFriends(uid: widget.uid)));
  }

  @override
  void initState() {
    locationController.addListener(check);
    todoController.addListener(check);
    dateController.addListener(check);
    timeController.addListener(check);

    getUser().then((data) {
      setState(() {
        userdata = data;
        scheduleList = userdata['scheduleList'];
      });
    });
    super.initState();
  }
  @override
  void dispose(){
    timeController.dispose();
    dateController.dispose();
    limitController.dispose();
    locationController.dispose();
    todoController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload",
        style: GoogleFonts.pacifico(),),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("장소",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            )
              ,),
          ),
          Padding(
            padding: const EdgeInsets.only(left : 8.0, right : 8.0),
            child: TextField(
              controller: locationController,
              decoration: InputDecoration(
                hintText: '장소',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
            ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("날짜",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              )
              ,),
          ),
          Padding(
            padding: const EdgeInsets.only(left : 8.0, right : 8.0),
            child: TextField(
              inputFormatters: [dateMaskFormatter],
              controller: dateController,
              decoration: InputDecoration(
                hintText: 'ex) 2021/01/03',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("시간",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              )
              ,),
          ),
          Padding(
            padding: const EdgeInsets.only(left : 8.0, right : 8.0),
            child: TextField(
              inputFormatters: [timeMaskFormatter],
              controller: timeController,
              decoration: InputDecoration(
                hintText: 'ex) 13:00',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("할 것",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(left : 8.0, right : 8.0),
            child: TextField(
              controller : todoController,
              decoration: InputDecoration(
                hintText: '할 것',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("인원 제한 (공백이면 제한 없음)",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),),
          ),
          Padding(
            padding: const EdgeInsets.only(left : 8.0, right : 8.0),
            child: TextField(
              controller : limitController,
              decoration: InputDecoration(
                hintText: '인원 제한',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
          ),
          Column(
            children: <Widget>[
              RadioListTile(
                title : Text("전체 공개"),
                  value : Mode.all,
                  groupValue: _mode,
                  onChanged: (value) {
                    setState(() {
                      _mode = value as dynamic;
                    });
                },
              ),
              RadioListTile(
                title : Text("일부 공개"),
                  value : Mode.part,
                  groupValue: _mode,
                  onChanged: (value) {
                    setState(() {
                      _mode = value as dynamic;
                    });
                    _navigatePage(context);
                  },
                ),
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal[100],
                    ),
                    onPressed: isValid ? (){
                      submit();
                      Navigator.pop(context);
                    } : null,
                    child: Text("확인")),
              ),

            ],
          ),

        ],
      ),
    );
  }
}
