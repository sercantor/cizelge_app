import 'package:cizelge_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddRoomContents extends StatefulWidget {
  @override
  _AddRoomContentsState createState() => _AddRoomContentsState();
}

class _AddRoomContentsState extends State<AddRoomContents> {
  final roomIdController = TextEditingController();
  final userIdController = TextEditingController();
  final newRoomKeyController = TextEditingController(); //TODO: change naming
  final newUserIdController = TextEditingController(); //TODO: change naming
  bool isButtonDisabled;
  bool isButtonDisabledAddUser;

  @override
  void initState() {
    super.initState();
    isButtonDisabled = false;
    isButtonDisabledAddUser = false;
    roomIdController.addListener(_checkIfEmpty);
    userIdController.addListener(_checkIfEmpty);
    newUserIdController.addListener(_checkIfEmptyAddUser);
    newRoomKeyController.addListener(_checkIfEmptyAddUser);
  }

  @override
  void dispose() {
    roomIdController.dispose();
    userIdController.dispose();
    newUserIdController.addListener(_checkIfEmptyAddUser);
    newRoomKeyController.addListener(_checkIfEmptyAddUser);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var db = Provider.of<DatabaseService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Oda Kur/Odaya Gir'),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 12.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      border: OutlineInputBorder(),
                    ),
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
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Center(
                  child: RaisedButton(
                    child: Text('Onayla'),
                    onPressed: isButtonDisabled
                        ? () {
                            setState(() {
                              isButtonDisabled =
                                  false; //TODO: this is really really hacky, think about this
                              isButtonDisabledAddUser = false;
                            });
                            db.setReferences();
                            db.setRoomData(roomIdController.text);
                            db.setUserData(userIdController.text);
                            db.saveRoomDataLocal(
                                roomIdController.text, userIdController.text);
                            db.saveReferencesToLocal();
                          }
                        : null,
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
                  child: FutureBuilder(
                    future: db.getRoomKey(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return snapshot.hasData
                          ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SelectableText(
                                'Oda Anahtarın: ${snapshot.data}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                          )
                          : Text('Anahtar Bulunamadi');
                    },
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      child: Text('Odamdaki Kisileri Goster'),
                      onPressed: () async {
                        String roomID = await db.getRoomKey();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Container(
                                height: 450,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    children: <Widget>[
                                      StreamBuilder(
                                          //TODO: move this widget to somewhere else
                                          stream: Firestore.instance
                                              .collection('rooms')
                                              .document(roomID)
                                              .collection('users')
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return CircularProgressIndicator();
                                            }
                                            return Container(
                                              height: 400,
                                              width: 100,
                                              child: ListView.builder(
                                                  itemCount: snapshot
                                                      .data.documents.length,
                                                  itemBuilder: (context, index) {
                                                    return _buildUserList(
                                                        context,
                                                        snapshot.data
                                                            .documents[index]);
                                                  }),
                                            );
                                          })
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
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
                Center(
                  child: RaisedButton(
                    child: Text('Odaya gir'),
                    onPressed: isButtonDisabledAddUser
                        ? () {
                            db.addUserToRoom(newUserIdController.text,
                                newRoomKeyController.text);
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserList(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Text(document['displayid']),
    );
  }

  _checkIfEmpty() async {
    final prefs = await SharedPreferences.getInstance();
    String roomKey;
    setState(() {
      roomKey = prefs.getString('roomkey');
    });
    if (roomIdController.text.isEmpty ||
        userIdController.text.isEmpty ||
        (roomKey != null)) {
      setState(() {
        isButtonDisabled = false;
      });
    } else {
      setState(() {
        isButtonDisabled = true;
      });
    }
  }

  _checkIfEmptyAddUser() async {
    final prefs = await SharedPreferences.getInstance();
    String roomKey;
    setState(() {
      roomKey = prefs.getString('roomkey');
    });

    if (newRoomKeyController.text.isEmpty ||
        newUserIdController.text.isEmpty ||
        (roomKey != null)) {
      setState(() {
        isButtonDisabledAddUser = false;
      });
    } else {
      setState(() {
        isButtonDisabledAddUser = true;
      });
    }
  }
}