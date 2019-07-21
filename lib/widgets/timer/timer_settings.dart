import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:toast/toast.dart';
import 'package:wakelock/wakelock.dart';

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
  Timer timer;

  void showToast(String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }

  static AudioPlayer advancedPlayer = AudioPlayer();
  AudioCache player = AudioCache(
      respectSilence: false, prefix: 'sounds/', fixedPlayer: advancedPlayer);

  @override
  void initState() {
    player.load('LaurenceBowlEnd.mp3');
    _getStoredMedTime();
    super.initState();
  }

  void startTimer() {
    Wakelock.toggle(on: true);
    const oneSec = const Duration(seconds: 1);
    Future.delayed(const Duration(seconds: 10), () {
      player.play('LaurenceBowlEnd.mp3');
      timer = Timer.periodic(
        oneSec,
        (timer) => setState(
          () {
            if (_med_duration.inSeconds < 1) {
              player.play('LaurenceBowlEnd.mp3');
              timer.cancel();
              timerStarted = false;
              showToast('Session ended');
              _getStoredMedTime();
              Wakelock.toggle(on: false);
            } else {
              this.setState(() => _med_duration = _med_duration - oneSec);
              print("Time left: $_med_duration");
            }
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String formatTime(Duration rawDuration) {
    if (rawDuration.inHours > 0) {
      return '${_med_duration.inHours}:${_med_duration.inMinutes.remainder(60)}:${_med_duration.inSeconds.remainder(60)}';
    } else {
      return '${_med_duration.inMinutes}:${_med_duration.inSeconds.remainder(60)}';
    }
  }

  void _storeMedTime(int hours, int minutes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('timerPresetHours', hours);
    await prefs.setInt('timerPresetsMinutes', minutes.remainder(60));
  }

  Future<Map> _getStoredMedTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, int> storedTime = {};
    int storedMedTimeHour = (prefs.getInt('timerPresetHours'));
    int storedMedTimeMinutes = (prefs.getInt('timerPresetsMinutes'));
    storedTime = {'hours': storedMedTimeHour, 'minutes': storedMedTimeMinutes};
    setState(() {
      _med_duration =
          Duration(hours: storedMedTimeHour, minutes: storedMedTimeMinutes);
    });
    print(
        'STORED MED TIME IS ${storedTime['hours']} HOURS AND ${storedTime['minutes']} MINUTES.');
    return storedTime;
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
                    if (meditationDuration != null) {
                      this.setState(
                        () {
                          _med_duration = meditationDuration;
                          med_hours = _med_duration.inHours;
                          med_minutes = _med_duration.inMinutes.remainder(60);

                          print("Med hours: $med_hours");
                          print("Med minutes: $med_minutes");
                        },
                      );
                    }
                    _storeMedTime(meditationDuration.inHours,
                        meditationDuration.inMinutes);
                    //Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Chose duration: $meditationDuration")));
                  },
                  child: Text(
                    !timerStarted
                        ? 'MEDITATION TIME \n ${_med_duration.inHours}:${_med_duration.inMinutes.remainder(60)}'
                        : formatTime(_med_duration),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        height: 1.3,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Rock Salt",
                        color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
          //:TODO Gestire che il timer parta se il tempo è maggiore di zero
          RaisedButton(
            color: Colors.deepOrange,
            onPressed: () {
              if (timerStarted) {
                Wakelock.toggle(on: false);
                timer.cancel();
                advancedPlayer.stop();
                this.setState(
                  () => timerStarted = false,
                );
                _getStoredMedTime();
              } else {
                this.setState(
                  () => timerStarted = true,
                );
                print("BUTTON PRESSED");
                showToast('Session will start in 10 seconds...');
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
