import 'package:cizelge_app/models/room.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cizelge_app/services/auth.dart';
import 'package:cizelge_app/services/database.dart';

class AddRoomButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final room = Provider.of<Room>(context);
    final AuthService _auth = AuthService();
    final DatabaseService _db = DatabaseService();
    TextEditingController roomIdController = TextEditingController();
    TextEditingController userIdController = TextEditingController();

    return FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Container(
                  height: 600,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Oda Kur',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                          width: 20.0,
                        ),
                        Container(
                          padding: EdgeInsets.all(12.0),
                          child: TextFormField(
                            autofocus: false,
                            maxLengthEnforced: true,
                            maxLength: 20,
                            controller: roomIdController,
                            decoration: InputDecoration(
                                labelText: 'Oda İsmi',
                                border: OutlineInputBorder()),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(12.0),
                          child: TextFormField(
                            autofocus: false,
                            maxLengthEnforced: true,
                            maxLength: 20,
                            controller: userIdController,
                            decoration: InputDecoration(
                                labelText: 'Kullanıcı İsmin',
                                border: OutlineInputBorder()),
                          ),
                        ),
                        Center(
                          child: RaisedButton(
                            child: Text('Onayla'),
                            onPressed: () async {
                              _auth.signInAnon();
                              _db.updateUserData(userIdController.text);
                            },
                          ),
                        ),
                        Center(
                          child: RaisedButton(
                            onPressed: () async {
                              _auth.signOut();
                            },
                          ),
                        ),
                        Center(child: room != null ? SelectableText('Dahil olduğun oda IDsi: ${room.roomID}',) : Text('Bir odaya dahil değilsin'),)
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add));
  }
  
}
