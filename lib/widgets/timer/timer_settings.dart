import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'dart:async';

class TimerSettings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TimerSettingsState();
  }
}

class _TimerSettingsState extends State<TimerSettings> {
  Duration _duration = Duration(hours: 0, minutes: 0);
  int prep_minutes = 20;
  int med_minutes = 1;
  String prep_label = '';

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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            onPressed: () async {
              // Use it as a dialog, passing in an optional initial time
              // and returning a promise that resolves to the duration
              // chosen when the dialog is accepted. Null when cancelled.
              Duration preparationDuration = await showDurationPicker(
                context: context,
                initialTime: new Duration(minutes: 20),
              );
              this.setState(
                () {
                  prep_label = '{$_duration.inHours}:{$_duration.inMinutes}';
                  _duration = preparationDuration;
                  prep_minutes = _duration.inSeconds;
                },
              );
              Scaffold.of(context).showSnackBar(new SnackBar(
                  content: new Text("Chose dura  tion: $preparationDuration")));
            },
            child: Text(
              'Preparation: $prep_label',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w900, color: Colors.red),
            ),
          ),
          FlatButton(
            onPressed: () async {
              // Use it as a dialog, passing in an optional initial time
              // and returning a promise that resolves to the duration
              // chosen when the dialog is accepted. Null when cancelled.
              Duration meditationDuration = await showDurationPicker(
                context: context,
                initialTime: new Duration(minutes: 20),
              );
              this.setState(
                () {
                  _duration = meditationDuration;
                  med_minutes = _duration.inSeconds;
                },
              );
              Scaffold.of(context).showSnackBar(new SnackBar(
                  content: new Text("Chose duration: $meditationDuration")));
            },
            child: Text(
              'Meditation time: $med_minutes',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w900, color: Colors.red),
            ),
          ),
          RaisedButton(
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
