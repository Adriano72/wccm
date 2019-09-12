import 'package:flutter/material.dart';
import 'package:wccm/constants.dart';
import 'dart:math' as math;
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:wccm/models/audio_data.dart';

class JohnMainTalks extends StatefulWidget {
  @override
  _JohnMainTalksState createState() => _JohnMainTalksState();
}

class _JohnMainTalksState extends State<JohnMainTalks> {
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
              style: kJMTalksPersistentHeader,
            ))),
      ),
    );
  }

  void initState() {
    advancedPlayer.onPlayerCompletion.listen((onData) {
      Provider.of<AudioData>(context).setStoppedState();
//            audioState = 'stopped';
      Provider.of<AudioData>(context).rewindToZero();
//            position = Duration(milliseconds: 0);
    });

    advancedPlayer.onDurationChanged.listen((Duration d) {
      Provider.of<AudioData>(context).setAudioDuration(d);
//            if (mounted) setState(() => maxDuration = d);
      print("_______________________ ${Provider.of<AudioData>(context).audioDuration}");
    });

    advancedPlayer.onAudioPositionChanged.listen((Duration p) {
      Provider.of<AudioData>(context).setAudioPosition(p);
//            setState(() => position = p);
    });
    super.initState();
  }

  @override
  void dispose() {
    //advancedPlayer.stop();
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
    void _onTrackSelected(String url) {
      player.load(url);

      showModalBottomSheet<void>(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: Color(0xFF455A64),
        builder: (BuildContext context) {
          return Container(
            height: 180,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ClipOval(
                        child: Material(
                          color: Colors.blueGrey, // button color
                          child: InkWell(
                            splashColor: Color(0xFFCFD8DC), // inkwell color
                            child: SizedBox(
                              width: 45,
                              height: 45,
                              child: (Provider.of<AudioData>(context).audioState == 'playing')
                                  ? Icon(Icons.pause)
                                  : Icon(Icons.play_arrow),
                            ),
                            onTap: () {
                              if (Provider.of<AudioData>(context).audioState == 'playing') {
                                advancedPlayer.pause();
                                Provider.of<AudioData>(context).setPausedState();
                              } else if (Provider.of<AudioData>(context).audioState == 'paused') {
                                advancedPlayer.resume();
                                Provider.of<AudioData>(context).setPlayingState();
                              } else if (Provider.of<AudioData>(context).audioState == 'stopped') {
                                player.play(url);
                                Provider.of<AudioData>(context).setPlayingState();
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
                              width: 45,
                              height: 45,
                              child: Icon(Icons.stop),
                            ),
                            onTap: () {
                              if (mounted) {
                                Provider.of<AudioData>(context).setStoppedState();
                                Provider.of<AudioData>(context).rewindToZero();
                                advancedPlayer.stop();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Slider(
                    value: Provider.of<AudioData>(context).audioPosition?.inMilliseconds?.toDouble(),
                    activeColor: Colors.amber,
                    inactiveColor: Color(0xFFCFD8DC),
                    onChanged: (double value) {
                      advancedPlayer.seek(Duration(milliseconds: value.toInt()));
                      Provider.of<AudioData>(context).setAudioPosition(Duration(milliseconds: value.toInt()));
                    },
                    min: 0.0,
                    max: Provider.of<AudioData>(context).audioDuration?.inMilliseconds?.toDouble(),
                  ),
                ),
              ],
            ),
          );
        },
      ).whenComplete(() {
        advancedPlayer.onAudioPositionChanged.drain();
        advancedPlayer.stop();
        Provider.of<AudioData>(context).rewindToZero();
        Provider.of<AudioData>(context).setStoppedState();
      });
    }

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Color(0xFF455A64),
              title: Text(
                'John Main Talks',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              pinned: true,
              expandedHeight: 200.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(children: <Widget>[
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/JMGardenStandingOverlayed.jpg',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
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
                    _onTrackSelected,
                    'for_meditation/The_Basic_Doctrine.mp3',
                  ),
                  AudioListTile(
                    'To Set Our Minds On The Kingdom Of God',
                    '4:25',
                    _onTrackSelected,
                    'for_meditation/03 To Set Our Minds on the Kingdom of God.mp3',
                  ),
                  AudioListTile(
                    'How Long Does It Take',
                    '3:34',
                    _onTrackSelected,
                    'for_meditation/04 How Long Does It Take.mp3',
                  ),
                  AudioListTile(
                    'Leaving Self Behind',
                    '4:43',
                    _onTrackSelected,
                    'for_meditation/05 Leaving Self Behind.mp3',
                  ),
                  AudioListTile(
                    'Fullness Of Being',
                    '3:14',
                    _onTrackSelected,
                    'for_meditation/06 Fullness of Being.mp3',
                  ),
                ],
              ),
            ),
            makeHeader('Complete talks by John Main from his Collected Talks', false),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  AudioListTile(
                    'Being Restored To Ourselves',
                    '18:14',
                    _onTrackSelected,
                    'complete/01 - Being Restored To Ourselves.mp3',
                  ),
                  AudioListTile(
                    'In Reverence In Your Hearts',
                    '15:26',
                    _onTrackSelected,
                    'complete/01 - In Reverence In Your Hearts.mp3',
                  ),
                  AudioListTile(
                    'Making Progress',
                    '17:15',
                    _onTrackSelected,
                    'complete/01 - Making Progress.mp3',
                  ),
                  AudioListTile(
                    'Peace',
                    '16:19',
                    _onTrackSelected,
                    'complete/01 - Peace.mp3',
                  ),
                  AudioListTile(
                    'Still A Beginner',
                    '15:05',
                    _onTrackSelected,
                    'complete/01 - Still A Beginner.mp3',
                  ),
                  AudioListTile(
                    'The Art Of Unlearning',
                    '16:57',
                    _onTrackSelected,
                    'complete/01 - The Art Of Unlearning.mp3',
                  ),
                  AudioListTile(
                    'The Way Of The Mantra',
                    '18:04',
                    _onTrackSelected,
                    'complete/01 - The Way Of The Mantra.mp3',
                  ),
                  AudioListTile(
                    'Baptism : Water And Spirit',
                    '19:27',
                    _onTrackSelected,
                    'complete/02 - Baptism _ Water And Spirit.mp3',
                  ),
//                  ListTile(),
//                  ListTile(),
//                  ListTile(),
//                  ListTile(),
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
      leading: Icon(
        Icons.play_arrow,
      ),
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
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
