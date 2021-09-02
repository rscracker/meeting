import 'package:cloud_firestore/cloud_firestore.dart';
class Users {
  var _id;
  var _userid;
  var _nickname;
  var _name;
  var _friendsRequest;
  var _friendsList;
  var _scheduleList;

  Users(this._id,this._userid,this._nickname,this._name, this._friendsRequest, this._friendsList, this._scheduleList);

  String get userid => _userid;
  String get nickname => _nickname;
  String get name => _name;
  List get friendsRequest => _friendsRequest;
  List get friendsList => _friendsList;
  List get scheduleList => _scheduleList;

  Users.map(DocumentSnapshot document){
    this._id = document.id;
    this._userid = (document.data() as dynamic)['userid'];
    this._nickname = (document.data() as dynamic)['nickname'];
    this._name = (document.data() as dynamic)['name'];
    this._friendsRequest = (document.data() as dynamic)['friendsRequest'];
    this._friendsList = (document.data() as dynamic)['friendsList'];
    this._scheduleList = (document.data() as dynamic)['scheduleList'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['userid'] = _userid;
    map['nickname'] = _nickname;
    map['name'] = _name;
    map['friendsRequest'] = _friendsRequest;
    map['friendsList'] = _friendsList;
    map['scheduleList'] = _scheduleList;

    return map;
  }
}