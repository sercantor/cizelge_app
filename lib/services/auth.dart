import 'package:cizelge_app/models/room.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create room object based on FirebaseUser
  Room _userFromFirebaseUser(FirebaseUser room) {
    return room != null ? Room(roomID: room.uid) : null;
  }

  //auth change room stream
  Stream<Room> get room {
    return _auth.onAuthStateChanged
    .map(_userFromFirebaseUser);
  }

  Future signInAnon() async{
    try{
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser room = result.user;
      return _userFromFirebaseUser(room);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try{
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }
}