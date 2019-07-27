import "package:flutter/material.dart";
import "package:wccm/widgets/news/news_list.dart";
import 'package:flutter/services.dart';
import 'widgets/timer/timer_settings.dart';
import 'package:wccm/widgets/prayers.dart';
import 'package:url_launcher/url_launcher.dart';
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
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Links'),
          ),
          ListTile(
            leading: Icon(Icons.arrow_right),
            title: Text('WCCM Website'),
            onTap: () {
              _launchURL('https://wccm.org');
            },
          )
        ],
      ),
    );
  }

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
            title: Text('Prayers'),
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
