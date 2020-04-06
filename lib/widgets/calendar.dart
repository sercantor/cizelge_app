import 'package:cizelge_app/widgets/show_coworker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:provider/provider.dart';
import 'package:cizelge_app/providers/calendar_provider.dart';
import 'package:cizelge_app/services/database.dart';

class Calendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final calendarProvider = Provider.of<CalendarProvider>(context);
    final db = Provider.of<DatabaseService>(context);
    return CalendarCarousel(
      onDayPressed: (DateTime date, List<Event> events) {
        calendarProvider.setDateCursor(date);
        calendarProvider.setDate(date);
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
      selectedDateTime: calendarProvider.dateCursor,
      markedDatesMap: calendarProvider.markedDateMap,
      daysHaveCircularBorder: false,
      thisMonthDayBorderColor: Colors.grey,
      selectedDayButtonColor: Colors.green,
      minSelectedDate: DateTime.now().subtract(Duration(days: 1)),
    );
  }
}
