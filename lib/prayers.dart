import 'package:flutter/material.dart';
import 'dart:io';
import 'package:wccm/constants.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class Prayers extends StatefulWidget {
  @override
  _PrayersState createState() => _PrayersState();
}

class _PrayersState extends State<Prayers> {
  String introAudio = 'intro_med_forapp_cbr.mp3';
  String audioState = 'stopped';
  Duration position = Duration(milliseconds: 0);
  Duration duration = Duration(milliseconds: 59000);

  @override
  void initState() {
    player.load(introAudio);

    advancedPlayer.onDurationChanged.listen((Duration d) {
      print('Max duration: ${d.inMilliseconds}');
      if (mounted) setState(() => duration = d);
    });

    advancedPlayer.onPlayerCompletion.listen((onData) {
      if (mounted)
        setState(() {
          audioState = 'stopped';
          position = Duration(milliseconds: 0);
        });
    });

    advancedPlayer.onAudioPositionChanged.listen((Duration p) {
      print('Current position: ${p.inMilliseconds}');
      if (mounted) setState(() => position = p);
    });
    //getAudioDuration();
    super.initState();
  }

  @override
  void dispose() {
    advancedPlayer.stop();
    super.dispose();
  }

  static AudioPlayer advancedPlayer = AudioPlayer();
  AudioCache player = AudioCache(
    prefix: 'sounds/',
    fixedPlayer: advancedPlayer,
    respectSilence: false,
  );

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Text(
            'How to meditate & Prayers',
            style: TextStyle(color: Colors.white70),
          ),
          backgroundColor: kBackgroundColor,
          iconTheme: IconThemeData(color: Colors.white70),
        ),
      ),
      body: SafeArea(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Card(
              elevation: 4,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.asset(
                    'assets/images/MedInstructionsFinal.jpg',
                    fit: BoxFit.fill,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 15, right: 20, top: 20, bottom: 10),
                    child: Text(
                      'Meditation Instructions',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  Text(
                    'By Laurence Freeman OSB',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ClipOval(
                          child: Material(
                            color: Colors.blueGrey, // button color
                            child: InkWell(
                              splashColor: Color(0xFFCFD8DC), // inkwell color
                              child: SizedBox(
                                width: 56,
                                height: 56,
                                child: (audioState == 'playing')
                                    ? Icon(Icons.pause)
                                    : Icon(Icons.play_arrow),
                              ),
                              onTap: () {
                                if (audioState == 'playing') {
                                  advancedPlayer.pause();
                                  setState(
                                    () {
                                      audioState = 'paused';
                                    },
                                  );
                                } else if (audioState == 'paused') {
                                  advancedPlayer.resume();
                                  setState(
                                    () {
                                      audioState = 'playing';
                                    },
                                  );
                                } else if (audioState == 'stopped') {
                                  player.play(introAudio);
                                  setState(
                                    () {
                                      audioState = 'playing';
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        ClipOval(
                          child: Material(
                            color: Colors.blueGrey, // button color
                            child: InkWell(
                              splashColor: Color(0xFFCFD8DC), // inkwell color
                              child: SizedBox(
                                width: 56,
                                height: 56,
                                child: Icon(Icons.stop),
                              ),
                              onTap: () {
                                setState(() {
                                  audioState = 'stopped';
                                  position = Duration(milliseconds: 0);
                                });
                                advancedPlayer.stop();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Slider(
                    value: position?.inMilliseconds?.toDouble() ?? 0.0,
                    activeColor: Colors.amber,
                    inactiveColor: Color(0xFFCFD8DC),
                    onChanged: (double value) {
                      print('POSITION: $position');
                      advancedPlayer
                          .seek(Duration(milliseconds: value.toInt()));
                      if (Platform.isAndroid) {
                        setState(() {
                          position = Duration(milliseconds: value.toInt());
                        });
                      }
                    },
                    min: 0.0,
                    max: 60000,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            _createPrayerCard(
                'assets/images/johnMainPic.png',
                'Opening Prayer',
                'By John Main OSB',
                "Heavenly Father, open our hearts to the silent presence of the spirit of your Son. Lead us into that mysterious silence where your love is revealed to all who call, 'Maranatha…Come, Lord Jesus'."),
            SizedBox(height: 10.0),
            _createPrayerCard(
                'assets/images/laurencePic.png',
                'Closing Prayer',
                'By Laurence Freeman OSB',
                'May this group be a true spiritual home for the seeker, a friend for the lonely, a guide for the confused. May those who pray here be strengthened by the Holy Spirit to serve all who come and to receive them as Christ, Himself. In the silence of this room may all the suffering, violence and confusion of the world encounter the power that will console, renew and uplift the human spirit. May this silence be a power to open the hearts of men and women to the vision of God, and so to each other, in love and peace, justice and human dignity. May the beauty of Divine Life fill this group and the hearts of all who pray here with joyful hope. May all who come here weighed down by the problems of humanity, leave, giving thanks for the wonder of human life. We make this prayer through Christ our Lord.'),
          ],
        ),
      ),
    );
  }
}

Card _createPrayerCard(
    String cardImage, String prayerTitle, String author, String prayer) {
  Card createResCard = Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Stack(
            children: <Widget>[
              FittedBox(
                child: Image.asset(
                  cardImage,
                  width: 496.0,
                  height: 267.0,
                ),
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 15,
                left: 15,
                child: Text(
                  prayerTitle,
                  style: TextStyle(
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white70,
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, top: 20, bottom: 0),
            child: Text(
              author,
              style: TextStyle(
                fontSize: 12.0,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              prayer,
              style: kPrayersBodyTextStyle,
            ),
          )
        ],
      ));

  return createResCard;
}

//http://wccm.org/sites/default/files/mobilefeedspages/2019/WeeklyReadingsArchive.html
//http://wccm.org/sites/default/files/mobilefeedspages/2019/DailyWisdomArchive.html
//http://wccm.org/sites/default/files/mobilefeedspages/2019/WeeklyTeachingsArchive.html
//http://wccm.org/sites/default/files/mobilefeedspages/2019/MonthlyNewsArchive.html
