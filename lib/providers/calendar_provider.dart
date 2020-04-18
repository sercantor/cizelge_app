import 'package:flutter/foundation.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

//TODO: authorized users can request dates from other rooms, although this is highly unlikely, try to fix

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
    //TODO: rewrite this, not that hard
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('date_nobet') == null) {
    } else {
      _datesList =
          prefs.getStringList('date_nobet').map(int.parse).toList() ?? [];
      _datesMap = json.decode(prefs.getString('datesMap'));
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

    _datesList.forEach((date) {
      if (!_datesMap.containsKey('${date.toString()}')) {
        _datesMap.remove('${date.toString()}');
      }
    });
    notifyListeners();
  }

  void removeDateMap(String date) {
    _datesMap.remove(date);
  }

  savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _datesList.sort();
    prefs.setStringList(
        'date_nobet',
        _datesList.map<String>((int a) {
          return a.toString();
        }).toList());
    prefs.setString('datesMap', json.encode(_datesMap));
    notifyListeners();
  }
}
