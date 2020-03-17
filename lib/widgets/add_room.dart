import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cizelge_app/services/database.dart';
import 'package:provider/provider.dart';

class AddRoomButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var db = Provider.of<DatabaseService>(context);
    TextEditingController roomIdController = TextEditingController();
    TextEditingController userIdController = TextEditingController();
    TextEditingController newRoomIdController =
        TextEditingController(); //TODO: change naming
    TextEditingController newUserIdController =
        TextEditingController(); //TODO: change naming

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
                    padding: EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 12.0),
                    child: SingleChildScrollView(
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
                          Container(
                            padding: EdgeInsets.all(12.0),
                            child: TextFormField(
                              autofocus: false,
                              maxLengthEnforced: true,
                              maxLength: 50,
                              controller: roomIdController,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.home),
                                  labelText: 'Oda İsmi',
                                  border: OutlineInputBorder()),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
                            child: TextFormField(
                              autofocus: false,
                              maxLengthEnforced: true,
                              maxLength: 20,
                              controller: userIdController,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  labelText: 'Kullanıcı İsmin',
                                  border: OutlineInputBorder()),
                            ),
                          ),
                          Center(
                            child: RaisedButton(
                              child: Text('Onayla'),
                              onPressed: () async {
                                db.setReferences();
                                db.setRoomData(roomIdController.text);
                                db.setUserData(userIdController.text);
                                db.saveRoomDataLocal(roomIdController.text, userIdController.text);
                                db.saveReferencesToLocal();
                              },
                            ),
                          ),
                          Center(
                            child: RaisedButton(
                              child: Text('Oda Anahtarini Goster'),
                              onPressed: () async {},
                            ),
                          ),
                          Center(
                            child: RaisedButton(
                              child: Text('Odaya gir'),
                              onPressed: () async {},
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
                            child: TextFormField(
                              autofocus: false,
                              maxLengthEnforced: true,
                              controller: newUserIdController,
                              maxLength: 20,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  labelText: 'Kullanıcı İsmin',
                                  border: OutlineInputBorder()),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
                            child: TextFormField(
                              autofocus: false,
                              maxLengthEnforced: true,
                              controller: newRoomIdController,
                              maxLength: 20,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.home),
                                  labelText: 'Oda Anahtari',
                                  border: OutlineInputBorder()),
                            ),
                          ),
                        ],
                      ),
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
