import 'package:cizelge_app/widgets/show_coworker.dart';
import 'package:cizelge_app/widgets/time_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:provider/provider.dart';
import 'package:cizelge_app/providers/calendar_provider.dart';
import 'package:cizelge_app/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class Calendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    final calendarProvider = Provider.of<CalendarProvider>(context);
    final db = Provider.of<DatabaseService>(context);

    return CalendarCarousel(
      onDayPressed: (DateTime date, List<Event> events) async {
        calendarProvider.setDateCursor(date);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        print(prefs.getString('datesMap'));
        if (!calendarProvider.datesList.contains(date.millisecondsSinceEpoch)) {
          List<String> hoursAndMinutes = await showDialog(
              context: context,
              builder: (_) {
                final db = Provider.of<DatabaseService>(context, listen: false);
                return ChangeNotifierProvider.value(
                  value: db,
                  child: TimeForm(),
                );
              });
          if (hoursAndMinutes != null) {
            calendarProvider.setDate(date);
            calendarProvider.setDateMap(
                date.millisecondsSinceEpoch.toString(), hoursAndMinutes);
          }
        } else {
          calendarProvider.setDate(date);
          calendarProvider
              .removeDateMap(date.millisecondsSinceEpoch.toString());
        }
      },
      // popup on longpress, show coworkers working on the same date, provide db to dialog
      onDayLongPressed: (db.roomRef != null)
          ? (DateTime date) {
              final db = Provider.of<DatabaseService>(context, listen: false);
              return showDialog(
                  context: context,
                  builder: (_) {
                    return ChangeNotifierProvider.value(
                      value: db,
                      child: ShowCoworker(
                        date: date,
                      ),
                    );
                  });
            }
          : null,
      locale: 'TR',
      height: 400,
      width: 340,
      daysTextStyle: brightnessValue == Brightness.dark
          ? TextStyle(color: Colors.white)
          : null,
      selectedDateTime: calendarProvider.dateCursor,
      markedDatesMap: calendarProvider.markedDateMap,
      daysHaveCircularBorder: false,
      markedDateWidget: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 1.0,
        ),
        color: Colors.blueAccent,
        height: 7.0,
        width: 8.5,
      ),
      thisMonthDayBorderColor: Colors.grey,
      selectedDayButtonColor: Colors.green,
      minSelectedDate: DateTime.now().subtract(Duration(days: 1)),
    );
  }
}
