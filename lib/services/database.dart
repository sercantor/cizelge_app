import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  final CollectionReference _datePrefs = Firestore.instance.collection('rooms');

  Future setUserData(String roomID, String displayID) async{
    DocumentReference indivRef = _datePrefs.document('$roomID/users/$displayID');
    roomID != null && displayID != null ? indivRef.setData({'displayid': displayID}) : print('oda ve kullanic ismi girilmedi');
  }

  Future saveRoomDataLocal(String roomID, String displayID) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('roomid', roomID);
    prefs.setString('displayid', displayID);
  }


  Future<String> get roomName async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('roomid');
  }

  Future<String> get displayName async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('displayid');
  }

}