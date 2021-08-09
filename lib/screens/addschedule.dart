import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/schedule.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'selectfriends.dart';

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

  FirebaseFirestore db = FirebaseFirestore.instance;
  var selectedValue;
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  check () {
    if(titleController.text != ""
      && descriptionController.text != ""
      && dateController.text != ""
      && timeController.text != ""
    ) {
      setState(() {
        isValid = true;
      });
    }
  }
  Future submit() async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    var temp = scheduleList;
    Schedule schedule = Schedule(titleController.text, descriptionController.text, dateController.text, timeController.text, [], widget.uid);
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
  @override
  void initState() {
    titleController.addListener(check);
    descriptionController.addListener(check);
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
    titleController.dispose();
    descriptionController.dispose();
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
            child: Text("Title",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            )
              ,),
          ),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: 'Title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
          ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Date",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              )
              ,),
          ),
          TextField(
            controller: dateController,
            decoration: InputDecoration(
              hintText: 'Date',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Time",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              )
              ,),
          ),
          TextField(
            controller: timeController,
            decoration: InputDecoration(
              hintText: 'Time',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Description",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),),
          ),
          TextField(
            controller : descriptionController,
            keyboardType: TextInputType.multiline,
            maxLines: 10,
            decoration: InputDecoration(
              hintText: 'Description',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
          Column(
            children: <Widget>[
              ListTile(
                title : Text("전체 공개"),
                leading: Radio(
                  value : Mode.all,
                  groupValue: _mode,
                  onChanged: (value) {
                    setState(() {
                      _mode = value as dynamic;
                    });
                },
                ),
              ),
              ListTile(
                title : Text("일부 공개"),
                leading: Radio(
                  value : Mode.part,
                  groupValue: _mode,
                  onChanged: (value) {
                    setState(() {
                      _mode = value as dynamic;
                    });
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SelectFriends())
                    );
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                    onPressed: isValid ? submit : null,
                    child: Text("Enter")),
              ),

            ],
          ),

        ],
      ),
    );
  }
}
