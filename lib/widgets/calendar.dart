import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:provider/provider.dart';
import 'package:cizelge_app/providers/calendar_provider.dart';
import 'package:cizelge_app/services/database.dart';

class Calendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var calendarProvider = Provider.of<CalendarProvider>(context);
    final DatabaseService _db = DatabaseService();

    return CalendarCarousel(
      onDayPressed: (DateTime date, List<Event> events) {
        calendarProvider.setDateCursor(date);
        calendarProvider.setDate(date);
      },
      onDayLongPressed: (DateTime date) async {
        if (await _db.checkIfInRoom()) {
          _db.printLongPress(date);
        }
      },
      locale: 'TR',
      height: 500,
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
