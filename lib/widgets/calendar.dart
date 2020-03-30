import 'package:cloud_firestore/cloud_firestore.dart';
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
    var db = Provider.of<DatabaseService>(context);
    return CalendarCarousel(
      onDayPressed: (DateTime date, List<Event> events) {
        calendarProvider.setDateCursor(date);
        calendarProvider.setDate(date);
      },
      onDayLongPressed: (DateTime date) async {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Container(
                height: 450,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text(
                          'Ayın ${date.day}. Gününde Nöbet Yapanlar',
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      StreamBuilder(
                          stream:
                              db.queryDatesEqual(date.millisecondsSinceEpoch),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            }
                            return Container(
                              height: 400,
                              width: 100,
                              child: ListView.builder(
                                  itemCount: snapshot.data.documents.length,
                                  itemBuilder: (context, index) {
                                    return _buildList(context,
                                        snapshot.data.documents[index]);
                                  }),
                            );
                          })
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
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

  Widget _buildList(BuildContext context, DocumentSnapshot document) {
    //TODO: move this widget to somewhere else
    return ListTile(
      title: Text(document['displayid']),
    );
  }
}
