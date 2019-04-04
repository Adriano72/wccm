import "package:flutter/material.dart";
import "widgets/news_list.dart";

import 'widgets/timer/timer_settings.dart';

class Home extends StatefulWidget {
  final List news;

  Home({Key key, @required this.news}) : super(key: key);

  @override
  _HomeState createState() {
    return _HomeState(news: news);
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  List news = [];
  List newNews;

  _HomeState({@required this.news});

  @override
  void initState() {
    super.initState();
    setState(() {
      newNews = news;
    });
  }

  final List<Widget> _children = [
    ListPage(fetched_news: news),
    TimerSettings(),
    TimerSettings(),
  ];

  @override
  Widget _buildSideDrawer(BuildContext context) {
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
      body: _children[_currentIndex],
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
    setState(() {
      _currentIndex = index;
      print('CURRENT INDEX $_currentIndex');
    });
  }
}
