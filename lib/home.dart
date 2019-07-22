import "package:flutter/material.dart";
import "widgets/news_list.dart";
import 'package:flutter/services.dart';
import 'widgets/timer/timer_settings.dart';

class Home extends StatefulWidget {
  final List news;
  Home({Key key, @required this.news}) : super(key: key);

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
    //print("allnews__ $widget.news");
    _children = [
      ListPage(),
      TimerSettings(),
      TimerSettings(),
    ];
    super.initState();
  }

  Widget _buildSideDrawer(BuildContext context) {
    // This is the Drawer widget
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {},
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
        onTap: onTabTapped,
        currentIndex:
            _currentIndex, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.radio),
            title: new Text('News'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.timer),
            title: new Text('Timer'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_library), title: Text('Prayers'))
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    if (_currentIndex == 1) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    setState(() {
      _currentIndex = index;
      print('CURRENT INDEX $_currentIndex');
    });
  }
}
