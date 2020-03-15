import 'package:cizelge_app/widgets/send_data_button.dart';
import 'package:flutter/material.dart';
import 'package:cizelge_app/widgets/calendar.dart';
import 'package:cizelge_app/widgets/add_room.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cizelge App'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Calendar(),
              SendDataButton(),
            ],
          ),
        ),
      ),
      floatingActionButton: AddRoomButton(),
    );
  }
}
