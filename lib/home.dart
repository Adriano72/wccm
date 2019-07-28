import "package:flutter/material.dart";
import "package:wccm/widgets/news/news_list.dart";
import 'package:flutter/services.dart';
import 'widgets/timer/timer_settings.dart';
import 'package:wccm/widgets/prayers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'constants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  List allNews;

  List<Widget> _children;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _children = [
      ListPage(),
      TimerSettings(),
      Prayers(),
    ];
    super.initState();
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildSideDrawer(BuildContext context) {
    // This is the Drawer widget
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              'The World Community for Christian Meditation',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            //accountEmail: Text('Links to our online resources'),
            currentAccountPicture: (CircleAvatar(
              backgroundColor: Colors.teal,
              radius: 190.0,
              backgroundImage: AssetImage(
                'assets/images/avatarImage.png',
              ),
            )),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(0.0),
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.web,
                    color: kDrawerIconsColor,
                  ),
                  title: Text('WCCM Website'),
                  onTap: () {
                    _launchURL('https://wccm.org');
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: kDrawerIconsColor,
                  ),
                  title: Text('Bonnevaux, our Home'),
                  onTap: () {
                    _launchURL('https://bonnevauxwccm.org/');
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.school,
                    color: kDrawerIconsColor,
                  ),
                  title: Text('The School of Meditation'),
                  onTap: () {
                    _launchURL('https://www.theschoolofmeditation.org/');
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.book,
                    color: kDrawerIconsColor,
                  ),
                  title: Text('Bookstore'),
                  onTap: () {
                    _launchURL('https://mediomedia.com');
                  },
                ),
                ListTile(
                  leading: Icon(
                    FontAwesomeIcons.solidBuilding,
                    color: kDrawerIconsColor,
                  ),
                  title: Text('The Meditatio Centre'),
                  onTap: () {
                    _launchURL('http://meditatiocentrelondon.org');
                  },
                ),
                ListTile(
                  leading: Icon(
                    FontAwesomeIcons.cross,
                    color: kDrawerIconsColor,
                  ),
                  title: Text('Oblates website'),
                  onTap: () {
                    _launchURL('http://oblates.wccm.org/v2019');
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    FontAwesomeIcons.youtube,
                    color: kDrawerIconsColor,
                  ),
                  title: Text('Youtube'),
                  onTap: () {
                    _launchURL('http://www.youtube.com/user/meditatiowccm');
                  },
                ),
                ListTile(
                  leading: Icon(
                    FontAwesomeIcons.facebook,
                    color: kDrawerIconsColor,
                  ),
                  title: Text('Facebook'),
                  onTap: () {
                    _launchURL(
                        'https://www.facebook.com/christian.meditation.wccm');
                  },
                ),
                ListTile(
                  leading: Icon(
                    FontAwesomeIcons.podcast,
                    color: kDrawerIconsColor,
                  ),
                  title: Text('Podcast'),
                  onTap: () {
                    _launchURL('https://wccm-podcasts.simplecast.com');
                  },
                ),
                ListTile(
                  leading: Icon(
                    FontAwesomeIcons.soundcloud,
                    color: kDrawerIconsColor,
                  ),
                  title: Text('SoundCloud'),
                  onTap: () {
                    _launchURL('https://soundcloud.com/wccm/');
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.email,
                    color: kDrawerIconsColor,
                  ),
                  title: Text('Contact us'),
                  onTap: () {
                    _launchURL('mailto://adriano@wccm.org');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
//
//  - WCCM Website
//  - Bonnevaux, our Home (please suggest changes in the text if you feel so)
//  - The School of Meditation
//  - Meditatio Centre (website)
//  - Bookstore (for Mediomedia website)
//  - Oblates Website
//  - YouTube (our channel)
//  - Facebook (our page) https://www.facebook.com/christian.meditation.wccm
//  - Podcast (https://wccm-podcasts.simplecast.com/)
//  - Flickr (just wondering...)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text('WCCM'),
      ),
      body: _children.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kBackgroundColor,
        onTap: onTabTapped,
        currentIndex:
            _currentIndex, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.radio,
            ),
            activeIcon: new Icon(
              Icons.radio,
              color: Colors.teal,
            ),
            title: Text('News'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.timer,
            ),
            activeIcon: Icon(
              Icons.timer,
              color: Colors.teal,
            ),
            title: Text('Timer'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.local_library,
            ),
            activeIcon: Icon(
              Icons.local_library,
              color: Colors.teal,
            ),
            title: Text('Resources'),
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {
//    if (_currentIndex == 1) {
//      SystemChrome.setPreferredOrientations([
//        DeviceOrientation.portraitUp,
//      ]);
//    } else {
//      SystemChrome.setPreferredOrientations([
//        DeviceOrientation.landscapeRight,
//        DeviceOrientation.landscapeLeft,
//        DeviceOrientation.portraitUp,
//        DeviceOrientation.portraitDown,
//      ]);
//    }
    setState(() {
      _currentIndex = index;
      print('CURRENT INDEX $_currentIndex');
    });
  }
}
