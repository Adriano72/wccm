import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:toast/toast.dart';
import 'package:wakelock/wakelock.dart';

import 'package:wccm/widgets/timer/timer_run.dart';

class TimerSettings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TimerSettingsState();
  }
}

class _TimerSettingsState extends State<TimerSettings> {
  Duration medDuration = Duration(hours: 0, minutes: 20);
  int medHours = 0;
  int medMinutes = 0;
  bool timerStarted = false;
  Timer timer;
  dynamic playerState;

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
    // Checks if the AudioPlayer is playing. States available are AudioPlayerState.PLAYING (STOPPED or COMPLETED)
    // and disable screen lock is audio is STOPPED or COMPLETED and timerStarted is false (timer is not running)
    advancedPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      print('Current player state: $s');
      setState(() => playerState = s);
      if (!timerStarted &&
          (playerState == AudioPlayerState.COMPLETED ||
              playerState == AudioPlayerState.STOPPED)) {
        Wakelock.toggle(on: false);
      }
    });
    super.initState();
  }

  void startTimer() {
    Wakelock.toggle(on: true);
    const oneSec = const Duration(seconds: 1);
    Future.delayed(const Duration(seconds: 1), () {
      player.play('LaurenceBowlEnd.mp3');
      timer = Timer.periodic(
        oneSec,
        (timer) => setState(
          () {
            if (medDuration.inSeconds < 1) {
              player.play('LaurenceBowlEnd.mp3');
              timer.cancel();
              timerStarted = false;
              showToast('Session ended');
              _getStoredMedTime();
            } else {
              this.setState(() => medDuration = medDuration - oneSec);
              print("Time left: $medDuration");
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
      return '${medDuration.inHours}:${medDuration.inMinutes.remainder(60)}:${medDuration.inSeconds.remainder(60)}';
    } else {
      return '${medDuration.inMinutes}:${medDuration.inSeconds.remainder(60)}';
    }
  }

  void _storeMedTime(int hours, int minutes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('timerPresetHours', hours);
    await prefs.setInt('timerPresetsMinutes', minutes.remainder(60));
    print('MEDITATION TIME STORED!!!!!');
  }

  //TODO Fare in modo che il timer i presenti con l'ultimo tempo selezionato

  Future<Map> _getStoredMedTime() async {
    print('MEDITATION TIME GOTTEN!!!!!');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, int> storedTime = {};
    int storedMedTimeHour = (prefs.getInt('timerPresetHours'));
    int storedMedTimeMinutes = (prefs.getInt('timerPresetsMinutes'));
    storedTime = {'hours': storedMedTimeHour, 'minutes': storedMedTimeMinutes};
    setState(() {
      medDuration =
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
          /*Image.asset('assets/images/bowl.png',
              width: MediaQuery.of(context).size.width * 0.3),*/
          Flexible(
            child: DurationPicker(
              duration: medDuration,
              onChange: (meditationDuration) {
                print('on change****************');
                try {
                  if (meditationDuration != null) {
                    this.setState(
                      () {
                        medDuration = meditationDuration;
                        medHours = medDuration.inHours;
                        medMinutes = medDuration.inMinutes.remainder(60);

                        print("Med hours: $medHours");
                        print("Med minutes: $medMinutes");
                      },
                    );
                  } else {
                    this.setState(
                      () => medDuration = Duration(minutes: 1),
                    );
                  }
                  _storeMedTime(
                      meditationDuration.inHours, meditationDuration.inMinutes);
                } catch (e) {
                  print(e);
                }
              },
              snapToMins: 1.0,
            ),
          ),
          Flexible(
            child: RaisedButton(
              color: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TimerRun(
                              meditationTime: medDuration,
                            )));
              },
              child: timerStarted ? Text("Stop") : Text("Start"),
            ),
          ),
        ],
      ),
    );
  }
}
