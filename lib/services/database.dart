import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final DocumentReference datePrefs = Firestore.instance.collection('rooms').document('room1').collection('users').document('user1');

  Future updateUserData(String displayID) async{
    return await datePrefs.updateData({'displayname': displayID});
  }
}