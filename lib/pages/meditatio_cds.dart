import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wccm/constants.dart';
import 'dart:math' as math;
import 'package:flutter/animation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'album_tracks.dart';

import 'package:wccm/repository/albumRepository.dart';

class MeditatioCDs extends StatefulWidget {
  @override
  _MeditatioCDsState createState() => _MeditatioCDsState();
}

class _MeditatioCDsState extends State<MeditatioCDs> {
  final AlbumRepository repository =
      AlbumRepository(); // Crea il riferimento al db Firestore
  Animation<Color> animation;
  AnimationController controller;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Color(0xFF455A64),
              title: Text(
                'Meditatio Talks Series',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              pinned: true,
              expandedHeight: Device.get().isTablet ? 500 : 130.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(children: <Widget>[
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/dove.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ]),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    color: Color(0xFF455A64),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'For many years and four times a year a Meditatio CD has been sent to each registered Christian Meditation group around the world. Below are the audio files (with transcripts) of these talks which have come from many different teachers in the community, including John Main and Laurence Freeman. To keep up with the times, these Meditation CDs are being offered  as audio files that can be simply downloaded and used at weekly groups.',
                        style: kMeditatiotalksHeaderTitle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: repository.getStream(),
                builder: (context, snapshot) {
                  Widget albumsListSliver;
                  if (!snapshot.hasData)
                    return SliverList(
                        delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 0.0),
                          children: <Widget>[
                            Container(
                              child: LinearProgressIndicator(),
                            ),
                          ],
                        );
                      },
                      childCount: 1,
                    ));

                  albumsListSliver = SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        DocumentSnapshot ds = snapshot.data.documents[index];
                        return AudioListTile(
                            context,
                            snapshot.data.documents[index],
                            ds['title'],
                            ds['artwork']['url']);
                        /*return Row(
                          textDirection: TextDirection.ltr,
                          children: <Widget>[
                            Expanded(child: Text(ds["title"])),
                          ],
                        );*/
                      },
                      childCount: snapshot.data.documents.length,
                    ),
                  );
                  return albumsListSliver;
                }),
          ],
        ),
      ),
    );
  }
}

class AudioListTile extends StatelessWidget {
  final BuildContext context;
  final DocumentSnapshot album;
  final String title;
  final String imageUrl;
  AudioListTile(this.context, this.album, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AlbumTracks(album)),
        );
      },
      leading: Image(
        image: NetworkImage(imageUrl),
        height: 40.0,
      ),
      title: Text(
        title,
        style: kJMTalksListTilesTitle,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.white70,
      ),
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
