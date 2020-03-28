import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService with ChangeNotifier {
  Firestore _db;
  String _roomRef;
  String _userRef;

  DatabaseService() {
    _db = Firestore.instance;
    loadReferencesFromLocal();
  }

  String get roomRef => _roomRef;
  String get userRef => _userRef;

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

  loadReferencesFromLocal() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String roomKeyFromLocal = prefs.getString('roomkey');

    _roomRef = roomKeyFromLocal;
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

    var query = Firestore.instance.collection('rooms').document(roomKey);

    query.get().then((doc) {
      if (doc.exists) {
        query
            .collection('users')
            .document(_userRef)
            .setData({'displayid': displayID});
        prefs.setString('userkey', _userRef);
        prefs.setString('roomkey', _roomRef);
        _roomRef = roomKey;
        notifyListeners();
      } else {
        print('odaya girilemedi');
      }
    });
  }

  exitRoom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var query = _db.collection('rooms/$_roomRef/users').getDocuments();

    query.then((snapshot) {
      if (snapshot.documents.length == 1) {
        _db.document('rooms/$_roomRef/users/$_userRef').delete();
        _db.document('rooms/$_roomRef').delete();
        _roomRef = null;
        _userRef = null;
        notifyListeners();
      } else {
        _db.document('rooms/$_roomRef/users/$_userRef').delete();
        _roomRef = null;
        _userRef = null;
        notifyListeners();
      }
    });

    prefs.remove('userkey');
    prefs.remove('roomkey');
    notifyListeners();
  }

  Stream<QuerySnapshot> queryDatesEqual(int date) {
    return Firestore.instance
        .collection('rooms')
        .document(_roomRef)
        .collection('users')
        .where('dates', arrayContains: date)
        .snapshots();
  }

  Stream<QuerySnapshot> queryDisplayId() {
    return Firestore.instance
        .collection('rooms')
        .document(_roomRef)
        .collection('users')
        .snapshots();
  }
}
