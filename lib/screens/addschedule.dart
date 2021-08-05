import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/schedule.dart';

enum Mode{all, part}

class AddSchedule extends StatefulWidget {
  final uid;
  AddSchedule({@required this.uid});
  @override
  _AddScheduleState createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  List friendsList = [];
  Mode _mode = Mode.all;
  var selectedValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Text("Title"),
          TextField(
            decoration: InputDecoration(
              hintText: 'Title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
          ),
          ),
          Text("Description"),
          TextField(
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
                  },
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
