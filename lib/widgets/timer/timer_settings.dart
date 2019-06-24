import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:audioplayers/audio_cache.dart';

class TimerSettings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TimerSettingsState();
  }
}

class _TimerSettingsState extends State<TimerSettings> {
  Duration _prep_duration = Duration(hours: 0, minutes: 0);
  Duration _med_duration = Duration(hours: 0, minutes: 0);
  int prep_seconds = 5;
  int med_hours = 0;
  int med_minutes = 0;
  bool timerStarted = false;
  Timer _timer;

  static AudioCache player = AudioCache(prefix: 'sounds/');

  @override
  void initState() {
    player.load('LaurenceBowlEnd.mp3');
    super.initState();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    Timer.periodic(
      oneSec,
      (_timer) => setState(
            () {
              if (_med_duration.inSeconds < 1) {
                _timer.cancel();
                timerStarted = false;
              } else {
                this.setState(() => _med_duration = _med_duration - oneSec);
                print("Time left: $_med_duration");
              }
            },
          ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String formatTime(Duration rawDuration) {
    if (rawDuration.inHours > 0) {
      return '${_med_duration.inHours}:${_med_duration.inMinutes}:${_med_duration.inSeconds.remainder(60)}';
    } else {
      return '${_med_duration.inMinutes}:${_med_duration.inSeconds.remainder(60)}';
    }
  }

  _storePrepTime(_prepTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int preparationTime = _prepTime;
    await prefs.setInt('counter', preparationTime);
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
                    Duration meditationDuration = await showDurationPicker(
                      context: context,
                      initialTime: _med_duration,
                    );
                    this.setState(
                      () {
                        _med_duration = meditationDuration;
                        med_hours = _med_duration.inHours;
                        med_minutes = _med_duration.inMinutes;

                        print("Med hours: $med_hours");
                        print("Med minutes: $med_minutes");
                      },
                    );
                    //Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Chose duration: $meditationDuration")));
                  },
                  child: Text(
                    !timerStarted
                        ? 'MEDITATION: ${_med_duration.inHours}:${_med_duration.inMinutes}'
                        : formatTime(_med_duration),
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
            color: Colors.deepOrange,
            onPressed: () {
              if (timerStarted) {
                _timer.cancel();
                this.setState(
                  () => timerStarted = false,
                );
              } else {
                player.play('LaurenceBowlEnd.mp3');
                this.setState(
                  () => timerStarted = true,
                );
                print("BUTTON PRESSED");
                startTimer();
              }
            },
            child: timerStarted ? Text("Stop") : Text("Start"),
          ),
        ],
      ),
    );
  }
}
