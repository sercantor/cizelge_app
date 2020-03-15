import 'package:cizelge_app/providers/calendar_provider.dart';
import 'package:cizelge_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class SendDataButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var calendarProvider = Provider.of<CalendarProvider>(context);
    final DatabaseService _db = DatabaseService();

    return Container(
      child: RaisedButton(
        child: Text('Seçtiğim Günleri İnternete Gönder'),
        onPressed: () async {
          if (await _db.checkIfInRoom()) {
            _db.updateUserData(calendarProvider.datesList);
          }
        },
      ),
    );
  }
}
