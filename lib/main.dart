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
  final apiURL =
      'https://cdn.contentful.com/spaces/4ptr806dzbcu/environments/master/entries?access_token=2e6a171e4a838eb9d8050a26f653c02c11124f24643eab62ff4d390cc914d9b8&include=1';
  List<NewsModel> allTheNews = [];
  String test = '';

  @override
  void initState() {
    fetchAllNews();
    super.initState();
  }

  void fetchAllNews() async {
    var response = await get(apiURL);

    print('RESPONSE ${json.decode(response.body)}');

    var decodedResponse = json.decode(response.body);

    List itemsNode = decodedResponse['items'];

    List allAssets = decodedResponse['includes']['Asset'];

    itemsNode.forEach((item) {
      print('ASSETS: $item');
      var imageId = item['fields']['image']['sys']['id'];
      Map<String, dynamic> urlNode = allAssets.firstWhere(
          (imgValue) => imgValue['sys']['id'] == imageId,
          orElse: () => null);
      var itemModel = NewsModel.fromJson(item, urlNode);
      setState(() {
        allTheNews.add(itemModel);
        print('ALL THE NEWS $allTheNews');
      });
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
        '/': (BuildContext context) => Home(news: allTheNews),
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext context) => Home(news: allTheNews));
      },
    );
  }
}
