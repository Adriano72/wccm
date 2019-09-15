import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:wccm/pages/timer/timer_run.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:wccm/constants.dart';
import 'package:wccm/models/bowls.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class TimerSettings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TimerSettingsState();
  }
}

class _TimerSettingsState extends State<TimerSettings> {
  Duration _medDuration = Duration(hours: 0, minutes: 20);
  bool _updatedFromPreferences = false;
  int medHours = 0;
  int medMinutes = 0;
  String audioState = 'stopped';
  String selectedSound = 'LaurenceBowl.mp3';
  int initialBellSelectorPage = 0;

  @override
  void initState() {
    advancedPlayer.stop();
    super.initState();
    for (Bowl track in bowls) {
      player.load(track.url);
    }
    _getStoredMedTime().then((result) {
      setState(() {
        _medDuration = result;
        _updatedFromPreferences = true;
      });
    });

    _getStoredBellSound().then((result) {
      setState(() {
        selectedSound = result[0];
        initialBellSelectorPage = result[1];
      });
    });
  }

  @override
  void dispose() {
    advancedPlayer.stop();
    super.dispose();
  }

  String formatTime(Duration rawDuration) {
    if (rawDuration.inHours > 0) {
      return '${_medDuration.inHours}:${_medDuration.inMinutes.remainder(60)}:${_medDuration.inSeconds.remainder(60)}';
    } else {
      return '${_medDuration.inMinutes}:${_medDuration.inSeconds.remainder(60)}';
    }
  }

  void _storeMedTime(int hours, int minutes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('timerPresetHours', hours);
    await prefs.setInt('timerPresetsMinutes', minutes.remainder(60));
  }

  void _storeBellSound(String url, int pageIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedBellSound', url);
    await prefs.setInt('initialBellSelectorPage', pageIndex);
  }

  Future<Duration> _getStoredMedTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int storedMedTimeHour = (prefs.getInt('timerPresetHours'));
    int storedMedTimeMinutes = (prefs.getInt('timerPresetsMinutes'));
    return Duration(
        hours: storedMedTimeHour ?? 0, minutes: storedMedTimeMinutes ?? 20);
  }

  Future<List> _getStoredBellSound() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedBellSound = (prefs.getString('selectedBellSound'));
    int storedCarouselPage = (prefs.getInt('initialBellSelectorPage'));
    return [storedBellSound, storedCarouselPage];
  }

  static AudioPlayer advancedPlayer = AudioPlayer();
  AudioCache player = AudioCache(
    prefix: 'bowls/',
    fixedPlayer: advancedPlayer,
    respectSilence: false,
  );

  _onSoundChanged(int index) {
    advancedPlayer.stop();
    setState(() {
      audioState = 'stopped';
      selectedSound = bowls[index].url;
    });
    _storeBellSound(bowls[index].url, index);
    print('SELECTED SOUND IS: $selectedSound');
  }

  @override
  Widget build(BuildContext context) {
    if (!_updatedFromPreferences) {
      return new Container(
        decoration: BoxDecoration(color: Colors.blueGrey),
      );
    }
    var carouselSlider = CarouselSlider(
      initialPage: initialBellSelectorPage ?? 0,
      enlargeCenterPage: true,
      enableInfiniteScroll: false,
      viewportFraction: 0.50,
      //aspectRatio: 9 / 2,
      height: 85,
      onPageChanged: _onSoundChanged,
      items: bowls.map(
        (item) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              color: Colors.blueGrey,
              onPressed: () {
                if (audioState == 'stopped') {
                  //player.load(item.url);
                  player.play(item.url);
                  setState(() {
                    audioState = 'playing';
                  });
                } else {
                  advancedPlayer.stop();
                  setState(() {
                    audioState = 'stopped';
                  });
                }
              },
              textColor: Colors.white,
              padding: const EdgeInsets.all(15.0),
              child: Text(item.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                  )),
              elevation: 5,
            ),
          );
        },
      ).toList(),
    );

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          /*Image.asset('assets/images/bowl.png',
              width: MediaQuery.of(context).size.width * 0.3),*/
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              'Bell Sound',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                height: 1.3,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          carouselSlider,
          Text(
            'Session time',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              height: 1.3,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          Flexible(
            child: DurationPicker(
              width: 240,
              duration: _medDuration,
              snapToMins: 1.0,
              onChange: (val) {
                try {
                  if (val != null) {
                    this.setState(
                      () {
                        _medDuration = val;
                        medHours = _medDuration.inHours;
                        medMinutes = _medDuration.inMinutes.remainder(60);
                      },
                    );
                  } else {
                    this.setState(
                      () => _medDuration = Duration(minutes: 1),
                    );
                  }
                  _storeMedTime(_medDuration.inHours, _medDuration.inMinutes);
                } catch (e) {
                  print(e);
                }
              },
            ),
          ),
          Flexible(
            child: RaisedButton(
              color: Colors.amber,
              elevation: 5,
              onPressed: () {
                advancedPlayer.stop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimerRun(
                      meditationTime: _medDuration,
                      soundUrl: selectedSound,
                    ),
                  ),
                );
              },
              child: Text(
                "Start",
                style: kButtonTextStyle,
              ),
            ),
          )
        ],
      ),
    );
  }
}
