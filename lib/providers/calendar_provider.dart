import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

//TODO: authorized users can request dates from other rooms, although this is highly unlikely, try to fix
/*TODO: I used nested ternary operators to check if the user entered 16-24 or timely work shifts
      * I had to use them 3 times in this code, which is even worse.  
      *  nested ternary operators are bad, I should change this code when I understand what's happening
*/

class CalendarProvider with ChangeNotifier {
  DateTime _dateCursor;
  List<int> _datesList;
  EventList<Event> _markedDateMap;
  Map<String, dynamic> _datesMap;

  CalendarProvider() {
    _dateCursor = DateTime.now();
    _datesList = List<int>();
    _datesMap = Map<String, dynamic>();
    _markedDateMap = EventList<Event>(events: {});
    loadPreferences();
  }

  // getters
  DateTime get dateCursor => _dateCursor;
  List<int> get datesList => _datesList;
  EventList<Event> get markedDateMap => _markedDateMap;
  Map<String, dynamic> get datesMap => _datesMap;

  //setters
  void setDateCursor(DateTime date) {
    _dateCursor = date;
    notifyListeners();
  }

  void setDateMap(String date, List<String> hoursAndMinutes) {
    _datesMap.putIfAbsent(date.toString(), () => hoursAndMinutes);
    notifyListeners();
  }

  void setDate(DateTime date, List<String> hoursAndMinutes) {
    if (!_datesList.contains(date.millisecondsSinceEpoch)) {
      _datesList.add(date.millisecondsSinceEpoch);
      _markedDateMap.add(
          date,
          Event(
              date: date,
              icon: hoursAndMinutes[0] == '24'
                  ? _eventIcon24
                  : hoursAndMinutes[0] == '16'
                      ? _eventIcon16
                      : _eventIconTime));
    } else {
      _datesList.remove(date.millisecondsSinceEpoch);
      _markedDateMap.remove(
          date,
          Event(
              date: date,
              icon: _datesMap['${date.millisecondsSinceEpoch.toString()}'][0] ==
                      '24'
                  ? _eventIcon24
                  : _datesMap['${date.millisecondsSinceEpoch.toString()}'][0] ==
                          '16'
                      ? _eventIcon16
                      : _eventIconTime));
    }
    notifyListeners();
    savePreferences();
  }

  loadPreferences() async {
    //TODO: rewrite this, not that hard
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('date_nobet') == null) {
    } else {
      _datesList =
          prefs.getStringList('date_nobet').map(int.parse).toList() ?? [];
      _datesMap = json.decode(prefs.getString('datesMap'));
    }

    //removes the dates that have been selected before, and now have passed
    _datesList.removeWhere((date) =>
        date <
        DateTime.now().subtract(Duration(days: 1)).millisecondsSinceEpoch);
    _datesMap.removeWhere((key, value) =>
        int.parse(key) <
        DateTime.now().subtract(Duration(days: 1)).millisecondsSinceEpoch);
    _datesList.sort();

    for (int i = 0; i < _datesList.length; i++) {
      _markedDateMap.add(
          DateTime.fromMillisecondsSinceEpoch(_datesList[i]),
          new Event(
              date: DateTime.fromMillisecondsSinceEpoch(_datesList[i]),
              //nested ternary is REALLY complex to read, it was my last resort at 3:50 am
              icon: _datesMap['${_datesList[i].toString()}'][0] == '24'
                  ? _eventIcon24
                  : _datesMap['${_datesList[i].toString()}'][0] == '16'
                      ? _eventIcon16
                      : _eventIconTime));
    }
    notifyListeners();
  }

  void removeDateMap(String date) {
    _datesMap.remove(date);
  }

  void savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _datesList.sort();
    prefs.setStringList(
        'date_nobet',
        _datesList.map<String>((int a) {
          return a.toString();
        }).toList());
    prefs.setString('datesMap', json.encode(_datesMap));
  }

  static Widget _eventIcon24 = Container(
      decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.all(Radius.circular(1000)),
          border: Border.all(color: Colors.blue, width: 2.0)),
      child: Center(child: Text('24', style: TextStyle(color: Colors.white),)));

  static Widget _eventIcon16 = Container(
      decoration: BoxDecoration(
          color: Colors.orangeAccent,
          borderRadius: BorderRadius.all(Radius.circular(1000)),
          border: Border.all(color: Colors.blue, width: 2.0)),
      child: Center(child: Text('16')));
  static Widget _eventIconTime = Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(1000)),
          border: Border.all(color: Colors.blue, width: 2.0)),
      child: Center(child: Icon(Icons.timer)));
}
