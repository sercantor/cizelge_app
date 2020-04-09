import 'package:cizelge_app/models/connectivity_status.dart';
import 'package:cizelge_app/models/user.dart';
import 'package:cizelge_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<GlobalKey<FormState>> _formKeys = [
  GlobalKey<FormState>(),
  GlobalKey<FormState>()
];

class AddRoomContents extends StatefulWidget {
  @override
  _AddRoomContentsState createState() => _AddRoomContentsState();
}

class _AddRoomContentsState extends State<AddRoomContents> {
  final TextEditingController createRoomName = TextEditingController();
  final TextEditingController createUserName = TextEditingController();
  final TextEditingController addRoomName = TextEditingController();
  final TextEditingController addUserName = TextEditingController();

  @override
  void dispose() {
    createRoomName.dispose();
    createUserName.dispose();
    addRoomName.dispose();
    addUserName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<DatabaseService>(context);
    final user = Provider.of<User>(context);
    final connectionStatus = Provider.of<ConnectivityStatus>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Form(
                key: _formKeys[0],
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Visibility(
                        child: TextFormField(
                          maxLength: 60,
                          maxLengthEnforced: true,
                          controller: createRoomName,
                          decoration: InputDecoration(
                              labelText: 'Oda İsmi',
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Oda ismi boş olamaz.';
                            }
                            return null;
                          },
                        ),
                        visible: (db.roomRef == null),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        child: TextFormField(
                          maxLength: 20,
                          maxLengthEnforced: true,
                          controller: createUserName,
                          decoration: InputDecoration(
                              labelText: 'Kullanıcı İsmin',
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Kullanıcı ismi boş olamaz.';
                            }
                            return null;
                          },
                        ),
                        visible: (db.roomRef == null),
                      ),
                      Center(
                        child: Visibility(
                          child: RaisedButton(
                            //check internet connection before enabling the button
                            //probably should move this logic elsewhere
                            onPressed: (connectionStatus ==
                                        ConnectivityStatus.Cellular ||
                                    connectionStatus == ConnectivityStatus.Wifi)
                                ? () {
                                    if (_formKeys[0].currentState.validate() &&
                                        db.roomRef == null) {
                                      db.setReferences(user.uid);
                                      db.saveReferencesToLocal();
                                      db.setRoomData(createRoomName.text);
                                      db.saveRoomDataLocal(createRoomName.text,
                                          createUserName.text);
                                      db.setUserData(
                                          createUserName.text, user.avatar);
                                      Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Oda Başarıyla kuruldu')));
                                    } else {
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text('Oda kuluramadı.'),
                                      ));
                                    }
                                  }
                                : null,
                            child: Text('Oda Kur'),
                          ),
                          visible: (db.roomRef == null),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Visibility(
                        child: RaisedButton(
                          onPressed: (connectionStatus ==
                                      ConnectivityStatus.Cellular ||
                                  connectionStatus == ConnectivityStatus.Wifi)
                              ? () {
                                  db.exitRoom(user.uid);
                                  db.deleteFromLocal();
                                }
                              : null,
                          child: Text(
                            'Odadan Çık',
                          ),
                        ),
                        visible: (db.roomRef != null),
                      ),
                      Divider(
                        indent: 15.0,
                        endIndent: 15.0,
                        thickness: 2.5,
                        height: 30.0,
                        color: Colors.red,
                      ),
                      SelectableText(
                        (db.roomRef != null)
                            ? 'Oda anahtarın: ${db.roomRef}'
                            : 'Oda anahatarı bulunamadı.',
                        style: TextStyle(fontSize: 17.0),
                      ),
                      Divider(
                        indent: 15.0,
                        endIndent: 15.0,
                        thickness: 2.5,
                        height: 30.0,
                        color: Colors.red,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Visibility(
                        child: Container(
                          child: Text(
                            'Oda: ${db.roomName}',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        visible: db.roomRef != null,
                      ),
                      SizedBox(height: 20.0,),
                      Visibility(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: db.queryDisplayId(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return CircularProgressIndicator();
                              }
                              return Center(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.documents.length,
                                    itemBuilder: (context, index) {
                                      return _buildUserList(
                                          context,
                                          snapshot.data.documents[index]);
                                    }),
                              );
                            }),
                        visible: db.roomRef != null,
                      )
                    ],
                  ),
                ),
              ),
              Form(
                key: _formKeys[1],
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Visibility(
                        child: TextFormField(
                          maxLength: 20,
                          maxLengthEnforced: true,
                          controller: addUserName,
                          decoration: InputDecoration(
                              labelText: 'Kullanıcı İsmin',
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Kullanıcı ismi boş olamaz.';
                            }
                            return null;
                          },
                        ),
                        visible: (db.roomRef == null),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        child: TextFormField(
                          controller: addRoomName,
                          maxLength: 20,
                          maxLengthEnforced: true,
                          decoration: InputDecoration(
                              labelText: 'Oda Anahtarı',
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Senle paylaşılan oda anahtarını gir.';
                            }
                            return null;
                          },
                        ),
                        visible: (db.roomRef == null),
                      ),
                      Visibility(
                        child: RaisedButton(
                          onPressed: (connectionStatus ==
                                      ConnectivityStatus.Cellular ||
                                  connectionStatus == ConnectivityStatus.Wifi)
                              ? () async {
                                  if (_formKeys[1].currentState.validate()) {
                                    if (await db.addUserToRoom(
                                        addUserName.text,
                                        addRoomName.text,
                                        user.uid,
                                        user.avatar)) {
                                      db.queryRoomName();
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Odaya başarıyla girildi.'),
                                        ),
                                      );
                                    } else {
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Odaya girilemedi. Anahtarı yanlış girmiş olabilir misin?'),
                                        ),
                                      );
                                    }
                                  }
                                }
                              : null,
                          child: Text('Odaya Gir'),
                        ),
                        visible: db.roomRef == null,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserList(
      BuildContext context, DocumentSnapshot document) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20.0,
        backgroundImage: document['avatar'].toString() != null
            ? NetworkImage(document['avatar'].toString(), scale: 3.0)
            : ExactAssetImage('./lib/assets/x.png', scale: 10.0),
        backgroundColor: Colors.transparent,
      ),
      title: Text(
        document['displayid'].toString(),
        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
