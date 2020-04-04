import 'package:cizelge_app/models/user.dart';
import 'package:cizelge_app/providers/connectivity_provider.dart';
import 'package:cizelge_app/screens/wrapper.dart';
import 'package:cizelge_app/services/auth.dart';
import 'package:cizelge_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cizelge_app/providers/calendar_provider.dart';

import 'models/connectivity_status.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      StreamProvider<ConnectivityStatus>(create: (context) =>ConnectivityProvider().connectionStatusController.stream,),
      StreamProvider<User>.value(value: AuthService().user),
      ChangeNotifierProvider<DatabaseService>(create: (context) => DatabaseService()),
      ChangeNotifierProvider<CalendarProvider>(create: (context) => CalendarProvider()),
    ], child: MaterialApp(home: Wrapper()));
  }
}
