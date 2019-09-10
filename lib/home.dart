import "package:flutter/material.dart";
import "package:wccm/pages/news/news_list.dart";
import 'package:flutter/services.dart';
import 'pages/timer/timer_settings.dart';
import 'package:wccm/pages/resources.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'prayers.dart';
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
      TimerSettings(),
      NewsListPage(goToTimerTab),
      Resources(),
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

  Text _appBarTitleSwitcher() {
    switch (_currentIndex) {
      case 0:
        {
          return Text('Meditation Timer');
        }
        break;
      case 1:
        {
          return Text('WCCM News');
        }
        break;
      case 2:
        {
          return Text('Resources for your journey');
        }
        break;
      default:
        {
          return Text('WCCM');
        }
        break;
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
                  leading: Image.asset(
                    "assets/images/doves4.png",
                    width: 21.0,
                  ),
                  title: Text('WCCM'),
                  onTap: () {
                    _launchURL('https://wccm.org');
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    "assets/images/archesFinal13"
                    ".png",
                    width: 21.0,
                  ),
                  title: Text('Bonnevaux'),
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
                  leading: Image.asset(
                    "assets/images/meditatioCentre.png",
                    width: 21.0,
                  ),
                  title: Text('The Meditatio Centre'),
                  onTap: () {
                    _launchURL('http://meditatiocentrelondon.org');
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    "assets/images/oblates.png",
                    width: 21.0,
                  ),
                  title: Text('Oblates website'),
                  onTap: () {
                    _launchURL('http://oblates.wccm.org/');
                  },
                ),
                Divider(),
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
                    FontAwesomeIcons.youtube,
                    color: kDrawerIconsColor,
                  ),
                  title: Text('Video and other media'),
                  onTap: () {
                    _launchURL('https://wccm.org/media-page/');
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
                    FontAwesomeIcons.instagram,
                    color: kDrawerIconsColor,
                  ),
                  title: Text('Instagram'),
                  onTap: () {
                    _launchURL('https://www.instagram.com/wccm_meditatio/');
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    FontAwesomeIcons.handHoldingHeart,
                    color: kDrawerIconsColor,
                  ),
                  title: Text('Donate'),
                  onTap: () {
                    _launchURL(
                        'https://io-wccm.org/civicrm/contribute/transact?reset=1&id=11');
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.alternate_email,
                    color: kDrawerIconsColor,
                  ),
                  title: Text('Subscribe'),
                  onTap: () {
                    _launchURL('http://eepurl.com/tc5vH');
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.email,
                    color: kDrawerIconsColor,
                  ),
                  title: Text('Contact us'),
                  onTap: () {
                    _launchURL('mailto:adriano@wccm.org');
                  },
                ),
                SizedBox(
                  height: 40.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: _appBarTitleSwitcher(),
        actions: <Widget>[
          Visibility(
            visible: _currentIndex == 0,
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Prayers()));
                },
                child: Icon(FontAwesomeIcons.prayingHands),
              ),
            ),
          )
        ],
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
              Icons.timer,
            ),
            activeIcon: Icon(
              Icons.timer,
              color: Colors.white70,
            ),
            title: Text(
              'Timer',
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.radio,
            ),
            activeIcon: Icon(
              Icons.radio,
              color: Colors.white70,
            ),
            title: Text(
              'News',
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.local_library,
            ),
            activeIcon: Icon(
              Icons.local_library,
              color: Colors.white70,
            ),
            title: Text(
              'Resources',
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      print('CURRENT INDEX $_currentIndex');
    });
  }

  void goToTimerTab() {
    setState(() {
      _currentIndex = 0;
    });
  }
}
