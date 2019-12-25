import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class TakvimNobet extends StatefulWidget {
  @override
  _TakvimNobetState createState() => _TakvimNobetState();
}

class _TakvimNobetState extends State<TakvimNobet> {
  //this widget's values will never change
  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: new Icon(Icons.healing, color: Colors.amber),
  );

  var _markedDateMap = new EventList<Event>(events: {}); // markedDateMap init
  var _dateCursor = new DateTime.now();
  List<int> _datesList = new List<int>();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _loadDate();
    //initialize notification settings, only init one time
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future<void> _loadDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getStringList('date_nobet') == null) {
        print('nothing here');
      } else {
        _datesList =
            (prefs.getStringList('date_nobet').map(int.parse).toList() ?? []);
      } //loads all the dates first

      _datesList.removeWhere((item) =>
          item <
          DateTime.now()
              .subtract(Duration(days: 1))
              .millisecondsSinceEpoch); //removes the dates that have passed
      _datesList.sort(); //sorts the list for notifications
      for (int i = 0; i < _datesList.length; i++) {
        _markedDateMap.add(
            DateTime.fromMillisecondsSinceEpoch(_datesList[i]),
            new Event(
                date: DateTime.fromMillisecondsSinceEpoch(_datesList[i]),
                icon: _eventIcon));
      }
    });
  }

  Future<void> _scheduledNotification() async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High, importance: Importance.Max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);

    //check if they cancelled all their dates
    if (_datesList.length == 0) {
      flutterLocalNotificationsPlugin.cancelAll();
    } else {
      //this bit is probably inefficient but this is what the notification plugin allows
      flutterLocalNotificationsPlugin.cancelAll();
      for (int i = 0; i < _datesList.length; i++) {
        flutterLocalNotificationsPlugin.schedule(
            i,
            'Yakınlarda nöbetin var!',
            'Ayın ${DateTime.fromMillisecondsSinceEpoch(_datesList[i]).day}. gününde nöbetin var.',
            DateTime.fromMillisecondsSinceEpoch(_datesList[i]).subtract(Duration(days: 1)),
            platform);
      }
    }
  }

  Future<void> selectNotification(String payload) async {}

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        height: 450.0,
        margin: EdgeInsets.fromLTRB(15.0, 3.0, 15.0, 3.0),
        child: CalendarCarousel<Event>(
          locale: 'TR',
          onDayPressed: (DateTime date, List<Event> events) {
            this.setState(() {
              _dateCursor = date;
              if (!_datesList.contains(date.millisecondsSinceEpoch)) {
                _datesList.add(date.millisecondsSinceEpoch);
                _markedDateMap.add(
                    date, new Event(date: date, icon: _eventIcon));
              } else {
                _datesList.remove(date.millisecondsSinceEpoch);
                _markedDateMap.remove(
                    date, new Event(date: date, icon: _eventIcon));
              }
              print('$_datesList');
            });
          },
          weekendTextStyle: TextStyle(
            color: Colors.red,
          ),
          thisMonthDayBorderColor: Colors.grey,
          weekFormat: false,
          markedDatesMap: _markedDateMap,
          markedDateShowIcon: true,
          isScrollable: false,
          minSelectedDate: DateTime.now().subtract(Duration(days: 1)),
          markedDateIconBuilder: (Event event) {
            return event.icon;
          },
          selectedDateTime: _dateCursor,
          daysHaveCircularBorder: false,
        ),
      ),
      Container(
        child: RaisedButton(
          child: Text('Seçilen Günleri Onayla'),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            _datesList.sort();
            prefs.setStringList(
                'date_nobet',
                _datesList.map<String>((int a) {
                  return a.toString();
                }).toList());
            _scheduledNotification();
            Fluttertoast.showToast(
                msg: 'Günlerin kaydedildi, bildirimler hazırlandı.',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          },
        ),
      ),
    ]);
  }
}
