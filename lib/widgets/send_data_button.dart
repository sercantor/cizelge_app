import 'package:cizelge_app/providers/calendar_provider.dart';
import 'package:cizelge_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class SendDataButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var calendarProvider = Provider.of<CalendarProvider>(context);
    var db = Provider.of<DatabaseService>(context);

    return Container(
      child: RaisedButton(
        child: Text('Seçtiğim Günleri İnternete Gönder'),
        onPressed: () async {
          db.updateUserData(calendarProvider.datesList);
        },
      ),
    );
  }
}
