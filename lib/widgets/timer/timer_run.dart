import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:wccm/constants.dart';

class TimerRun extends StatefulWidget {
  final Duration meditationTime;

  TimerRun({@required this.meditationTime});

  @override
  _TimerRunState createState() => _TimerRunState();
}

class _TimerRunState extends State<TimerRun> {
  Duration medDuration = Duration(hours: 0, minutes: 20);
  bool timerStarted = false;
  bool isPreparationTime = true;
  bool sessionCompleted = false;
  double timePercent = 1.0;
  Timer timer;
  dynamic playerState;

  @override
  void initState() {
    medDuration = widget.meditationTime;
    player.load('LaurenceBowlEnd.mp3');
    // Checks if the AudioPlayer is playing. States available are AudioPlayerState.PLAYING (STOPPED or COMPLETED)
    // and disable screen lock is audio is STOPPED or COMPLETED and timerStarted is false (timer is not running)
    advancedPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      print('Current player state: $s');
      if (mounted) setState(() => playerState = s);
      if (!timerStarted &&
          (playerState == AudioPlayerState.COMPLETED ||
              playerState == AudioPlayerState.STOPPED)) {
        Wakelock.toggle(on: false);
      }
    });
    showToast('Session will start in 10 seconds...', 3);
  }

  void showToast(String message, int seconds) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: seconds,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0);

    super.initState();
    startTimer();
  }

  String formatTime(Duration rawDuration) {
    if (rawDuration.inHours > 0) {
      return '${medDuration.inHours}:${medDuration.inMinutes.remainder(60)}:${medDuration.inSeconds.remainder(60)}';
    } else {
      return '${medDuration.inMinutes}:${medDuration.inSeconds.remainder(60)}';
    }
  }

  void startTimer() {
    Fluttertoast.cancel();
    Wakelock.toggle(on: true);
    sessionCompleted = false;
    const oneSec = const Duration(seconds: 1);
    Future.delayed(const Duration(seconds: 10), () {
      isPreparationTime = false;
      if (mounted) player.play('LaurenceBowlEnd.mp3');
      timer = Timer.periodic(
        oneSec,
        (timer) {
          if (mounted) {
            timerStarted = true;
            setState(
              () {
                if (medDuration.inSeconds < 1) {
                  player.play('LaurenceBowlEnd.mp3');
                  timer.cancel();
                  timerStarted = false;
                  sessionCompleted = true;
                  showToast('Session completed', 3);
                } else {
                  medDuration = medDuration - oneSec;
                  updatePercentageIndicator();
                }
              },
            );
          }
        },
      );
    });
  }

  @override
  void dispose() {
    Fluttertoast.cancel();
    advancedPlayer.stop();
    super.dispose();
  }

  void updatePercentageIndicator() {
    int totalTimeInSeconds = widget.meditationTime.inSeconds;
    int timeLeft = (widget.meditationTime.inSeconds - medDuration.inSeconds);
    if (mounted) {
      setState(() {
        timePercent = timeLeft / totalTimeInSeconds;
      });
    }
  }

  static AudioPlayer advancedPlayer = AudioPlayer();
  AudioCache player = AudioCache(
      respectSilence: false, prefix: 'sounds/', fixedPlayer: advancedPlayer);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFd3d3d3),
      body: SafeArea(
        child: Center(
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SafeArea(
                child: Text(
                  'Meditation',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.3,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              CircularPercentIndicator(
                circularStrokeCap: CircularStrokeCap.round,
                radius: 180.0,
                lineWidth: 5.0,
                percent: timePercent,
                center: new Text(formatTime(medDuration)),
                progressColor: Colors.teal,
              ),
              Flexible(
                child: RaisedButton(
                  color: Colors.teal,
                  onPressed: () {
                    if (isPreparationTime) {
                      Wakelock.toggle(on: false);
                      advancedPlayer.stop();
                      Navigator.pop(context);
                      return;
                    }
                    if (timerStarted || sessionCompleted) {
                      Wakelock.toggle(on: false);
                      timer.cancel();
                      Fluttertoast.cancel();
                      advancedPlayer.stop();
                      Navigator.pop(context);
                    }
                  },
                  child: sessionCompleted
                      ? Text(
                          "Back",
                          style: kButtonTextStyle,
                        )
                      : Text(
                          "Stop",
                          style: kButtonTextStyle,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
