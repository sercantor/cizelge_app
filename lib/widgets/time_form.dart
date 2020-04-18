import 'package:flutter/material.dart';

//form that shows up when the user clicks a day, it's a mess, I should handle the form logic in a different way
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
  final FocusNode startHourNode = FocusNode();
  final FocusNode startMinuteNode = FocusNode();
  final FocusNode endHourNode = FocusNode();
  final FocusNode endMinuteNode = FocusNode();

  @override
  void dispose() {
    startHour.dispose();
    startMinute.dispose();
    endHour.dispose();
    endMinute.dispose();
    super.dispose();
  }

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
                          textInputAction: TextInputAction.next,
                          maxLength: 2,
                          onChanged: (val) {
                            _nextStep(
                                val, context, startHourNode, startMinuteNode);
                          },
                          controller: startHour,
                          focusNode: startHourNode,
                          maxLengthEnforced: true,
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val.isEmpty ||
                                (int.parse(val) > 23 || int.parse(val) < 0))
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
                          textInputAction: TextInputAction.next,
                          onChanged: (val) {
                            _nextStep(
                                val, context, startMinuteNode, endHourNode);
                          },
                          maxLength: 2,
                          focusNode: startMinuteNode,
                          controller: startMinute,
                          maxLengthEnforced: true,
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val.isEmpty ||
                                (int.parse(val) > 59 || int.parse(val) < 0))
                              return ' ';
                            else
                              return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Text('Mesai Bitiş Saati'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 30,
                        child: TextFormField(
                          maxLength: 2,
                          controller: endHour,
                          onChanged: (val) {
                            _nextStep(val, context, endHourNode, endMinuteNode);
                          },
                          focusNode: endHourNode,
                          maxLengthEnforced: true,
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val.isEmpty ||
                                (int.parse(val) > 23 || int.parse(val) < 0))
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
                          focusNode: endMinuteNode,
                          controller: endMinute,
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val.isEmpty ||
                                (int.parse(val) > 59 || int.parse(val) < 0))
                              return ' ';
                            else
                              return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
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
                        textColor: Colors.white,
                        child: Text('24 saat'),
                        color: Colors.redAccent,
                        onPressed: () {
                          List<String> hoursAndMinutes = [
                            '24',
                            'saat',
                            '24',
                            'saat'
                          ];
                          Navigator.of(context).pop(hoursAndMinutes);
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
                  ),
                  FlatButton(
                    textColor: Colors.white,
                    child: Text('16 saat'),
                    color: Colors.orangeAccent,
                    onPressed: () {
                      List<String> hoursAndMinutes = [
                        '16',
                        'saat',
                        '16',
                        'saat'
                      ];
                      Navigator.of(context).pop(hoursAndMinutes);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _nextStep(String val, BuildContext context, FocusNode currentNode,
      FocusNode nextNode) {
    if (val.length == 2) {
      print(val);
      currentNode.unfocus();
      FocusScope.of(context).requestFocus(nextNode);
    }
  }
}
