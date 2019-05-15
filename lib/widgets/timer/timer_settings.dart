import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class TimerSettings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TimerSettingsState();
  }
}

class _TimerSettingsState extends State<TimerSettings> {
  Duration _prep_duration = Duration(hours: 0, minutes: 0);
  Duration _med_duration = Duration(hours: 0, minutes: 0);
  int prep_minutes = 20;
  int prep_hours = 0;
  int med_hours = 0;
  int med_minutes = 0;

  Timer _timer;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              if (prep_minutes < 1) {
                timer.cancel();
              } else {
                prep_minutes = prep_minutes - 1;
              }
            }));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/images/bowl.png',
              width: MediaQuery.of(context).size.width * 0.3),
          Container(
            child: Column(
              children: <Widget>[
                FlatButton(
                  onPressed: () async {
                    // Use it as a dialog, passing in an optional initial time
                    // and returning a promise that resolves to the duration
                    // chosen when the dialog is accepted. Null when cancelled.
                    Duration preparationDuration = await showDurationPicker(
                      context: context,
                      initialTime: _prep_duration,
                    );
                    this.setState(
                      () {
                        _prep_duration = preparationDuration;
                        prep_hours = _prep_duration.inHours;
                        prep_minutes = _prep_duration.inMinutes;
                      },
                    );
                    //Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Chose duration: $preparationDuration")));
                  },
                  child: Text(
                    'Preparation: ${_prep_duration.inHours}:${_prep_duration.inMinutes}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.red),
                  ),
                ),
                FlatButton(
                  onPressed: () async {
                    // Use it as a dialog, passing in an optional initial time
                    // and returning a promise that resolves to the duration
                    // chosen when the dialog is accepted. Null when cancelled.
                    Duration meditationDuration = await showDurationPicker(
                      context: context,
                      initialTime: _med_duration,
                    );
                    this.setState(
                      () {
                        _med_duration = meditationDuration;
                        med_hours = _med_duration.inHours;
                        med_minutes = _med_duration.inMinutes;
                      },
                    );
                    //Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Chose duration: $meditationDuration")));
                  },
                  child: Text(
                    'Meditation: ${_med_duration.inHours}:${_med_duration.inMinutes}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
          RaisedButton(
            color: Colors.blueGrey,
            onPressed: () {
              startTimer();
            },
            child: Text("Meditate"),
          ),
        ],
      ),
    );
  }
}
