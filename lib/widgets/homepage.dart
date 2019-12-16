import 'package:flutter/material.dart';
import './takvim_nobet.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Icon(Icons.healing),
      ),
      body: Center(
        child: TakvimNobet(),
      ),
    );
  }
}
