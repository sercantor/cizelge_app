import 'package:cizelge_app/services/auth.dart';
import 'package:cizelge_app/widgets/send_data_button.dart';
import 'package:flutter/material.dart';
import 'package:cizelge_app/widgets/calendar.dart';
import 'package:cizelge_app/widgets/add_room.dart';

class HomePage extends StatelessWidget {
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () async {
              await _auth.signOut();
            },
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            label: Text(
              'Çıkış yap',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        title: Text(
          'çizelge app',
        style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
