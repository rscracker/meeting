import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule {
  var _title;
  var _description;
  var _date;
  var _time;
  var _share;
  var _uploader;

  Schedule(this._title, this._description, this._date, this._time, this._share, this._uploader);

  String get description => _description;
  String get title => _title;
  String get date => _date;
  String get time => _time;
  List get share => _share;

  Schedule.fromMap(dynamic obj){
    this._description = obj['description'];
    this._time = obj['time'];
    this._title = obj['title'];
    this._date = obj['date'];
    this._share = obj['share'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['description'] = _description;
    map['time'] = _time;
    map['title'] = _title;
    map['date'] = _date;
    map['share'] = _share;

    return map;
  }
}