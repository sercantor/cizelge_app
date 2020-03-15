import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  final CollectionReference _datePrefs = Firestore.instance.collection('rooms');

  Future setUserData(String roomID, String displayID) async {
    DocumentReference indivRef =
        _datePrefs.document('$roomID/users/$displayID');
    roomID != null && displayID != null
        ? indivRef.setData({'displayid': displayID})
        : print('oda ve kullanic ismi girilmedi');
  }

  Future saveRoomDataLocal(String roomID, String displayID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('roomid', roomID);
    prefs.setString('displayid', displayID);
  }

  Future<String> get roomName async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('roomid');
  }

  Future<String> get displayName async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('displayid');
  }

  Future<bool> checkIfInRoom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('roomid') != null &&
        prefs.getString('displayid') != null) {
      return true;
    } else {
      return false;
    }
  }

  updateUserData(List<int> datesList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String roomID = prefs.getString('roomid');
    String displayID = prefs.getString('displayid');
    final DocumentReference datePrefs = Firestore.instance
        .collection('rooms')
        .document('$roomID')
        .collection('users')
        .document('$displayID');
    return await datePrefs.updateData({'dates': datesList});
  }

  Future<void> printLongPress(DateTime date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String roomID = prefs.getString('roomid');

    Firestore.instance
        .collection('rooms')
        .document('$roomID')
        .collection('users')
        .where('dates', arrayContains: date.millisecondsSinceEpoch)
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((doc) {
        print(doc['displayid']);
      });
    });
  }
}
