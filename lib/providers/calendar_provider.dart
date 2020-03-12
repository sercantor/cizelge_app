import 'package:flutter/foundation.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarProvider with ChangeNotifier {
  DateTime _dateCursor;
  List<int> _datesList;
  EventList<Event> _markedDateMap;

  CalendarProvider() {
    _dateCursor = DateTime.now();
    _datesList = List<int>();
    _markedDateMap = EventList<Event>(events: {});
    loadPreferences();
  }

  // getters
  DateTime get dateCursor => _dateCursor;
  List<int> get datesList => _datesList;
  EventList<Event> get markedDateMap => _markedDateMap;

  //setters
  void setDateCursor(DateTime date) {
    _dateCursor = date;
    notifyListeners();
  }

  void setDate(DateTime date) {
    if (!_datesList.contains(date.millisecondsSinceEpoch)) {
      _datesList.add(date.millisecondsSinceEpoch);
      _markedDateMap.add(date, Event(date: date));
    } else {
      _datesList.remove(date.millisecondsSinceEpoch);
      _markedDateMap.remove(date, Event(date: date));
    }
    notifyListeners();
    savePreferences();
  }

  loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('date_nobet') == null) {
    } else {
      _datesList =
          prefs.getStringList('date_nobet').map(int.parse).toList() ?? [];
    }

    //removes the dates that have been selected before, and now have passed
    _datesList.removeWhere((item) =>
        item <
        DateTime.now().subtract(Duration(days: 1)).millisecondsSinceEpoch);
    _datesList.sort();

    for (int i = 0; i < _datesList.length; i++) {
      _markedDateMap.add(DateTime.fromMillisecondsSinceEpoch(_datesList[i]),
          new Event(date: DateTime.fromMillisecondsSinceEpoch(_datesList[i])));
    }
    notifyListeners();
  }

  savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _datesList.sort();
    prefs.setStringList(
        'date_nobet',
        _datesList.map<String>((int a) {
          return a.toString();
        }).toList());
    notifyListeners();
  }

  updateUserData(DateTime date) async {
    final DocumentReference datePrefs =
        Firestore.instance.collection('rooms').document('room1').collection('users').document('user1');
    if (_datesList.contains(date.millisecondsSinceEpoch)) {
      return await datePrefs.updateData({'dates': _datesList});
    } else {
    _datesList.remove(date.millisecondsSinceEpoch);
      return await datePrefs.updateData({'dates': _datesList});
    }
  }
}