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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text('Mesai Başlangıç Saati'),
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
                            if (val.isEmpty ||
                                (int.parse(val) > 24 || int.parse(val) < 0))
                              return ' ';
                            else
                              return null;
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Text(
                          ':',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: 30,
                        child: TextFormField(
                          maxLength: 2,
                          controller: startMinute,
                          maxLengthEnforced: true,
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val.isEmpty ||
                                (int.parse(val) > 60 || int.parse(val) < 0))
                              return ' ';
                            else
                              return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Divider(
                    thickness: 1.0,
                  ),
                  Text('Mesai Bitiş Saati'),
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
                            if (val.isEmpty ||
                                (int.parse(val) > 24 || int.parse(val) < 0))
                              return ' ';
                            else
                              return null;
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Text(
                          ':',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: 30,
                        child: TextFormField(
                          maxLength: 2,
                          controller: endMinute,
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val.isEmpty ||
                                (int.parse(val) > 60 || int.parse(val) < 0))
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
                          Navigator.pop(context, null);
                        },
                      ),
                      FlatButton(
                        child: Text(
                          'Onayla',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                        onPressed: () {
                          List<String> hoursAndMinutes = [
                              startHour.text,
                              startMinute.text,
                              endHour.text,
                              endMinute.text
                            ];
                          if (_formKey.currentState.validate()) {
                            Navigator.of(context).pop(hoursAndMinutes);
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
