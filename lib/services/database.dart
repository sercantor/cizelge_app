import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService with ChangeNotifier{
  Firestore _db;
  String _roomRef;
  String _userRef;

  DatabaseService(){
    _db = Firestore.instance;
    _roomRef = 'def';
    _userRef = 'def';
  }

  // setters
  setReferences() {
    _roomRef = _db.collection('rooms').document().documentID;
    _userRef = _db.collection('rooms').document('$_roomRef').collection('users').document().documentID;
    notifyListeners();
  }

  // getters
  String get roomRef => _roomRef;
  String get userRef => _userRef;

  Future<String> get roomName async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('roomid');
  }

  Future<String> get displayName async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('displayid');
  }

  setRoomData(String roomID) {
    _db.collection('rooms').document('$_roomRef').setData({'roomid': roomID});
  }
  setUserData(String displayID){
    _db.collection('rooms').document('$_roomRef').collection('users').document('$_userRef').setData({'displayid': displayID});
  }

  Future saveRoomDataLocal(String roomID, String displayID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('roomid', roomID);
    prefs.setString('displayid', displayID);
  }

  updateUserData(List<int> datesList) async {
    print(_roomRef);
    print(_userRef);
    Firestore.instance.collection('rooms')
    .document('$_roomRef')
    .collection('users')
    .document('$_userRef').updateData({'dates': datesList});
  }

  Future<String> getRoomID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String roomID = prefs.getString('roomid');
    return roomID;
  }
  
}
