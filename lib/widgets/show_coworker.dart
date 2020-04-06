import 'package:cizelge_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowCoworker extends StatelessWidget {
  final DateTime date;
  ShowCoworker({Key key, @required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<DatabaseService>(context);

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
              Center(
                child: Text(
                  'Ayın ${date.day}. Gününde Nöbet Yapanlar',
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                ),
              ),
              StreamBuilder(
                  stream: db.queryDatesEqual(date.millisecondsSinceEpoch),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    return Container(
                      height: 400,
                      width: 100,
                      child: ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            return _buildList(
                                context, snapshot.data.documents[index]);
                          }),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Text(document['displayid'].toString()),
    );
  }
}
