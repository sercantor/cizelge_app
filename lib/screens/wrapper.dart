import 'package:cizelge_app/models/user.dart';
import 'package:cizelge_app/screens/home.dart';
import 'package:cizelge_app/screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null) {
      return SignIn();
    } else {
      return HomePage();
    }
  }
}
