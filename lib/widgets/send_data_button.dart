import 'package:cizelge_app/models/connectivity_status.dart';
import 'package:cizelge_app/providers/calendar_provider.dart';
import 'package:cizelge_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class SendDataButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var calendarProvider = Provider.of<CalendarProvider>(context);
    var db = Provider.of<DatabaseService>(context);
    var connectionStatus = Provider.of<ConnectivityStatus>(context);

    return Container(
        child: RaisedButton(
          child: Text('Seçtiğim Günleri İnternete Gönder'),
          onPressed: (db.roomRef != null && 
          //check internet connection
          (connectionStatus == ConnectivityStatus.Cellular || connectionStatus == ConnectivityStatus.Wifi))
              ? () {
                  db.updateUserData(calendarProvider.datesList);
                }
              : null,
        ),
    );
  }
}
