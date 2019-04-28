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

  Timer _timer;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    int _seconds = _duration.inSeconds;
    _timer = Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              if (_seconds < 1) {
                timer.cancel();
              } else {
                _seconds = _seconds - 1;
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
          Expanded(
              // Use it from the context of a stateful widget, passing in
              // and saving the duration as a state variable.
              child: DurationPicker(
            duration: _duration,
            onChange: (val) {
              this.setState(() => _duration = val);
            },
            //snapToMins: 5.0,
          )),
          RaisedButton(
            onPressed: () {
              startTimer();
            },
            child: Text("start"),
          ),
          Text("$_duration"),
          RaisedButton(
            onPressed: () async {
              // Use it as a dialog, passing in an optional initial time
              // and returning a promise that resolves to the duration
              // chosen when the dialog is accepted. Null when cancelled.
              Duration resultingDuration = await showDurationPicker(
                context: context,
                initialTime: new Duration(minutes: 20),
              );
              this.setState(() => _duration = resultingDuration);
              Scaffold.of(context).showSnackBar(new SnackBar(
                  content: new Text("Chose duration: $resultingDuration")));
            },
            child: Text("Popup"),
          ),
        ],
      ),
    );
  }
}
