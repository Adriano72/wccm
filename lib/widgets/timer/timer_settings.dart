import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:toast/toast.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';

class TimerSettings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TimerSettingsState();
  }
}

class _TimerSettingsState extends State<TimerSettings> {
  Duration medDuration = Duration(hours: 0, minutes: 20);
  int seconds = 1200;
  int prepSeconds = 5;
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
      ;
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
  }

  Future<Map> _getStoredMedTime() async {
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
          Flexible(child: SingleCircularSlider(60, seconds)

//            DurationPicker(
//              duration: medDuration,
//              onChange: (meditationDuration) {
//                try {
//                  if (meditationDuration != null) {
//                    this.setState(
//                      () {
//                        medDuration = meditationDuration;
//                        medHours = medDuration.inHours;
//                        medMinutes = medDuration.inMinutes.remainder(60);
//
//                        print("Med hours: $medHours");
//                        print("Med minutes: $medMinutes");
//                      },
//                    );
//                  } else {
//                    this.setState(
//                      () => medDuration = Duration(minutes: 1),
//                    );
//                  }
//                } catch (e) {
//                  print(e);
//                }
//              },
//              snapToMins: 5.0,
//            ),
              ),
          Flexible(
            child: FlatButton(
              onPressed: () async {
                // Use it as a dialog, passing in an optional initial time
                // and returning a promise that resolves to the duration
                // chosen when the dialog is accepted. Null when cancelled.
                Duration meditationDuration = await showDurationPicker(
                  context: context,
                  initialTime: medDuration,
                );

                _storeMedTime(
                    meditationDuration.inHours, meditationDuration.inMinutes);
                //Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Chose duration: $meditationDuration")));
              },
              child: Text(
                !timerStarted
                    ? 'MEDITATION TIME \n ${medDuration.inHours}:${medDuration.inMinutes.remainder(60)}'
                    : formatTime(medDuration),
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.3,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Rock Salt",
                ),
              ),
            ),
          ),
          //:TODO Gestire che il timer parta se il tempo è maggiore di zero !!
          Flexible(
            child: RaisedButton(
              //color: Colors.deepOrange,
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
          ),
        ],
      ),
    );
  }
}
