import 'package:cizelge_app/widgets/show_coworker.dart';
import 'package:cizelge_app/widgets/time_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:provider/provider.dart';
import 'package:cizelge_app/providers/calendar_provider.dart';
import 'package:cizelge_app/services/database.dart';

//TODO: add a timeout to 'send dates to internet' button
class Calendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final calendarProvider = Provider.of<CalendarProvider>(context);
    final db = Provider.of<DatabaseService>(context);
    List<String> hoursAndMinutes = List<String>();

    return CalendarCarousel(
      onDayPressed: (DateTime date, List<Event> events) async {
        calendarProvider.setDateCursor(date);
        print(calendarProvider.datesMap);
        if (!calendarProvider.datesList.contains(date.millisecondsSinceEpoch)) {
          hoursAndMinutes = await showDialog(
              context: context,
              builder: (_) {
                final db = Provider.of<DatabaseService>(context, listen: false);
                return ChangeNotifierProvider.value(
                  value: db,
                  child: TimeForm(),
                );
              });
          if (hoursAndMinutes != null) {
            calendarProvider.setDate(date, hoursAndMinutes);
            calendarProvider.setDateMap(
                date.millisecondsSinceEpoch.toString(), hoursAndMinutes);
          }
        } else {
          showDialog(
              context: context,
              builder: (_) {
                return Dialog(
                  child: Text('asd'),
                );
              });
          calendarProvider.setDate(date, hoursAndMinutes);
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
          : (DateTime date) {},
      locale: 'TR',
      height: 400,
      width: 340,
      selectedDateTime: calendarProvider.dateCursor,
      markedDatesMap: calendarProvider.markedDateMap,
      daysHaveCircularBorder: false,
      markedDateShowIcon: true,
      markedDateIconBuilder: (Event event) {
        return event.icon;
      },
      thisMonthDayBorderColor: Colors.grey,
      selectedDayButtonColor: Colors.green,
      minSelectedDate: DateTime.now().subtract(Duration(days: 1)),
    );
  }
}
