import 'package:cizelge_app/screens/add_room_contents.dart';
import 'package:flutter/material.dart';
import 'package:cizelge_app/services/database.dart';
import 'package:provider/provider.dart';

class AddRoomButton extends StatefulWidget {
  @override
  _AddRoomButtonState createState() => _AddRoomButtonState();
}

class _AddRoomButtonState extends State<AddRoomButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        onPressed: () {
          final db = Provider.of<DatabaseService>(context, listen: false);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ChangeNotifierProvider.value(
                value: db, child: AddRoomContents());
          }));
        },
        child: Icon(Icons.home));
  }
}
