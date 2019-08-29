import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:wccm/pages/timer/timer_run.dart';
import 'package:wccm/constants.dart';

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

  @override
  void initState() {
    super.initState();
    _getStoredMedTime().then((result) {
      setState(() {
        _medDuration = result;
        _updatedFromPreferences = true;
      });
    });
  }

  @override
  void dispose() {
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

  Future<Duration> _getStoredMedTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int storedMedTimeHour = (prefs.getInt('timerPresetHours'));
    int storedMedTimeMinutes = (prefs.getInt('timerPresetsMinutes'));

    return Duration(
        hours: storedMedTimeHour ?? 0, minutes: storedMedTimeMinutes ?? 20);
    ;
  }

  @override
  Widget build(BuildContext context) {
    if (!_updatedFromPreferences) {
      return new Container(
        decoration: BoxDecoration(color: Colors.blueGrey),
      );
    }
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            /*Image.asset('assets/images/bowl.png',
                width: MediaQuery.of(context).size.width * 0.3),*/

            SafeArea(
              child: Text(
                'Session time',
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.3,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
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
                color: Colors.indigo,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TimerRun(
                                meditationTime: _medDuration,
                              )));
                },
                child: Text(
                  "Start",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
