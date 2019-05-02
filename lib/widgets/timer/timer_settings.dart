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
  int minutes = 20;

  Timer _timer;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              if (minutes < 1) {
                timer.cancel();
              } else {
                minutes = minutes - 1;
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
              Duration resultingDuration = await showDurationPicker(
                context: context,
                initialTime: new Duration(minutes: 20),
              );
              this.setState(
                () {
                  _duration = resultingDuration;
                  minutes = _duration.inSeconds;
                },
              );
              Scaffold.of(context).showSnackBar(new SnackBar(
                  content: new Text("Chose duration: $resultingDuration")));
            },
            child: Text(
              '$minutes',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w900, color: Colors.red),
            ),
          ),
          RaisedButton(
            onPressed: () {
              startTimer();
            },
            child: Text("start"),
          ),
        ],
      ),
    );
  }
}
