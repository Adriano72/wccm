import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;
import '../../models/news_model.dart';
import 'news_detail.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'dart:convert';
import 'dart:async';
import 'package:wccm/constants.dart';

class NewsListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListPage();
  }
}

class _ListPage extends State<NewsListPage> {
  final apiURL =
      'https://cdn.contentful.com/spaces/4ptr806dzbcu/environments/master/entries?access_token=2e6a171e4a838eb9d8050a26f653c02c11124f24643eab62ff4d390cc914d9b8&order=-sys.createdAt&include=1';
  List<NewsModel> allTheNews = [];

  bool isConnected = false;

  Future checkConn() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result == true) {
      print('YAY! Free cute dog pics!');
      setState(() {
        isConnected = true;
      });
      fetchAllNews();
    } else {
      print('No internet :( Reason:');
      isConnected = false;

      print(DataConnectionChecker().lastTryResults);
    }
  }

  void fetchAllNews() async {
    print('_______IS CONNECTED: $isConnected');

    var response = await get(apiURL);
//    print('RESPONSE ${json.decode(response.body)}');
    var decodedResponse = json.decode(response.body);
    List itemsNode = decodedResponse['items'];
    List allAssets = decodedResponse['includes']['Asset'];

    itemsNode.forEach((item) {
//      print('ASSETS: $item');
      var imageId = item['fields']['image']['sys']['id'];
      Map<String, dynamic> urlNode = allAssets.firstWhere(
          (imgValue) => imgValue['sys']['id'] == imageId,
          orElse: () => null);
      var itemModel = NewsModel.fromJson(item, urlNode);
      setState(() {
        allTheNews.add(itemModel);
//        print('ALL THE NEWS $allTheNews');
      });
    });
  }

  @override
  void initState() {
    super.initState();
    checkConn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        children: <Widget>[
          Text('CAROUSEL HERE'),
          Expanded(
            child: ListView.builder(
              itemCount: allTheNews.length,
              itemBuilder: (BuildContext content, int index) {
                return ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage("${allTheNews[index].imageUrl}"),
                  ),
                  title: Text(
                    allTheNews[index].title,
                    style: kListTitle,
                  ),
                  subtitle: Text(
                    allTheNews[index].blurb,
                    overflow: TextOverflow.ellipsis,
                    style: kListBlurb,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetail(allTheNews[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
