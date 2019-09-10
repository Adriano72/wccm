import 'package:flutter/material.dart';
import 'package:wccm/constants.dart';
import 'dart:io';
import 'dart:math' as math;
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class JohnMainTalks extends StatefulWidget {
  @override
  _JohnMainTalksState createState() => _JohnMainTalksState();
}

class _JohnMainTalksState extends State<JohnMainTalks> {
  String audioState = 'stopped';
  Duration position = Duration(milliseconds: 0);
  Duration duration = Duration(milliseconds: 59000);

  SliverPersistentHeader makeHeader(String headerText, bool pinned) {
    return SliverPersistentHeader(
      pinned: pinned,
      delegate: _SliverAppBarDelegate(
        minHeight: 60.0,
        maxHeight: 120.0,
        child: Container(
            padding: EdgeInsets.all(20),
            color: Color(0XFF455A64),
            child: Center(
                child: Text(
              headerText,
              style: kJMTalksPesistentHeader,
            ))),
      ),
    );
  }

  void initState() {
    advancedPlayer.onPlayerCompletion.listen(
      (event) {
        setState(() {
          audioState = 'stopped';
        });
      },
    );

    advancedPlayer.onDurationChanged.listen((Duration d) {
      print('Max duration: ${d.inMilliseconds}');
      if (mounted) setState(() => duration = d);
    });

    advancedPlayer.onPlayerCompletion.listen((onData) {
      if (mounted)
        setState(() {
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

  void playAudio(track) {
    player.play(track);
    setState(() {
      audioState = 'playing';
    });
  }

  @override
  void dispose() {
    advancedPlayer.stop();
    super.dispose();
  }

  static AudioPlayer advancedPlayer = AudioPlayer();
  AudioCache player = AudioCache(
    prefix: 'audio/',
    fixedPlayer: advancedPlayer,
    respectSilence: false,
  );

  @override
  Widget build(BuildContext context) {
    void _onButtonPressed(String url) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Theme(
              data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
              child: Container(
                color: Colors
                    .transparent, //TODO: Rendere gli angoli trasparenti con widget Theme
                height: 180,
                child: Container(
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            ClipOval(
                              child: Material(
                                color: Colors.blueGrey, // button color
                                child: InkWell(
                                  splashColor:
                                      Color(0xFFCFD8DC), // inkwell color
                                  child: SizedBox(
                                    width: 45,
                                    height: 45,
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
                                      playAudio(url);
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
                                  splashColor:
                                      Color(0xFFCFD8DC), // inkwell color
                                  child: SizedBox(
                                    width: 45,
                                    height: 45,
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
                          ;
                        },
                        min: 0.0,
                        max: 60000,
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Color(0XFF455A64),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(40),
                      topRight: const Radius.circular(40),
                    ),
                  ),
                ),
              ),
            );
          });
    }

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: false,
              expandedHeight: 250.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(children: <Widget>[
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/JMGardenStandingOverlayed.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    bottom: 25.0,
                    left: 25,
                    child: Container(
                      child: Text(
                        'John Main Talks',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 26,
                        ),
                      ),
                    ),
                  )
                ]),
              ),
            ),
            makeHeader(
                'These may be used for personal or group meditation. Each recorded talk was given as a preparation for meditation, either as an introduction or for experienced meditators.',
                false),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  AudioListTile(
                    'The Basic Doctrine',
                    '4:48',
                    _onButtonPressed,
                    'for_meditation/The_Basic_Doctrine.mp3',
                  ),
                  AudioListTile(
                    'To Set Our Minds On The Kingdom Of God',
                    '4:25',
                    _onButtonPressed,
                    'for_meditation/03 To Set Our Minds on the Kingdom of God.mp3',
                  ),
                  AudioListTile(
                    'How Long Does It Take',
                    '3:34',
                    _onButtonPressed,
                    'for_meditation/04 How Long Does It Take.mp3',
                  ),
                  AudioListTile(
                    'Leaving Self Behind',
                    '4:43',
                    _onButtonPressed,
                    'for_meditation/05 Leaving Self Behind.mp3',
                  ),
                  AudioListTile(
                    'Fullness Of Being',
                    '3:14',
                    _onButtonPressed,
                    'for_meditation/06 Fullness of Being.mp3',
                  ),
                ],
              ),
            ),
            makeHeader(
                'Complete talks by John Main from his Collected Talks', true),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  ListTile(
                    leading: Icon(Icons.play_arrow),
                    title: Text(
                      'Being Restored To Ourselves',
                      style: kJMTalksListTilesTitle,
                    ),
                    trailing: Text(
                      '18:14',
                      style: kJMTalksListTilesTrailing,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.play_arrow),
                    title: Text(
                      'In Reverence In Your Hearts',
                      style: kJMTalksListTilesTitle,
                    ),
                    trailing: Text(
                      '15:26',
                      style: kJMTalksListTilesTrailing,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.play_arrow),
                    title: Text(
                      'Making Progress',
                      style: kJMTalksListTilesTitle,
                    ),
                    trailing: Text(
                      '17:15',
                      style: kJMTalksListTilesTrailing,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.play_arrow),
                    title: Text(
                      'Peace',
                      style: kJMTalksListTilesTitle,
                    ),
                    trailing: Text(
                      '16:19',
                      style: kJMTalksListTilesTrailing,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.play_arrow),
                    title: Text(
                      'Still A Beginner',
                      style: kJMTalksListTilesTitle,
                    ),
                    trailing: Text(
                      '15:05',
                      style: kJMTalksListTilesTrailing,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.play_arrow),
                    title: Text(
                      'The Art Of Unlearning',
                      style: kJMTalksListTilesTitle,
                    ),
                    trailing: Text(
                      '16:57',
                      style: kJMTalksListTilesTrailing,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.play_arrow),
                    title: Text(
                      'The Way Of The Mantra',
                      style: kJMTalksListTilesTitle,
                    ),
                    trailing: Text(
                      '18:04',
                      style: kJMTalksListTilesTrailing,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.play_arrow),
                    title: Text(
                      'Baptism : Water And Spirit',
                      style: kJMTalksListTilesTitle,
                    ),
                    trailing: Text(
                      '19:27',
                      style: kJMTalksListTilesTrailing,
                    ),
                  ),
                  ListTile(),
                  ListTile(),
                  ListTile(),
                  ListTile(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AudioListTile extends StatelessWidget {
  final String title;
  final String time;
  final Function onTap;
  final String audioURL;

  AudioListTile(this.title, this.time, this.onTap, this.audioURL);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.play_arrow),
      title: Text(
        title,
        style: kJMTalksListTilesTitle,
      ),
      trailing: Text(
        time,
        style: kJMTalksListTilesTrailing,
      ),
      onTap: () => onTap(audioURL),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
