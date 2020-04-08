import 'package:flutter/material.dart';

class TimeForm extends StatefulWidget {
  @override
  _TimeFormState createState() => _TimeFormState();
}

class _TimeFormState extends State<TimeForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController startHour = TextEditingController();
  final TextEditingController startMinute = TextEditingController();
  final TextEditingController endHour = TextEditingController();
  final TextEditingController endMinute = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 30,
                        child: TextFormField(
                          maxLength: 2,
                          controller: startHour,
                          maxLengthEnforced: true,
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val.isEmpty)
                              return ' ';
                            else
                              return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 30,
                        child: TextFormField(
                          maxLength: 2,
                          controller: startMinute,
                          maxLengthEnforced: true,
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val.isEmpty)
                              return ' ';
                            else
                              return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 30,
                        child: TextFormField(
                          maxLength: 2,
                          controller: endHour,
                          maxLengthEnforced: true,
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val.isEmpty)
                              return ' ';
                            else
                              return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 30,
                        child: TextFormField(
                          maxLength: 2,
                          controller: endMinute,
                          maxLengthEnforced: true,
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val.isEmpty)
                              return ' ';
                            else
                              return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          'Vazgeç',
                          style: TextStyle(color: Colors.grey),
                        ),
                        onPressed: () {
                          Navigator.pop(context,[]);
                        },
                      ),
                      FlatButton(
                        child: Text(
                          'Onayla',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Navigator.of(context).pop([startHour.text, startMinute.text, endHour.text, endMinute.text]);
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
