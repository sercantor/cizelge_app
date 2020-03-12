import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final CollectionReference datePrefs = Firestore.instance.collection('dates');

  Future updateUserData(DateTime date) async{
    return await datePrefs.document().setData({'dates': date});
  }
}