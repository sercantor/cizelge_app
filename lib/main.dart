import 'package:flutter/material.dart';
import './widgets/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.redAccent),
        primarySwatch: Colors.red,
      ),
      home: HomePage(),
    );
  }
}
