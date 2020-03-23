import 'package:cizelge_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddRoomContents extends StatefulWidget {
  @override
  _AddRoomContentsState createState() => _AddRoomContentsState();
}

class _AddRoomContentsState extends State<AddRoomContents> {
  @override
  Widget build(BuildContext context) {
    var db = Provider.of<DatabaseService>(context);
    TextEditingController roomIdController = TextEditingController();
    TextEditingController userIdController = TextEditingController();
    TextEditingController newRoomKeyController =
        TextEditingController(); //TODO: change naming
    TextEditingController newUserIdController =
        TextEditingController(); //TODO: change naming

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
                        fontWeight: FontWeight.bold, color: Colors.redAccent),
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
                      db.saveRoomDataLocal(
                          roomIdController.text, userIdController.text);
                      db.saveReferencesToLocal();
                    },
                  ),
                ),
                Center(
                  child: RaisedButton(
                    child: Text('Odadan Cik'),
                    onPressed: () {
                      db.exitRoom();
                    },
                  ),
                ),
                Center(
                  child: RaisedButton(
                    child: Text('Oda Anahatari Goster'),
                    onPressed: () {
                      db.changeBool();
                    },
                  ),
                ),
                Center(
                  child: RaisedButton(
                    child: Text('Odaya gir'),
                    onPressed: () {
                      db.addUserToRoom(
                          newUserIdController.text, newRoomKeyController.text);
                    },
                  ),
                ),
                Center(
                  child: Visibility(
                    child: FutureBuilder(
                      future: db.getRoomKey(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        return snapshot.hasData
                            ? SelectableText(snapshot.data)
                            : Text('Anahtar Bulunamadi');
                      },
                    ),
                    visible: db.showRoomKey,
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
                    controller: newRoomKeyController,
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
  }
}
