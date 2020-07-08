import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:wccm/constants.dart';
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:wccm/models/audio_data.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';

import 'dart:developer' as logger;

class AlbumTracks extends StatefulWidget {
  final DocumentSnapshot album;
  AlbumTracks(this.album);
  @override
  _AlbumTracksState createState() => _AlbumTracksState();
}

class _AlbumTracksState extends State<AlbumTracks>
    with SingleTickerProviderStateMixin {
  Animation<Color> animation;
  AnimationController controller;
  File _cachedFile;

  Future<Null> downloadFile(
      String httpPath, String dirName, String fileName) async {
    logger.log('DOWNLOAD PARAMS: $httpPath $dirName $fileName');
    final Directory tempDir = Directory.systemTemp;
    final File file = File('${tempDir.path}/$fileName');

    final StorageReference ref =
        FirebaseStorage.instance.ref().child('$dirName/$fileName');
    final StorageFileDownloadTask downloadTask = ref.writeToFile(file);

    final int byteNumber = (await downloadTask.future).totalByteCount;

    print(byteNumber);

    setState(() => _cachedFile = file);
    logger.log('FILE: $file');
  }

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
    advancedPlayer.startHeadlessService();

    advancedPlayer.onPlayerCompletion.listen((onData) {
      Provider.of<AudioData>(context).setStoppedState();
//            audioState = 'stopped';
      Provider.of<AudioData>(context).rewindToZero();
//            position = Duration(milliseconds: 0);
    });

    advancedPlayer.onDurationChanged.listen((Duration d) {
      //print('___________DURATION $d');
      Provider.of<AudioData>(context).setAudioDuration(d);
    });

    advancedPlayer.onAudioPositionChanged.listen((Duration p) {
      //print('___________POSITION $p');
      Provider.of<AudioData>(context).setAudioPosition(p);
    });

    advancedPlayer.onPlayerError.listen((msg) {
      logger.log('audioPlayer error : $msg');
    });
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    final CurvedAnimation curve =
        CurvedAnimation(parent: controller, curve: Curves.linear);
    animation = ColorTween(begin: Colors.black87, end: Colors.amberAccent)
        .animate(curve);
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
      setState(() {});
    });
    controller.forward();
    super.initState();
  }

  _launchURL(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (error) {
      print('No internet!! cause of: $error');
    }
  }

  @override
  void dispose() {
    advancedPlayer.stop();
    controller.dispose();
    super.dispose();
  }

  AudioPlayer advancedPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    void _onTrackSelected(String url, String audioTitle) {
      advancedPlayer.setUrl(url);
      logger.log('ON TRACK SELECTED + ${advancedPlayer.state}');
      showModalBottomSheet<void>(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: Color(0xFF455A64),
        builder: (BuildContext context) {
          return Container(
            height: 210,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 35, right: 35, top: 30, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          audioTitle,
                          style: TextStyle(),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Image.network(
                        widget.album['artwork']['url'],
                        height: 40,
                      ),
                      ClipOval(
                        child: Material(
                          color: Colors.blueGrey, // button color
                          child: InkWell(
                            splashColor: Color(0xFFCFD8DC), // inkwell color
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: (Provider.of<AudioData>(context)
                                          .audioState ==
                                      'playing')
                                  ? AnimatedBuilder(
                                      animation: animation,
                                      builder:
                                          (BuildContext context, Widget child) {
                                        return new Container(
                                          child: Icon(
                                            Icons.play_arrow,
                                            color: animation.value,
                                          ),
                                        );
                                      },
                                    )
                                  : Icon(
                                      Icons.play_arrow,
                                    ),
                            ),
                            onTap: () {
                              if (Provider.of<AudioData>(context).audioState ==
                                  'playing') {
                                advancedPlayer.pause();
                                controller.stop();
                                Provider.of<AudioData>(context)
                                    .setPausedState();
                              } else {
                                advancedPlayer.resume();
                                controller.forward();
                                Provider.of<AudioData>(context)
                                    .setPlayingState();
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
                              width: 40,
                              height: 40,
                              child: Icon(Icons.stop),
                            ),
                            onTap: () {
                              if (mounted) {
                                Provider.of<AudioData>(context)
                                    .setStoppedState();
                                Provider.of<AudioData>(context).rewindToZero();
                                advancedPlayer.stop();
                                controller.stop();
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
                    value: Provider.of<AudioData>(context)
                        .audioPosition
                        ?.inMilliseconds
                        ?.toDouble(),
                    activeColor: Colors.amber,
                    inactiveColor: Color(0xFFCFD8DC),
                    onChanged: (double value) {
                      advancedPlayer
                          .seek(Duration(milliseconds: value.toInt()));
                      Provider.of<AudioData>(context).setAudioPosition(
                          Duration(milliseconds: value.toInt()));
                    },
                    min: 0.0,
                    max: Provider.of<AudioData>(context)
                        .audioDuration
                        ?.inMilliseconds
                        ?.toDouble(),
                  ),
                ),
              ],
            ),
          );
        },
      ).whenComplete(() {
        advancedPlayer
            .resume(); // Necessario perchè solo con stop non esce dallo stato paused e non riavvolge il tempo
        advancedPlayer.stop();
        advancedPlayer.onAudioPositionChanged.drain();

        advancedPlayer.release();
        logger.log('ON COMPLETE + ${advancedPlayer.state}');
        controller.stop();
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
              pinned: true,
              expandedHeight: Device.get().isTablet ? 600 : 350.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(children: <Widget>[
                  Positioned.fill(
                    child: Image.network(
                      widget.album['artwork']['url'],
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    height: 350.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        gradient: LinearGradient(
                            begin: FractionalOffset.bottomCenter,
                            end: FractionalOffset.topCenter,
                            colors: [
                              Colors.grey.withOpacity(0.0),
                              Colors.black.withOpacity(0.7),
                            ],
                            stops: [
                              0.0,
                              1.0
                            ])),
                  )
                ]),
              ),
            ),
            SliverStickyHeader(
              header: Container(
                  color: Color(0xFF455A64),
                  padding: EdgeInsets.all(20.0),
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      Text(
                        widget.album['title'],
                        style: kMeditatiotalksDetailHeaderTitle,
                      ),
                      Container(
                        height: 5,
                      ),
                      Text(
                        "By ${widget.album['teacher']}",
                        style: kMeditatiotalksDetailSeries,
                        textAlign: TextAlign.left,
                      ),
                      Container(
                        height: 5,
                      ),
                      Text(
                        "Meditatio Talks Series ${widget.album['year']}",
                        style: kMeditatiotalksDetailSeries,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  )),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return AudioListTile(
                      widget.album['tracks'][index]['title'],
                      _onTrackSelected,
                      downloadFile,
                      widget.album['tracks'][index]['url'],
                      widget.album['tracks'][index]['fileName'],
                      widget.album['_storage_folder'],
                      index + 1,
                    );
                  },
                  childCount: widget.album['tracks'].length,
                ),
              ),
            ),
            makeHeader(
                'The tracks on this playlist are intended solely for personal non-commercial use. By downloading tracks from this playlist you agree to use the downloaded files only for personal, non-commercial use.',
                false),
          ],
        ),
      ),
    );
  }
}

class AudioListTile extends StatelessWidget {
  final String title;
  final Function onTap;
  final Function downloadFunc;
  final String audioURL;
  final String fileName;
  final String dirName;
  int progressive;

  AudioListTile(this.title, this.onTap, this.downloadFunc, this.audioURL,
      this.fileName, this.dirName, this.progressive);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      /*leading: Icon(
        Icons.play_arrow,
      ),*/
      leading: Padding(
        padding: const EdgeInsets.only(top: 5.0, left: 10.0),
        child: Text(
          progressive.toString(),
          style: kJMTalksListTilesTitle,
        ),
      ),
      title: Text(
        title,
        style: kJMTalksListTilesTitle,
      ),
      //onTap: () => onTap(audioURL, title),
      onTap: () async {
        await downloadFunc(audioURL, dirName, fileName);
        onTap(audioURL, title);
      },
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
