import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:wccm/widgets/timer/timer_run.dart';

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
    print('MEDITATION TIME STORED!!!!!');
  }

  Future<Duration> _getStoredMedTime() async {
    print('MEDITATION TIME GOTTEN!!!!!');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, int> storedTime = {};
    int storedMedTimeHour = (prefs.getInt('timerPresetHours'));
    int storedMedTimeMinutes = (prefs.getInt('timerPresetsMinutes'));
    storedTime = {'hours': storedMedTimeHour, 'minutes': storedMedTimeMinutes};
//    setState(() {
//      _medDuration =
//          Duration(hours: storedMedTimeHour, minutes: storedMedTimeMinutes);
//    });
    print(
        'STORED MED TIME IS ${_medDuration.inHours} HOURS AND ${_medDuration.inMinutes} MINUTES.');
    return Duration(hours: storedMedTimeHour, minutes: storedMedTimeMinutes);
    ;
  }

  @override
  Widget build(BuildContext context) {
    print("*******************");
    if (!_updatedFromPreferences) {
      // This is what we show while we're loading
      return new Container();
    }
    return Center(
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
                print('on change****************');
                try {
                  if (val != null) {
                    this.setState(
                      () {
                        _medDuration = val;
                        medHours = _medDuration.inHours;
                        medMinutes = _medDuration.inMinutes.remainder(60);

                        print("Med hours: $medHours");
                        print("Med minutes: $medMinutes");
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
              color: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TimerRun(
                              meditationTime: _medDuration,
                            )));
              },
              child: Text("Start"),
            ),
          ),
        ],
      ),
    );
  }
}
