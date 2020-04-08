import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService with ChangeNotifier {
  Firestore _db;
  String _roomRef;
  String _userRef;
  String _roomName;
  DatabaseService() {
    _db = Firestore.instance;
    loadReferencesFromLocal();
  }

  //TODO: useRref is useless here
  String get roomRef => _roomRef;
  String get userRef => _userRef;
  String get roomName => _roomName;

  // setters
  setReferences(String uid) async {
    _roomRef = _db.collection('rooms').document().documentID;
    _userRef = uid;
    notifyListeners();
  }

  loadReferencesFromLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String roomKeyFromLocal = prefs.getString('roomkey');
    String roomName = prefs.getString('roomid');

    _roomName = roomName;
    _roomRef = roomKeyFromLocal;
    notifyListeners();
  }

  Future<void> deleteFromLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userkey');
    prefs.remove('roomkey');
    prefs.remove('roomid');
    prefs.remove('userid');
  }

  setRoomData(String roomID) {
    _db.collection('rooms').document('$_roomRef').setData({'roomid': roomID});
    _roomName = roomID;
    notifyListeners();
  }

  setUserData(String displayID, String avatar) {
    print(avatar);
    _db
        .collection('rooms')
        .document('$_roomRef')
        .collection('users')
        .document('$_userRef')
        .setData({'displayid': displayID, 'avatar': avatar});
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

  updateUserData(Map<String, dynamic> datesMap) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String roomKey = prefs.getString('roomkey');
    String userKey = prefs.getString('userkey');

    Firestore.instance
        .collection('rooms')
        .document('$roomKey')
        .collection('users')
        .document('$userKey')
        .updateData({'datesmap': datesMap});
  }

  Future<String> getUserKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userKey = prefs.getString('userkey');
    return userKey;
  }

  Future<bool> addUserToRoom(
      String displayID, String roomKey, String uid, String avatar) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DocumentSnapshot roomDocument =
        await _db.collection('rooms').document(roomKey).get();
    bool didEnterRoom = false;

    if (roomDocument.exists) {
      _roomRef = roomKey;
      notifyListeners();
      _db
          .collection('rooms')
          .document(roomKey)
          .collection('users')
          .document(uid)
          .setData({'displayid': displayID, 'avatar': avatar});
      prefs.setString('userkey', uid);
      prefs.setString('roomkey', roomKey);
      didEnterRoom = true;
      return didEnterRoom;
    } else {
      print('odaya girilemedi');
      didEnterRoom = false;
      return didEnterRoom;
    }
  }

  Future<void> exitRoom(String uid) async {
    print(_roomRef);
    print(uid);
    QuerySnapshot query = await _db
        .collection('rooms')
        .document(_roomRef)
        .collection('users')
        .getDocuments();

    if (query.documents.length == 1) {
      _db
          .collection('rooms')
          .document(_roomRef)
          .collection('users')
          .document(uid)
          .delete();
      _db.collection('rooms').document(_roomRef).delete();
      _roomRef = null;
      _userRef = null;
      _roomName = null;
      notifyListeners();
    } else {
      _db.document('rooms/$_roomRef/users/$uid').delete();
      _roomRef = null;
      _userRef = null;
      _roomName = null;
      notifyListeners();
    }
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
    return _db
        .collection('rooms')
        .document(_roomRef)
        .collection('users')
        .snapshots();
  }

  Future<void> queryRoomName() async {
    _db.collection('rooms').document(_roomRef).get().then((doc) {
      _roomName = doc['roomid'].toString();
      notifyListeners();
    });
  }
}
