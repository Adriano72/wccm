import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
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
  double preparationNoticeVisibility = 1.0;
  String beginEndSessionNotification = 'Session starting in a few seconds...';
  Timer timer;
  String bellSound = 'tibetan-bowl.mp3';
  dynamic playerState;

  @override
  void initState() {
    medDuration = widget.meditationTime;
    player.load(bellSound);
    // Checks if the AudioPlayer is playing. States available are AudioPlayerState.PLAYING (STOPPED or COMPLETED)
    // and disable screen lock is audio is STOPPED or COMPLETED and timerStarted is false (timer is not running)
    advancedPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      // TODO: Far si che a fine meditazione si  disabiliti il wakelock
      print('Current player state: $s');
      if (mounted) setState(() => playerState = s);
      if (!timerStarted &&
          (playerState == AudioPlayerState.COMPLETED ||
              playerState == AudioPlayerState.STOPPED)) {
        //Wakelock.disable();
      }
    });
    startTimer();
    super.initState();
  }

  String formatTime(Duration rawDuration) {
    if (rawDuration.inHours > 0) {
      return '${medDuration.inHours}:${medDuration.inMinutes.remainder(60)}:${medDuration.inSeconds.remainder(60)}';
    } else {
      return '${medDuration.inMinutes}:${medDuration.inSeconds.remainder(60)}';
    }
  }

  void startTimer() {
    Wakelock.enable();
    sessionCompleted = false;
    const oneSec = const Duration(seconds: 1);
    Future.delayed(const Duration(seconds: 7), () {
      isPreparationTime = false;
      if (mounted)
        setState(() {
          preparationNoticeVisibility = 0.0;
          beginEndSessionNotification = 'Session completed!';
        });
      if (mounted) player.play(bellSound);
      timer = Timer.periodic(
        oneSec,
        (timer) {
          if (mounted) {
            timerStarted = true;
            setState(
              () {
                if (medDuration.inSeconds < 1) {
                  player.play(bellSound);
                  timer.cancel();
                  timerStarted = false;
                  sessionCompleted = true;
                  preparationNoticeVisibility = 1.0;
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
    print("DISPOSE*********");
    Wakelock.disable();
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
      backgroundColor: Colors.blueGrey,
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
                    color: Colors.white70,
                    height: 1.3,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              CircularPercentIndicator(
                circularStrokeCap: CircularStrokeCap.round,
                radius: 180.0,
                lineWidth: 12.0,
                percent: timePercent,
                center: Text(
                  formatTime(medDuration),
                  style: TextStyle(
                    fontSize: 28,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
                progressColor: Colors.amberAccent,
              ),
              Opacity(
                opacity: preparationNoticeVisibility,
                child: Text(beginEndSessionNotification),
              ),
              Flexible(
                child: RaisedButton(
                  color: Colors.amber,
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
