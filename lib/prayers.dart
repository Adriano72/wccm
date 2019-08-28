import 'package:flutter/material.dart';
import 'package:wccm/constants.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class Prayers extends StatefulWidget {
  @override
  _PrayersState createState() => _PrayersState();
}

class _PrayersState extends State<Prayers> {
  String introAudio = 'intro_med_forapp.mp3';
  @override
  void initState() {
    player.load(introAudio);
    super.initState();
  }

  static AudioPlayer advancedPlayer = AudioPlayer();
  AudioCache player = AudioCache(
      respectSilence: false, prefix: 'sounds/', fixedPlayer: advancedPlayer);

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
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            _createAudioCard(),
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
              style: TextStyle(
                height: 1.2,
                fontSize: 18,
                //fontWeight: FontWeight.w700,
                color: Colors.blueGrey,
              ),
            ),
          )
        ],
      ));

  return createResCard;
}

Card _createAudioCard() {
  Card createResCard = Card(
      elevation: 4,
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Image.asset(
            'assets/images/medtitationInstructions.png',
            fit: BoxFit.fill,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, top: 20, bottom: 0),
            child: Text(
              'Meditation Instructions',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ClipOval(
                  child: Material(
                    color: Colors.blueGrey, // button color
                    child: InkWell(
                      splashColor: Colors.blueAccent, // inkwell color
                      child: SizedBox(
                          width: 56, height: 56, child: Icon(Icons.play_arrow)),
                      onTap: () {},
                    ),
                  ),
                ),
                ClipOval(
                  child: Material(
                    color: Colors.blueGrey, // button color
                    child: InkWell(
                      splashColor: Colors.lightBlueAccent, // inkwell color
                      child: SizedBox(
                          width: 56, height: 56, child: Icon(Icons.stop)),
                      onTap: () {},
                    ),
                  ),
                ),
              ],
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
