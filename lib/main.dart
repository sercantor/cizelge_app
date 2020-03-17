import 'package:cizelge_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cizelge_app/providers/calendar_provider.dart';
import 'package:cizelge_app/screens/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Cizelge App',
        home: ChangeNotifierProvider<DatabaseService>(
          create: (context) => DatabaseService(),
          child: ChangeNotifierProvider<CalendarProvider>(
            create: (context) => CalendarProvider(),
            child: HomePage(),
          ),
        ));
  }
}
