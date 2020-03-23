import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService with ChangeNotifier {
  Firestore _db;
  String _roomRef;
  String _userRef;
  bool _showRoomKey = false;

  DatabaseService() {
    _db = Firestore.instance;
  }

  bool get showRoomKey => _showRoomKey;

  // setters
  setReferences() async {
    _roomRef = _db.collection('rooms').document().documentID;
    _userRef = _db
        .collection('rooms')
        .document('$_roomRef')
        .collection('users')
        .document()
        .documentID;

    notifyListeners();
  }

  setRoomData(String roomID) {
    _db.collection('rooms').document('$_roomRef').setData({'roomid': roomID});
  }

  setUserData(String displayID) {
    _db
        .collection('rooms')
        .document('$_roomRef')
        .collection('users')
        .document('$_userRef')
        .setData({'displayid': displayID});
  }

  Future saveRoomDataLocal(String roomID, String displayID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('roomid', roomID);
    prefs.setString('displayid', displayID);
  }

  saveReferencesToLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('roomkey', '$_roomRef');
    prefs.setString('userkey', '$_userRef');
  }

  updateUserData(List<int> datesList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String roomKey = prefs.getString('roomkey');
    String userKey = prefs.getString('userkey');

    Firestore.instance
        .collection('rooms')
        .document('$roomKey')
        .collection('users')
        .document('$userKey')
        .updateData({'dates': datesList});
  }

  //unofficial getters? idk what I'm doing at this point

  Future<String> getRoomKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String roomKey = prefs.getString('roomkey');
    return roomKey;
  }

  Future<String> getUserKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userKey = prefs.getString('userkey');
    return userKey;
  }

  addUserToRoom(String displayID, String roomKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userRef = Firestore.instance
        .collection('rooms')
        .document(roomKey)
        .collection('users')
        .document()
        .documentID;

    var query = Firestore.instance
        .collection('rooms')
        .document(roomKey);

    query.get().then((doc) {
      if (doc.exists) {
        query.collection('users').document(_userRef).setData({'displayid': displayID});
        prefs.setString('userkey', _userRef);
        prefs.setString('roomkey', _roomRef);
      } else{ print('room does not exist');}
    });
  }

  exitRoom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userKey = await getUserKey();
    String roomKey = await getRoomKey();
    _db
        .collection('rooms')
        .document(roomKey)
        .collection('users')
        .getDocuments()
        .then((snapshot) {
      if (snapshot.documents.length == 1) {
        //this is potentially bad for scaling, though I assume rooms are not going to be above 15-20 users
        _db.collection('rooms').document(roomKey).delete();
      } else {
        _db
            .collection('rooms')
            .document(roomKey)
            .collection('users')
            .document(userKey)
            .delete();
      }
    });
    prefs.remove('userkey');
    prefs.remove('roomkey');
  }

  changeBool() {
    _showRoomKey = !_showRoomKey;
    notifyListeners();
  }
}
