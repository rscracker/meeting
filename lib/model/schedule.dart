
class Schedule {
  var _docNum;
  var _location;
  var _todo;
  var _date;
  var _time;
  var _share;
  var _uploader;
  var _limit;
  var _participation;

  Schedule(this._docNum,this._location, this._todo, this._date, this._time, this._share, this._uploader, this._limit, this._participation);

  String get docNum => _docNum;
  String get location => _location;
  String get todo => _todo;
  String get date => _date;
  String get time => _time;
  List get share => _share;
  String get uploader => _uploader;
  String get limit => _limit;
  List get participation => _participation;

  Schedule.fromMap(dynamic obj){
    this._docNum = obj['docNum'];
    this._todo = obj['todo'];
    this._time = obj['time'];
    this._location = obj['location'];
    this._date = obj['date'];
    this._share = obj['share'];
    this._limit = obj['limit'];
    this._participation = obj['participation'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['docNum'] = _docNum;
    map['todo'] = _todo;
    map['time'] = _time;
    map['location'] = _location;
    map['date'] = _date;
    map['share'] = _share;
    map['uploader'] = _uploader;
    map['limit'] = limit;
    map['participation'] = participation;
    return map;
  }
}