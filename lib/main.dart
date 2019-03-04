import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
// Import flutter helper library
import 'package:http/http.dart' show get;
import 'models/news_model.dart';
import 'dart:convert';
//import 'widgets/image_list.dart';

import './home.dart';

void main() {
  //debugPaintSizeEnabled = true;
  //debugPaintBaselinesEnabled = true;
  //debugPaintPointersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final apiURL = 'https://cdn.contentful.com/spaces/4ptr806dzbcu/environments/master/entries?access_token=2e6a171e4a838eb9d8050a26f653c02c11124f24643eab62ff4d390cc914d9b8&include=1';
  Map allNews;
  List<NewsModel> allTheNews = [];
  String test = '';

  @override
  void initState() {
    fetchAllNews();
    super.initState();
  }

  void fetchAllNews() async {
    var response = await get('https://cdn.contentful.com/spaces/4ptr806dzbcu/environments/master/entries?access_token=2e6a171e4a838eb9d8050a26f653c02c11124f24643eab62ff4d390cc914d9b8&include=1');
    var allTheNews = NewsModel.fromJson(json.decode(response.body));
    
    setState(() {
      test = response.toString();
      print("ALL ITEMS $test");
    });    
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //debugShowMaterialGrid: true,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
      ),
      routes: {
        '/': (BuildContext context) => Home(),
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext context) => Home());
      },
    );
  }
}
