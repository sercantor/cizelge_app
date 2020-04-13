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
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Center(
                  child: Text(
                    'Ayın ${date.day}. Gününde Çalışanlar',
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                StreamBuilder(
                    stream: db.queryDatesEqual(date.millisecondsSinceEpoch),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      return Container(
                        height: 400,
                        child: ListView.builder(
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              return _buildList(context,
                                  snapshot.data.documents[index], date);
                            }),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  //I feel like this is highly inefficient (for querying) and very complex to read
  //I need to figure out if this is OK or not
  Widget _buildList(
      BuildContext context, DocumentSnapshot document, DateTime date) {
    List<String> workStartingTime = List<String>();
    List<String> workEndingTime = List<String>();
    //check the first index, if it is 24 or 16, then just print 24 or 16, else print
    //manual data
    bool checkIfFirstIndexIsFixed = false;

    //need to check if datesmap is empty, or I get error, this is a bad workaround
    for (int i = 0; i < 2; i++)
      workStartingTime.add(document['datesmap']
              ['${date.millisecondsSinceEpoch.toString()}'][i]
          .toString());

    for (int i = 2; i < 4; i++)
      workEndingTime.add(document['datesmap']
              ['${date.millisecondsSinceEpoch.toString()}'][i]
          .toString());

    if (workStartingTime[0] == '24' || workStartingTime [0] == '16') {
      checkIfFirstIndexIsFixed = !checkIfFirstIndexIsFixed;
    }

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
      //worst piece of software ever written
      subtitle: checkIfFirstIndexIsFixed == true
          ? Text(workStartingTime[0] == '24' ? '24 Saat' : '16 Saat')
          : Text(
              'Başlangıç saati - ${workStartingTime[0]} : ${workStartingTime[1]} \nBitiş Saati - ${workEndingTime[0]} : ${workEndingTime[1]}'),
    );
  }
}
